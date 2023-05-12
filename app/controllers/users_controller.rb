class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy verify_otp resent_otp ]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    @user.password = "password"
    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  def sign_up
    @user = User.new(user_params_signup)
    @user.role = select_signup_role
    if @user.save
      if SendOtpService.new(@user).send_otp
        render json: { user: @user }, status: :created
      else
        render json: { errors: "Otp send failed" },
               status: :unprocessable_entity
      end
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def verify_otp
    if @user.otp === params[:otp] && Time.now < @user.otp_expires_in
      if @user.update(is_verified: true)
        render json: { verified: true }, status: :ok
      else
        render json: { errors: "Unable to verify otp" },
               status: :unprocessable_entity
      end
    else
      render json: { errors: "Otp not matching or otp expired" },
             status: :unprocessable_entity
    end
  end

  def resent_otp
    if SendOtpService.new(@user).send_otp
      render json: { user: @user }, status: :ok
    else
      render json: { errors: "Otp send failed" },
             status: :unprocessable_entity
    end
  end

  private

  def select_signup_role
    Role.find_by(name: "customer")
  end

  def set_user
    if params[:user_id].present?
      @user = User.find(params[:user_id])
    else
      @user = User.find(params[:id])
    end
  end

  def user_params
    params.permit(
      :user_name, :email, :role_id
    )
  end

  def user_params_signup
    params.permit(
      :name, :user_name, :email, :password, :password_confirmation
    )
  end
end
