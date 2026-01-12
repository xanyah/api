# frozen_string_literal: true

module V2
  class ResourcesController < BaseController
    after_action :verify_authorized, except: :index
    after_action :verify_policy_scoped, only: :index
    before_action :set_record, except: %i[index create]

    def index
      @q = policy_scope(model_class).includes(included_relationships).ransack(params[:q])
      @pagy, @records = pagy(@q.result(distinct: true))

      response.headers.merge!(@pagy.headers_hash)

      render json: @records
    end

    def show
      authorize @record

      render json: @record
    end

    def create
      @record = model_class.new(permitted_attributes(model_class)) if @record.nil?
      authorize @record

      if @record.save
        render json: @record, status: :created
      else
        render json: @record.errors, status: :unprocessable_content
      end
    end

    def update
      authorize @record

      if @record.update(permitted_attributes(@record))
        render json: @record
      else
        render json: @record.errors, status: :unprocessable_content
      end
    end

    def destroy
      authorize @record

      @record.destroy

      head :no_content
    end

    private

    def model_class
      controller_name.classify.constantize
    end

    def set_record
      @record = model_class.find(params[:id])
    end

    def included_relationships
      []
    end
  end
end
