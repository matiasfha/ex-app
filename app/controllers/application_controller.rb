class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_must_revalidate

  def set_must_revalidate
    response.headers["Cache-Control"] = "must-revalidate"
  end
end
