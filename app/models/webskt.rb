class Webskt < ActiveRecord::Base


  # open_ticker = '{"event":"addChannel","channel":"btc_cny_ticker"}'
  # close_ticker = '{"event":"removeChannel","channel":"btc_cny_ticker"}'
  def self.test_wsk(event_channel)
    EM.run {
      $ws = Faye::WebSocket::Client.new('wss://api.chbtc.com:9999/websocket')

      $ws.on :open do |event|
        p [:open]
        $ws.send(event_channel)
        # $ws.send('Hello, world!')
        # $ws.send('{"event":"addChannel","channel":"btc_cny_ticker"}')
      end

      $ws.on :message do |event|
        p [:message, event.data]
      end

      $ws.on :close do |event|
        p [:close, event.code, event.reason]
        $ws = nil
      end
    }
  end
end
