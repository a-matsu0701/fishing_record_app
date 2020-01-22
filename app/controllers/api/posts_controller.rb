class Api::PostsController < ApplicationController
  PER_PAGE = 9

  before_action :authenticate_user, only: [:create, :update, :destroy]  # 認証判定処理
  before_action :set_post, only: [:show]
  before_action :set_my_post, only: [:update, :destroy]

  rescue_from Exception, with: :render_status_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_status_404

  def index
    q = Post.ransack(search_params)
    posts = q.result(distinct: true).pager(page: params[:page], per: PER_PAGE)
    pager_info = pager_info(q)

    respond_to do |f|
      f.json { render json: {posts: posts, pager_info: pager_info }}
    end
  end

  def show
    render json: @post
  end

  def create
    params['post']['image'] = nil if params['post']['image'].blank?
    post = current_user.posts.build(post_params)

    if post.valid?
      # 一覧画面と詳細画面表示用の画像パスをセット
      post["index_img_path"], post["show_img_path"] = set_img_path(post)
    end

    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    # 更新後に画像パスをセットするためトランザクションで管理
    @post.transaction do
      @post.update!(post_params)
      index_img_path, show_img_path = set_img_path(@post)
      @post.update!(index_img_path: index_img_path, show_img_path: show_img_path)
    end
      head :no_content
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    if @post.destroy
      head :no_content
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def set_my_post
      @post = current_user.posts.find(params[:id])
    end

    def search_params
      params.require(:q).permit(:title_cont, :date_gteq, :date_lteq, :user_id_eq, :sorts)
    end

    def post_params
      params.require(:post).permit(:title, :date, :size, :weight, :number, :comment, :index_img_path, :show_img_path, :image)
    end

    def pager_info(q)
      pager_info = {}

      # 取得件数
      pager_info[:total_count] = q.result(distinct: true).count
      # 現在ページの開始位置
      pager_info[:st_count] = (params[:page].to_i - 1) * PER_PAGE + 1
      # 取得件数が０件の場合
      pager_info[:st_count] -= 1 if pager_info[:total_count] == 0
      # 現在ページまでで納まる最大件数
      now_max = params[:page].to_i * PER_PAGE
      # 現在ページの終了位置
      pager_info[:end_count] = pager_info[:total_count] >= now_max ? now_max : pager_info[:total_count]
      # 最大のページ番号
      pager_info[:max_page] = pager_info[:total_count] / PER_PAGE
      pager_info[:max_page] += 1 if pager_info[:total_count] % PER_PAGE != 0 || pager_info[:total_count] == 0

      return pager_info
    end

    def set_img_path(p)
      # 一覧画面用画像パスの生成
      index_img_path = polymorphic_url(
                                p.image.variant(combine_options:{
                                                auto_orient: true,
                                                resize:"240x240^",
                                                crop:"360x240+0+0",
                                                gravity: :center
                                              }).processed)
      # 詳細画面用画像パスの生成
      show_img_path = polymorphic_url(p.image.variant(auto_orient: true).processed)

      return index_img_path, show_img_path
    end

    def render_status_404(exception)
      render json: { errors: [exception] }, status: 404
    end

    def render_status_500(exception)
      render json: { errors: [exception] }, status: 500
    end
end
