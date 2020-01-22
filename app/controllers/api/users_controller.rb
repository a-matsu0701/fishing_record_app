class Api::UsersController < ApplicationController
  before_action :authenticate_user, only: [:destroy]  # 認証判定処理
  before_action :set_user, only: [:show, :destroy]

  def show
    render json: @user
  end

  def create
    # Firebaseの認証が通ればユーザーを新規作成
    FirebaseIdToken::Certificates.request
    raise ArgumentError, 'BadRequest Parameter' if payload.blank?
    user = User.new(signup_params.merge(uid: payload['sub']))
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      head :no_content
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
      @user = User.find_by(uid: params[:id])
  end

  def signup_params
    params.require(:user).permit(:name, :email)
  end

  def token
    request.headers['Authorization']&.split&.last
  end

  def payload
    @payload ||= FirebaseIdToken::Signature.verify token
  end
end
