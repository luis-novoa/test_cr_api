class API::CartsController < API::APIController
  before_action -> { find_object(Customer, cart_params[:customer_id], 'customer') }, only: [:create]

  def create
    @cart = @object_found.carts.build
    @cart.save
    render json: @cart, status: :created
  end

  private

  def cart_params
    params.require(:cart).permit(:customer_id)
  end
end