class ProjectsController < ApplicationController
  before_filter :authorize

  def index
    set_session
    if @user.role_id == 3
      @projects = @user.project
    else
      @projects = Project.all
    end
  end

  def new
    set_session
    @project = Project.new
  end

  def show
    set_session
    if @user.role_id == 3
      @projects = @user.project
      if @projects.where(id: params[:id]).present?
        @project = @projects.find(params[:id])
      else
        redirect_to projects_path
      end
    else
      @project = Project.find(params[:id])
    end
  end

  def create
    set_session
    unless @user.role_id == 3
      @project = Project.new(set_project) 
      if @project.save 
        flash[:notice] = "The project has been made."
        redirect_to makers_path(@project.id)
      else
        render action: 'new'
      end
    end
  end

  def makers
    set_session
    unless @user.role_id == 3
      @project = Project.find(params[:id])
      @doers = []
      @project.users.each{|user| @doers << user.id}
    else
      redirect_to 'users#index'
    end
  end

  def add_makers
    @project = Project.find(params[:project_id])
    set_session
    unless @user.role_id == 3
      ProjectMaker.where(project_id: @project.id).delete_all
      params[:makers][:user_ids].each do |user_id|
        @project.project_makers.create(user_id: user_id)
      end
      redirect_to project_path(params[:project_id])
    end
  end

  def edit
    set_session
    @project = Project.find(params[:id])
  end

  def update
    set_session
    unless @user.role_id == 3
      @project = Project.find(params[:id])
      if @project.update(set_project) 
        flash[:notice] = "The project has been edited."
        redirect_to project_path(@project.id)
      else
        render action: 'new'
      end
    end
  end
  
  def destroy
    set_session
    @project = Project.find(params[:id])
    unless @user.role_id == 3
      @project.tasks.each{ |task| task.working_tasks.destroy_all }
      @project.tasks.destroy_all
      @project.project_makers.destroy_all
      @project.destroy
      redirect_to projects_path
    else
      flash[:notice] = "You can't delete this"
      redirect_to project_path(@project.id)
    end
  end

private

  def set_session
    @user = current_user
  end

  def set_project
    params.require(:project).permit(:name, :description, :deadline, :user_id)
  end

end