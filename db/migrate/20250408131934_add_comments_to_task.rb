class AddCommentsToTask < ActiveRecord::Migration[7.2]
  def change
    add_reference :tasks, :comment, null: true, foreign_key: true
  end
end
