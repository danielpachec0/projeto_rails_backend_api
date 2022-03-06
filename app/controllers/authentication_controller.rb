class AuthenticationController < ApplicationController
    class AuthenticationError < StandardError; end
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from AuthenticationError, with: :handle_unauthenticated


    def create
        params.require(:email)
        
        raise AuthenticationError unless user.authenticate(params.require(:password))
        token = AuthenticationTokenService.call(user.id)
        render json: { token: token }, status: :created
    end

    private
    def user
        @user ||= User.find_by(email: params.require(:email))
    end


    def parameter_missing(e)
        render json: { error: e.message }, status: :unprocessable_entity
    end

    def handle_unauthenticated(e)
        head :unauthorized
    end
end