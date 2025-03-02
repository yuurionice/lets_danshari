class ItemsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_item, only: [:edit, :update, gi:destroy]

    def index
        @items = current_user.items.all
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

    def edit
      @item = current_user.items.find(params[:id])
    end

    def destroy
      @item = current_user.items.find(params[:id])
      @item.update(completed: true)
      redirect_to new_item_post_path(@item), notice: '断捨離が完了しました。思い出の写真を投稿しましょう！'
    end

    private

    def set_item
      @item = current_user.items.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :danshari_at)
    end
  end