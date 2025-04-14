class TaskAttachmentsController < ApplicationController
  before_action :authorize_current_user

    def destroy
      task = Task.find(params[:task_id])
      attachment = task.attachments.find(params[:id])
  
      attachment.purge
    end

    private

    def authorize_current_user
      authorize current_user
    end

  end