class API::CustomersController < API::APIController
  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      render json: @customer, status: :created
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def index
    @customers = Customer.all
    if @customers.empty?
      render json: 'No customers registered yet!', status: :ok
    else
      render json: @customers, status: :ok
    end
  end

  private
  
  def customer_params
    params.require(:customer).permit(:name)
  end
end