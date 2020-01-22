class ApplicationController < ActionController::Base
  include Firebase::Auth::Authenticable
end
