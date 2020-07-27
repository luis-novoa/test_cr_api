class API::CartsController < API::APIController
  before_action -> { find_object(Customer, cart_params[:customer_id], 'customer') }, only: :create
  before_action -> { find_object(Cart, params[:id], 'cart') }, only: %i[show destroy]

  def create
    @cart = @object_found.carts.build
    @cart.save
    render json: @cart, status: :created
  end

  def index
    @carts = Cart.all
    if @carts.empty?
      render json: 'No carts registered yet!', status: :ok
    else
      render json: @carts, status: :ok
    end
  end

  def show
    @cart_items = @object_found.cart_items.includes(:medicine)
    if @cart_items.empty?
      render json: 'This cart is empty.', status: :ok
    else
      json_output = @object_found.to_json(include: :cart_items)
      json_output[-1] = ",\"total\":#{@object_found.total}}"
      render json: json_output, status: :ok
    end
  end

  def destroy
    @object_found.delete
    render json: "Cart #{params[:id]} was deleted!", status: :ok
  end

  private

  def cart_params
    params.require(:cart).permit(:customer_id)
  end
end
