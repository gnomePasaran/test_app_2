class Api::V1::PostsController < ApplicationController
  before_action :doorkeeper_authorize!

  before_action :set_post, only: :like

  respond_to :json

  def index
    @post = Post.all
    render json: @post
  end

  def create
    post = Post.new(post_params.merge(user: current_resource_owner))
    if post.save
      respond_with :api, :v1, :posts, status: :created
    else
      respond_with :api, :v1, :posts, status: :unprocessable_entity
    end
  end

  def like
    like = @post.likes.create(user: current_resource_owner) unless @post.user_id == current_resource_owner.id
    if like&.valid?
      respond_with :api, :v1, :posts, status: :created
    else
      respond_with :api, :v1, :posts, status: :unprocessable_entity
    end
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def post_params
    params.require(:post).permit(:text)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
