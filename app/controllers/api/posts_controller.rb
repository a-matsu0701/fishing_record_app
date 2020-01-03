class Api::PostsController < ApplicationController
  PER_PAGE = 9

  before_action :set_post, only: [:show, :update, :destroy]

  rescue_from Exception, with: :render_status_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_status_404

  def index
  end

  def search
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
    post = Post.new(post_params)

    if post.valid?
      post["index_img_path"], post["show_img_path"] = set_img_path(post)
    end

    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
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
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def search_params
      params.require(:q).permit(:title_cont, :date_gteq, :date_lteq, :sorts)
    end

    def post_params
      params.require(:post).permit(:title, :date, :size, :weight, :number, :comment, :index_img_path, :show_img_path, :image)
    end

    def pager_info(q)
      pager_info = {}
      pager_info[:total_count] = q.result(distinct: true).count
      pager_info[:st_count] = (params[:page].to_i - 1) * PER_PAGE + 1
      pager_info[:st_count] -= 1 if pager_info[:total_count] == 0

      now_max = params[:page].to_i * PER_PAGE
      pager_info[:end_count] = pager_info[:total_count] >= now_max ? now_max : pager_info[:total_count]

      pager_info[:max_page] = pager_info[:total_count] / PER_PAGE
      pager_info[:max_page] += 1 if pager_info[:total_count] % PER_PAGE != 0

      return pager_info
    end

    def set_img_path(p)
      index_img_path = polymorphic_url(
                                p.image.variant(combine_options:{
                                                auto_orient: true,
                                                resize:"240x240^",
                                                crop:"360x240+0+0",
                                                gravity: :center
                                              }).processed)
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
