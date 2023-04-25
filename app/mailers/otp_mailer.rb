class OtpMailer < ApplicationMailer
  def send_otp_email(user, otp)
    url = URI("https://sandbox.api.mailtrap.io/api/send/#{ENV["MAILTRAP_INBOX_ID"]}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Accept"] = "application/json"
    request["Api-Token"] = ENV["MAILTRAP_API_TOKEN"]
    request.body = "{\n  \"to\": [\n    {\n      \"email\": \"#{user.email}\",\n      \"name\": \"#{user.user_name}\"\n    }\n  ],\n  \"from\": {\n    \"email\": \"sales@example.com\",\n    \"name\": \"Example Sales Team\"\n  },\n  \"subject\": \"Your Otp\",\n  \"text\": \"Verification Otp: #{otp}\"\n}"
    response = http.request(request)
    if response.read_body["success"]
      return true
    end
  end
end
