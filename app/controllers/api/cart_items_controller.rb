class API::CartItemsController < API::APIController
  before_action -> { find_object(Medicine, cart_item_params[:medicine_id], 'medicine') }, only: :create
  before_action :decrease_medicine_stock, only: :create
  before_action -> { find_object(Cart, cart_item_params[:cart_id], 'cart') }, only: :create
  before_action -> { find_object(CartItem, params[:id], 'cart item') }, only: :destroy

  def create
    @cart_item = CartItem.new(cart_item_params)
    if @cart_item.save
      render json: "#{@medicine.name} added to cart #{@cart_item.cart_id}.", status: :created
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    increase_medicine_stock(@object_found.medicine, @object_found.quantity)
    cart_id = @object_found.id
    @object_found.delete
    render json: "#{@object_found.medicine.name} removed from cart #{cart_id}.", status: :ok
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:cart_id, :medicine_id, :quantity)
  end

  def decrease_medicine_stock
    @medicine = @object_found
    new_stock = @medicine.stock - cart_item_params[:quantity].to_i
    if new_stock >= 0
      @medicine.update(stock: new_stock)
    else
      render json: "Not enough #{@medicine.name} in stock!", status: :unprocessable_entity
    end
  end

  def increase_medicine_stock(medicine, quantity)
    new_stock = medicine.stock + quantity
    medicine.update(stock: new_stock)
  end
end