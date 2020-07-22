class API::MedicinesController < API::APIController
  def create
    @medicine = Medicine.new(medicine_params)
    if @medicine.save
      render json: @medicine, status: :created
    else
      render json: @medicine.errors, status: :unprocessable_entity
    end
  end

  def index
    @medicines = Medicine.all
    if @medicines.empty?
      render json: 'No medicines registered yet!', status: :ok
    else
      render json: @medicines, status: :ok
    end
  end

  def destroy
    @medicine = Medicine.find(params[:id])
    @medicine.delete
    render json: "#{@medicine.name} was deleted!", status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: "This medicine doesn't exist.", status: :not_found
  end

  private
  
  def medicine_params
    params.require(:medicine).permit(:name, :value, :quantity, :stock)
  end
end