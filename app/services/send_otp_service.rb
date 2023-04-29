
class SendOtpService
  def initialize(user)
    @user = user
  end

  def send_otp
    # generate a random OTP code
    otp = rand(1000..9999).to_s
    @user.otp = otp
    @user.otp_expires_in = Time.now + 1.minute
    if @user.save
      OtpMailer.send_otp_email(@user, otp).deliver_now
      true
    else
      false
    end
  end
end
