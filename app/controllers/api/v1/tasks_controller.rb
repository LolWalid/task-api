module API::V1
  class TasksController < ApplicationController
    before_action :authenticate!
    before_action :set_task, only: %w[update destroy show mark_as_done]

    def index
      # TODO: check params!
      tasks = current_user.tasks.in_progress.page(params[:page] || 1).per_page(per_page).order(params[:order] || :created_at)
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

    def per_page
      params_per_page = params[:per_page].presence || 20
      [params_per_page.to_i, 100].min
    end

    def set_task
      @task = current_user.tasks.find_by_token(params[:id])
    end

    def task_params
      # TODO: return error code
      params.fetch(:task, {}).permit(:title, :description, :image, :due_date)
    end
  end
end
