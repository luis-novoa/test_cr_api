class API::CartItemsController < API::APIController
  before_action -> { find_object(Medicine, cart_item_params[:medicine_id], 'medicine') }, only: [:create]
  before_action -> { find_object(Cart, cart_item_params[:cart_id], 'cart') }, only: [:create]

  def create
    @cart_item = CartItem.new(cart_item_params)
    if @cart_item.save
      render json: @object_found.cart_items, status: :created
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:cart_id, :medicine_id, :quantity)
  end
end