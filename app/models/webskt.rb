class Webskt < ActiveRecord::Base

  ##################################################
  #1、ruby中的HMAC加密签名
  #key = 'key'
  #data = 'The quick brown fox jumps over the lazy dog'
  #digest1 = OpenSSL::Digest.new('sha1')
  #digest2 = OpenSSL::Digest.new('md5')
  #hmac = OpenSSL::HMAC.digest(digest2, key, data)
  ##################################################

  # open_ticker = '{"event":"addChannel","channel":"btc_cny_ticker"}'
  # close_ticker = '{"event":"removeChannel","channel":"btc_cny_ticker"}'
  #{Digest::MD5.hexdigest(Setting.zgb.access_key)}
  act_info = {accesskey: Setting.zgb.access_key, channel: 'getaccountinfo', event: 'addChannel'}

  def self.hmac_md5_sign_event_channel(data_hash)
    rs = data_hash.clone
    key = Digest::SHA1.hexdigest(Setting.zgb.secret_key)
    # digest_md5 = OpenSSL::Digest.new('md5')
    digest_md5 = OpenSSL::Digest::MD5.new
    sign = OpenSSL::HMAC.hexdigest(digest_md5, key, data_hash.to_json)
    rs[:sign]=sign
    return rs.to_json
  end

  def self.test_wsk(event_channel=nil)
    
    return if event_channel.blank?
    
    EM.run {
      $ws = Faye::WebSocket::Client.new(Setting.zgb.wsurl)

      $ws.on :open do |event|
        p [:open]
        $ws.send(event_channel)
        # $ws.send('Hello, world!')
        # $ws.send('{"event":"addChannel","channel":"btc_cny_ticker"}')
      end

      $ws.on :message do |event|
        # djs = JSON.parse(event.data)
        # p djs["ticker"]["last"].to_f
        # if djs["ticker"]["last"].to_f > 10000
        #   p "MMMMMMMMMMMMMMMMMMMMMMMMM"
        #   # $ws.send('{"event":"removeChannel","channel":"btc_cny_ticker"}')
        # end
        p "EEEEEEEEEEEEEEEEEe"
        p [:message, event.data]
        $ws.close
      end

      $ws.on :close do |event|
        p [:close, event.code, event.reason]
        $ws = nil
      end
    }
  end
end
