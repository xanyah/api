# frozen_string_literal: true

module V2
  class StoresController < ResourcesController
    def create
      @record = model_class.new(permitted_attributes(model_class)) if @record.nil?
      authorize @record

      if @record.save
        StoreMembership.create(user: current_user, store: @record)
        render json: @record, status: :created
      else
        render json: @record.errors, status: :unprocessable_content
      end
    end
  end
end
