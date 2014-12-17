class SessionsController < ApplicationController
  
  def new
    if current_user
      redirect_to users_path
    end
  end

  def create
    if user = User.find_by(email: params[:email])
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        tracker = user.trackers.last
        if tracker.present?
          session[:time_id] = tracker.id if tracker.date == Date.today.to_s
        end
        redirect_to root_url
      else
        flash[:notice] =  "Invalid password"
        redirect_to log_in_path
      end
    else
      flash[:notice] =  "Invalid email"
      redirect_to log_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    session[:time_id] = nil
    redirect_to root_url
  end

end
