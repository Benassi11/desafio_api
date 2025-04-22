class TasksController < ApplicationController
before_action :authenticate_user!, except: [ :index, :show ]
before_action :set_task, only: %i[ show update destroy ]
before_action :authorize_current_user, only: %i[ update destroy ]

  # GET /tasks
  def index
    @tasks = Task.all

    @tasks = @tasks.where(status: params[:status]) if params[:status].present?
    @tasks = @tasks.where(user_id: params[:user_id]) if params[:user_id].present?

    render json: @tasks
  end

  # GET /tasks/1
  def show
    render json: @task
  end

  # POST /tasks
  def create
    task = Task.new(task_params)

    if task.save
      render json: task, status: :created, location: task
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy!
  end

  private
    def authorize_current_user
      authorize @task
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :status, :estimated_time, :user_id,  attachments: [])
    end
end
