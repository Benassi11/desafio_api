class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_comment, only: %i[ show update destroy ]
  before_action :authorize_current_user, only: %i[ update destroy ]  

  def index
    @comments = Comment.all

    render json: @comments
  end

  def show
    render json: @comment
  end

  def create
    comment = Comment.new(comment_params)

    if comment.save
      render json: comment, status: :created, location: comment
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy!
  end

  private

  def authorize_current_user
    authorize @comment
  end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:description, :user_id, :task_id, :parent_id)
    end
end
