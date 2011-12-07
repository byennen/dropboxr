class ManageController < ApplicationController
  before_filter :require_login

  def index
    @count_photos = Photo.all.length
    @count_cached_photos = Photo.cached.length
    @count_not_cached_photos = Photo.not_cached.length

    info = Resque.info

    @resque_pending = info[:pending]
    @resque_working = info[:working]

    # {:pending=>0, :processed=>904, :queues=>1, :workers=>2, :working=>0, :failed=>570, :servers=>["redis://localhost:6379/0"], :environment=>"development"}
  end

  protected

    def require_login
      authenticate_or_request_with_http_basic(Dropboxr::Application.config.auth_area_name) do |username, password|
        username == Dropboxr::Application.config.auth_username && password == Dropboxr::Application.config.auth_password
      end
    end

end
