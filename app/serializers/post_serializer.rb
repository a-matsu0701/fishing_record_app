class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :date, :size, :weight, :number, :comment, :index_img_path, :show_img_path, :user_id, :user_name, :user_uid
  belongs_to :user

  def user_name
    object.user.name
  end

  def user_uid
    object.user.uid
  end
end
