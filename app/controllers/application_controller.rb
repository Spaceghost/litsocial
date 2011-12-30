class ApplicationController < ActionController::Base
  include Controllers::RedirectProtection
  include Controllers::OverrideDevise
  include Controllers::SaveRecord
  include Controllers::Paged
  protect_from_forgery
  helper_method :return_path, :here
  
  def current_user_if_admin
    current_user.try(:admin?) ? current_user : nil
  end
  
  def show403(message="This page is currently unavailable.")
    render :template => 'errors/403', :layout => nil, :status => 403, :locals => {:message => message}
  end
end
