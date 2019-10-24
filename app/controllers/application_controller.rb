# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ApiTokenAuthorizable

  before_action :set_resource, only: [:show, :destroy, :update]

  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    collection = resource_class.where(query_params)
                              .page(page_params[:page])
                              .per(page_params[:page_size])

    instance_variable_set(pluralized_resource, collection)
    render_collection
  end

  def show
    render json: get_resource
  end

  def create
    set_resource(resource_class.new(resource_params))

    if get_resource.save
      render json: get_resource, status: :created
    else
      render json: get_resource.errors, status: :unprocessable_entity
    end
  end

  def update
    if get_resource.update(resource_params)
      render json: get_resource
    else
      render json: get_resource.errors, status: :unprocessable_entity
    end
  end

  def destroy
    get_resource.destroy
    head :no_content
  end

  private

  def not_found
    render json: {
      message: "Could not find #{resource_name.classify} with ID #{params[:id]}"
    },
    status: :not_found
  end

  def resource_params
    @resource_params ||= self.send("#{resource_name}_params")
  end

  def set_resource(resource = nil)
    resource ||= resource_class.find(params[:id])
    instance_variable_set("@#{resource_name}", resource)
  end

  def get_resource
    instance_variable_get("@#{resource_name}")
  end

  def resource_name
    @resource_name ||= self.controller_name.singularize
  end

  def resource_class
    @resource_class ||= resource_name.classify.constantize
  end

  def render_collection
    collection = instance_variable_get(pluralized_resource)

    render json: {
      page: collection.current_page,
      total_pages: collection.total_pages,
      page_size: collection.size,
      "#{resource_name.pluralize}": collection.as_json
    }
  end

  def query_params
    {}
  end

  def page_params
    params.permit(:page, :page_size)
  end

  def pluralized_resource
    "@#{resource_name.pluralize}"
  end
end
