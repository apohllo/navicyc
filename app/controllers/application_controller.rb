# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_user, :admin?

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  before_filter :authenticate

  protected

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def admin?
    current_user && current_user.admin?
  end

  def admin_required
    if !admin?
      redirect_to :controller => "home"
    end
  end

  def authenticate
    if !current_user
      redirect_to :controller => "user_sessions", :action => "new"
    end
  end

  def cyc
    CYC
  end
end
