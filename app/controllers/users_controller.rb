class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    render nothing: true
  end
end
