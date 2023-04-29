class UsersController < ApplicationController
  before_action :find_user, only: [:verify_otp, :resent_otp]

  def create
    @user = User.new(user_params)
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

  def user_params
    params.permit(
      :name, :user_name, :email, :password, :password_confirmation
    )
  end

  def find_user
    @user = User.find(params[:user_id])
  end
end
