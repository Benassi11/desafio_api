class TaskAttachmentsController < ApplicationController
    def destroy
      task = Task.find(params[:task_id])
      attachment = task.attachments.find(params[:id])
  
      attachment.purge
    end
  end