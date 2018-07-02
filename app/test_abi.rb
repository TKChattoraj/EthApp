class ContractInterface
  attr_accessor :address, :user, :password

  def initialize

    @address = "http://127.0.0.1:8545"
  end


  def web3_sha3(&callback)
    params = ["0x68656c6c6f20776f726c64"]
    data = {"jsonrpc" => "2.0", "method" => "web3_sha3", "params" => params, "id" => ":64"}
    options = { payload: data, format: :json}
    BubbleWrap::HTTP.post(@address, options) do |response|
      if response.ok?
        response_body = BubbleWrap::JSON.parse(response.body.to_str)
      elsif response.status_code.to_s =~ /40\d/
        alert = NSAlert.alloc.init
        alert.setMessageText "Login Failed"
        alert.addButtonWithTitle "OK"
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
