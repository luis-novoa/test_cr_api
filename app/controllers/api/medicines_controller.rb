class API::MedicinesController < API::APIController
  before_action :find_medicine, only: [:update, :show, :destroy]

  def create
    @medicine = Medicine.new(medicine_params)
    if @medicine.save
      render json: @medicine, status: :created
    else
      render json: @medicine.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @medicine, status: :ok
  end

  def index
    @medicines = Medicine.all
    if @medicines.empty?
      render json: 'No medicines registered yet!', status: :ok
    else
      render json: @medicines, status: :ok
    end
  end

  def update
    # @medicine = Medicine.new(medicine_params)
    if @medicine.update(medicine_params)
      render json: @medicine, status: :ok
    else
      render json: @medicine.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @medicine.delete
    render json: "#{@medicine.name} was deleted!", status: :ok
  end

  private
  
  def medicine_params
    params.require(:medicine).permit(:name, :value, :quantity, :stock)
  end

  def find_medicine
    @medicine = Medicine.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: "This medicine doesn't exist.", status: :not_found
  end
end