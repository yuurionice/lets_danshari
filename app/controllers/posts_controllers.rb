class PostsController < ApplicationController
    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params)

      if @post.save
        redirect_to posts_path, notice: '断捨離の記録が投稿されました！'
      else
        render :new
      end
    end

    def show
      @post = Post.find(params[:id])
    end
    
    def index
      @posts = Post.all.order(created_at: :desc)
    end

    private

    def post_params
      params.require(:post).permit(:title, :user_name, :image, :amount, :comment, :item_id)
    end
  end