
class SlackVerification
  # courtesy of jmanian on github
  # https://github.com/slack-ruby/slack-ruby-client/issues/238#issuecomment-442981145
  def self.invalid_signature!
    signing_secret = ENV['slack_secret_signature']
    version_number = 'v0' # always v0 for now
    timestamp = request.headers['X-Slack-Request-Timestamp']
    raw_body = request.body.read # raw body JSON string

    if Time.at(timestamp.to_i) < 5.minutes.ago
      # could be a replay attack
      render json: {}, status: :bad_request
      return true
    end

    sig_basestring = [version_number, timestamp, raw_body].join(':')
    digest = OpenSSL::Digest::SHA256.new
    hex_hash = OpenSSL::HMAC.hexdigest(digest, signing_secret, sig_basestring)
    computed_signature = [version_number, hex_hash].join('=')
    slack_signature = request.headers['X-Slack-Signature']

    if computed_signature != slack_signature
      render json: {}, status: :unauthorized
      return true
    end
    return false
  end

end