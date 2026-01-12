# frozen_string_literal: true

module V2
  class ShippingsController < ResourcesController
    def validate
      authorize @record

      if @record.validate!
        render json: @record
      else
        render json: @record.errors, status: :unprocessable_content
      end
    end

    def cancel
      authorize @record

      if @record.cancel!
        render json: @record
      else
        render json: @record.errors, status: :unprocessable_content
      end
    end
  end
end
