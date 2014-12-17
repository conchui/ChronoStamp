class TasksController < ApplicationController
  before_filter :authorize 

  def index
  end

  def show
    set_session
    task = Task.find(params[:id])
    if task.assigned_people.detect{|pep| pep.id == @user.id} || @user.role_id <= 2
      @task = task
    else
      redirect_to projects_path
    end
  end

  def new
    @task = Task.new
    @taskmaker = set_session
    @project = Project.find(params[:id])
    unless @user.role_id == 3 
      @peps = @project.users
    else
      @peps = @project.users.where(role_id: 3)
    end
  end

  def create
    @task = Task.new(set_task)
    if set_doers.count >= 2
      if @task.save
        set_doers.each do |doer|
          @task.working_tasks.create(user_id: doer)
        end
        flash[:notice] = "The task has been made."
        redirect_to task_path(@task.id)
      else
        flash[:notice] = "Name can't be blank"
        redirect_to new_task_path(id: params[:task][:project_id])
      end
    else
      flash[:notice] = "Assign at least one person to the task."
      redirect_to new_task_path(id: params[:task][:project_id])
    end
  end

  def edit
    set_session
    task = Task.find(params[:id])
    if task.assigned_people.detect{|pep| pep.id == @user.id} || @user.role_id <= 2
      @task = task
    else
      redirect_to projects_path
    end
    @project = @task.project
    @taskmaker = @task.user
    @taskpeps = []
    @task.assigned_people.each{|pep| @taskpeps << pep.id}
    unless @user.role_id == 3 
      @peps = @project.users
    else
      @peps = @project.users.where(role_id: 3)
    end
  end

  def update
    set_session
    @task = Task.find(params[:id])
    unless @task.user.role_id <= 2 && @user.role_id == 3
      if set_doers.count >= 2
        if @task.update(set_task)
          WorkingTask.where(task_id: @task.id).delete_all
          set_doers.each do |doer|
            @task.working_tasks.create(user_id: doer)
          end
          flash[:notice] = "The task has been edited."
          redirect_to task_path(@task.id)
        else
          flash[:notice] = "Name can't be blank"
          redirect_to edit_task_path(@task.id)
        end
      else
        flash[:notice] = "Assign at least one person to the task."
        redirect_to edit_task_path(@task.id)
      end
    else
      flash[:notice] = "You don't have the right to edit the task."
      redirect_to edit_task_path(@task.id)
    end
  end

  def display_time
    set_session
    @task = Task.find(params[:id])    
  end

  def time
    set_session
    @task = Task.find(params[:id])
    if @task.start_time.nil? && @task.assigned_people.detect{|pep| pep.id == @user.id}
      @task.update(start_time: Time.now.strftime("%I:%M%p"))
      flash[:notice] = "The task has been started"
      redirect_to task_path
    elsif @task.end_time.nil? && @task.assigned_people.detect{|pep| pep.id == @user.id}
      @task.update(end_time: Time.now.strftime("%I:%M%p"))
      flash[:notice] = "You've ended the task"
      redirect_to task_path
    elsif @task.start_time.present? && @task.end_time.present? && @task.assigned_people.detect{|pep| pep.id == @user.id}
      flash[:notice] = "This task has been done"
      redirect_to task_path
    else
      flash[:notice] = "You can't"
      redirect_to task_path
    end 
  end

  def destroy
    set_session
    @task = Task.find(params[:id])
    unless @task.user.role.id <= 2 && @user.role_id == 3
      @task.working_tasks.destroy_all
      @task.destroy
      redirect_to projects_path
    else
      flash[:notice] = "You can't delete this"
      redirect_to task_path(@task.id)
    end
  end

private

  def set_session
    @user = current_user
  end

  def set_task
    params.require(:task).permit(:name, :user_id, :project_id)
  end

  def set_doers
    params.require(:assign).require(:user_ids)
  end

end