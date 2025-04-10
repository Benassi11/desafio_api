class RemoveCommentIdFromTasks < ActiveRecord::Migration[7.2]
  def change
    remove_column :tasks, :comment_id, :integer
  end
end
