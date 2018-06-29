class HttpClient


  def initialize
    @address = "http://127.0.0.1:8545"

  end


  def post(data, &callback)

    options = {payload: data, format: :json}
    BubbleWrap::HTTP.post(@address, options) do |response|
      #NSLog(response.body.to_str)
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
      callback.call(response_body["result"])
    end

  end

end
