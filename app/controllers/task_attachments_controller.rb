class TaskAttachmentsController < ApplicationController
  before_action :authorize_current_user
  before_action :authenticate_user!

    def destroy_attachment
      task = Task.find(params[:task_id])
      attachment = task.attachments.find(params[:id])

      attachment.purge
    end

    private

    def authorize_current_user
      task = Task.find(params[:task_id])
      authorize task     
    end
end
