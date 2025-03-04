class ItemsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_item, only: [:edit, :update, :destroy, :new_post]

    def index
        @items = current_user.items.where(completed: false)
        @item = current_user.items.build  # 新規作成フォーム用
    end

    def new
      @item = current_user.items.build
    end

    def create
      @item = current_user.items.build(item_params)
      if @item.save
        redirect_to items_path, notice: '断捨離アイテムを登録しました'
      else
        render :new
      end
    end

    def update
      if @item.update(item_params)
        redirect_to items_path, notice: '断捨離アイテムを更新しました'
      else
        render :edit
      end
    end

    def destroy
        @item.destroy
        redirect_to items_path, notice: 'アイテムを削除しました'
      end

      def new_post

        if @item.nil?
          @item = current_user.items.find(params[:id])
        end

        @post = Post.new(
          item: @item,
          title: "#{@item.name}を断捨離しました",
          user_name: current_user.name  # ユーザー名を自動設定
        )

          # アイテムを「完了」状態に更新
          @item.update(completed: true)

          render 'posts/new'
          end

    private

    def set_item
      @item = current_user.items.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :danshari_at)
    end
  end