module Api
  class BaseController < ApplicationController
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :doorkeeper_authorize!
    skip_before_action :verify_authenticity_token

    respond_to :json

    protected

    def configure_permitted_parameters
      added_attrs = [:email, :first_name, :last_name]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

    def render_forbidden
      render json: { errors: t('forbidden') }, status: 403
    end

    def render_not_found
      render json: { errors: t('not_found') }, status: 404
    end

    def current_user
      current_resource_owner
    end

    private

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  end
end
