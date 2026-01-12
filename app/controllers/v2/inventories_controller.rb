# frozen_string_literal: true

module V2
  class InventoriesController < ResourcesController
    def lock
      authorize @record

      if @record.lock
        render json: @record
      else
        render json: @record.errors, status: :unprocessable_content
      end
    end
  end
end
