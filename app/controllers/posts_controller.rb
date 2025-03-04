class PostsController < ApplicationController
    before_action :authenticate_user!
    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params)

      if @post.save
        redirect_to posts_path, notice: "「#{@post.item.name}」の断捨離記録を投稿しました！"
      else
        @item = @post.item
        render 'posts/new'
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