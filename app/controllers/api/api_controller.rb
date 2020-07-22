module API
  class APIController < ApplicationController
    def find_object(model, param, model_string)
      @object_found = model.find(param)
    rescue ActiveRecord::RecordNotFound
      render json: "This #{model_string} doesn't exist.", status: :not_found
    end
  end
end