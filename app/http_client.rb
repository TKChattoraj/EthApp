class HTTPClient

  def initialize
    @address = "http://127.0.0.1:8545"

  end

  def post(data, &callback)
    options = {payload: data, format: :json}
    BubbleWrap::HTTP.post(@address, options) do |response|
      # response hash is:
      #   {
      #     "id" =>
      #     "jsronrpc" =>
      #     "result" => [...]
      #   }
      if response.ok?
        response_body = BubbleWrap::JSON.parse(response.body.to_str)
      elsif response.status_code.to_s =~ /40\d/
        alert = NSAlert.alloc.init
        alert.setMessageText "Failed"
        alert. addButtonWithTitle "OK"
        alert.runModal
      else
        alert = NSAlert.alloc.init
        alert.setMessageText response.error_message
        alert.addButtonWithTitle "OK"
        alert.runModal
      end
      NSLog("Response_body")
      NSLog(response_body.to_s)
      callback.call(response_body["result"])
    end
  end

end
