class UsersController < ApplicationController
  before_filter :authorize, except: [:new, :create]

  def index
    set_session
    @tracks = current_user.trackers
    @tasks = current_user.tasks_working
    @projects = current_user.project
    year = 2013
    @holidays = Holiday.all
  end


  def new
    @user = User.new
  end

  def create
    @user = User.new(set_signup)
    if @user.save
      flash[:notice] = "Welcome! You can now Log in"
      redirect_to log_in_path
    else
      render action: 'new'
    end
  end

  def edit
    set_session
  end

  def update
    set_session
    if @user.authenticate(params[:user][:old_password])
      if pass_reset[:password].present? && pass_reset[:password_confirmation].present?
        if pass_reset[:password].length >= 6
          if pass_reset[:password] == pass_reset[:password_confirmation]
            @user.update(pass_reset) 
            redirect_to log_out_path
          else
            flash[:notice] =  "Password didn't match to password confirmation" 
            redirect_to password_reset_path
          end
        else
          flash[:notice] =  "Password must have at least 6 characters" 
          redirect_to password_reset_path
        end
      else
        flash[:notice] =  "New password required" 
        redirect_to password_reset_path
      end
    else
      flash[:notice] =  "Invalid old password."
      redirect_to password_reset_path
    end
  end

  def manage
    if set_session
      @managers = User.where(role_id: 1) + User.where(role_id: 2)
      @users = User.where(role_id: 3)
    end
  end

  def track_user
    if set_session
      @manageduser = User.find(params[:id])
      @trackers = @manageduser.trackers
    end
  end

  def edit_users
    @role = User.find(params[:id])
  end

  def update_users
    @role = User.find(params[:id])
    unless current_user.role_id == 3 
      @role.update(set_update)
      redirect_to manage_users_path
    end
  end

  def time_tracker
    if set_session
      @trackers = @user.trackers
    end
  end

  def time_stamp
    if set_session
      timesession = session[:time_id]
      datenow = Date.today.to_s
      timenow = Time.now.strftime("%I:%M%p")
      if timesession.present?
        if Tracker.find(timesession).date == datenow
          attend = Tracker.find(timesession) 
          attend.update(time_out: timenow)
          redirect_to time_tracker_path
        else
          timesession = session[:time_id] = nil
          time_create(datenow, timenow)
        end
      else
        time_create(datenow, timenow)
      end
    end
  end

private

  def set_session
    @user = current_user
  end

  def time_create(date, time)
    tracker = @user.trackers.create(date: date, time_in: time)
    session[:time_id]  = tracker.id
    redirect_to time_tracker_path
  end

  def set_signup
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def set_update
    params.require(:user).permit(:first_name, :last_name, :email, :role_id)
  end

  def pass_reset
    params.require(:user).permit(:password, :password_confirmation)
  end

end
