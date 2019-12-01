module API::V1
  class TasksController < ApplicationController
    before_action :authenticate!
    before_action :set_task, only: %w[update destroy show]

    def index
      # TODO: check params!
      tasks = current_user.tasks.page(params[:page] || 1).per_page(params[:per_page] || 20).order(params[:order])
      render json: tasks.map(&:to_jbuilder)
    end

    def create
      task = current_user.tasks.new(task_params)
      if task.save
        render json: task.to_jbuilder, status: :created
      else
        render json: task.errors, status: :unprocessable_entity
      end
    end

    def update
      if @task.update(task_params)
        render json: @task.to_jbuilder
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    def mark_as_done
      if @task.done!
        render json: @task.to_jbuilder
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @task.destroy!
      head :no_content
    end

    private

    def set_task
      @task = current_user.tasks.find_by_token(params[:id])
    end

    def task_params
      # TODO: return error code
      params.fetch(:task, {}).permit(:title, :description, :image, :due_date)
    end
  end
end
