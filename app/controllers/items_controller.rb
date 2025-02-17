class ItemsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_item, only: [:destroy]

    def index
      @items = Item.all
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

    private

    def set_item
      @item = current_user.items.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :danshari_at)
    end
  end