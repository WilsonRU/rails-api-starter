class ApplicationController < ActionController::API
  before_action :authenticated

    include Token

    private
      def authenticated
          header = request.headers['Authorization']
          header = header.split(' ').last if header
          begin
            @decoded = Token.decode(header)
            @current_user = User.find(@decoded[:user_id])
          rescue ActiveRecord::RecordNotFound => e
              render json: {
                  error: e.message
              }, status: :unauthorized
          rescue JWT::DecodeError => e
              render json: {
                  error: e.message
              }, status: :unauthorized
          end
      end

      def currentUser
          @user = User.find(@decoded[:user_id])
      end
end
