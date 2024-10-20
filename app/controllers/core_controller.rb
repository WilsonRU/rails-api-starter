class CoreController < ApplicationController
  before_action :authenticated, except: [:signin, :signup, :forgotPassword]

  def signin
    params.require([:username, :password])
        
    @user = User.find_by(username: params[:username])
    if @user&.authenticate(params[:password])
        @token = Token.encode(user_id: @user.id)

        render json: {
            token: @token,
            user: UserSerializer.new(@user)
        }, status: :ok
    else
        render json: {
            error: 'Email ou senha invalido.'
        }, status: :unauthorized
    end
  end

  def signup
    params.required([:username, :password, :name])

    @user = User.new(user_params)
    if @user.save 
        #ConfirmationMailer.create(@user).deliver_now

        render json: {
            message: "Usuario Cadastrado com sucesso."
        }, status: :created
    else
        render json: {
            error: @user.errors.full_messages
        }, status: :conflict
    end
  end

  def forgotPassword
    params.require(:email)

    @user = User.find_by(username: params[:email])
    if @user
        @user.password = random_password

        if @user.save
            #ConfirmationMailer.forgot(@user, newPassword).deliver_now

            render json: {
                message: 'Senha temporariria enviada para o email.'
            }, status: :ok
        else
            render json: {
                error: @user.errors.full_messages
            }, status: :conflict
        end
    else
        render json: {
            message: 'Usuário não encontrado.'
        }, status: :conflict
    end
  end

  private
    def user_params
        params.permit(:username, :password, :name)
    end
    
    def random_password
        caracteres = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
        return (0...6).map { caracteres[rand(caracteres.length)] }.join
    end
end
