class AddOtpExpiresInToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :otp_expires_in, :datetime
  end
end
