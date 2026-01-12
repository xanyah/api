# frozen_string_literal: true

module V2
  class OrdersController < ResourcesController
    %i[order deliver withdraw cancel].each do |action|
      define_method(action) do
        authorize @record, :update?

        if @record.send(:"#{action}!")
          render json: @record
        else
          render json: @record.errors, status: :unprocessable_content
        end
      end
    end
  end
end
