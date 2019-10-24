# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ApiTokenAuthorizable

	before_action :set_resource, except: [:index, :create]

  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    resources = base_index_query.where(query_params)
    resources = resources.order(order_args).page(page_params[:page]).per(page_params[:page_size]) if resources.size > 1

    instance_variable_set(pluralized_resource, resources)
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

  def destroy
    get_resource.destroy
    head :no_content
  end

  def update
    if get_resource.update(resource_params)
      render json: get_resource
    else
      render json: get_resource.errors, status: :unprocessable_entity
    end
  end

	private

  def not_found
    render json: {
    	message: "Could not find #{resource_name.capitalize} with ID #{params[:id]}"
    },
    status: :not_found
  end

  def model_attributes
    resource_class.attribute_names.map{ |s| s.to_sym } - [:created_at, :updated_at]
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

  def base_index_query
    resource_class
  end

  def render_collection
    resources = instance_variable_get(pluralized_resource)

    render json: {
      page: resources.respond_to?(:current_page) ? resources.current_page : 1,
      total_pages: resources.respond_to?(:total_pages) ? resources.total_pages : 1,
      page_size: resources.respond_to?(:size) ? resources.size : 1,
      "#{resource_name.pluralize}": resources.as_json
    }
  end

  def query_params
    {}
  end

  def page_params
    params.permit(:page, :page_size)
  end

  def order_args
    :created_at
  end

  def pluralized_resource
    "@#{resource_name.pluralize}"
  end
end
