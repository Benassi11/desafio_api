class Comment < ApplicationRecord
    belongs_to :task, foreign_key: "task_id"
    belongs_to :user, foreign_key: "user_id"
    belongs_to :parent, class_name: "Comment", optional: true
    has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy

    validates :task, presence: true
    validates :user, presence: true
    validates :description, presence: true
end
