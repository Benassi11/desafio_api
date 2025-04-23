class CommentSerializer < ActiveModel::Serializer
  attributes :id, :description, :user_id, :task_id, :parent_id

  belongs_to :task
  belongs_to :user
  belongs_to :parent, serializer: CommentSerializer
  has_many :replies, serializer: CommentSerializer
end
