class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      redirect_to posts_path, notice: "「#{@post.item.name}」の断捨離記録を投稿しました！"
    else
      @item = if @post.item_id.present?
        Item.find_by(id: @post.item_id)
      else
        nil
      end
      render 'posts/new', status: :unprocessable_entity

    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: "断捨離記録を更新しました！"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "断捨離記録を削除しました"
  end


  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
    @my_posts = false
  end

  def my_posts
    @posts = Post.where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(10)
    @my_posts = true
    render :index
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_correct_user
    unless @post.user_id == current_user.id
      redirect_to posts_path, alert: "他のユーザーの投稿は編集・削除できません"
    end
  end

  def post_params
    params.require(:post).permit(:title, :user_name, :image, :amount, :comment, :item_id)
  end
end