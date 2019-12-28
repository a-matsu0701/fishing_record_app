class Api::PostsController < ApplicationController
  before_action :set_post, only: [:show]

  rescue_from Exception, with: :render_status_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_status_404

  def index
    posts = Post.all
    render json: posts
  end

  def show
    render json: @post
  end

  def create
    params['post']['image'] = nil if params['post']['image'].blank?
    post = Post.new(post_params)

    if post.valid?
      post["index_img_path"] = polymorphic_url(
                                post.image.variant(combine_options:{
                                                    auto_orient: true,
                                                    resize:"240x240^",
                                                    crop:"360x240+0+0",
                                                    gravity: :center
                                                  }).processed)

      post["show_img_path"] = polymorphic_url(post.image.variant(auto_orient: true).processed)
    end

    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :date, :size, :weight, :number, :comment, :index_img_path, :show_img_path, :image)
    end

    def render_status_404(exception)
      render json: { errors: [exception] }, status: 404
    end

    def render_status_500(exception)
      render json: { errors: [exception] }, status: 500
    end
end
