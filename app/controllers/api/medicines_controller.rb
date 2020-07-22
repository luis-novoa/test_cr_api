class API::MedicinesController < API::APIController
  before_action -> { find_object(Medicine, params[:id], 'medicine') }, only: [:update, :show, :destroy]

  def create
    @medicine = Medicine.new(medicine_params)
    if @medicine.save
      render json: @medicine, status: :created
    else
      render json: @medicine.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @object_found, status: :ok
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
    if @object_found.update(medicine_params)
      render json: @object_found, status: :ok
    else
      render json: @object_found.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @object_found.delete
    render json: "#{@object_found.name} was deleted!", status: :ok
  end

  private
  
  def medicine_params
    params.require(:medicine).permit(:name, :value, :quantity, :stock)
  end
end