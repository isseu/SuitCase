class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  #Redirects to login for secure resources
  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      flash[:alert] = "No estas autorizado para ver esta pagina"
      session[:user_return_to] = nil
      redirect_to root_url

    else
      flash[:alert] = "Debes ingresar primero para ver esta pagina"
      session[:user_return_to] = request.url
      redirect_to new_user_session_path
    end
  end

  # Call an asyn rake task
  def call_rake(task, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "bundle exec rake #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log &"
  end
end
