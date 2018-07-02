
#params is the rpc array (of objects) in the rpc data hash

# data is the 'data' hash of the json rpc consisting of "jsonrpc", "method", "params" and "id" keys.
# "method" is the key in the data hash calling the json rpc method
# "params" is the params array (of ojbects) needed for the json rpc method called

def eth_accounts
  params = []
  data = {"jsonrpc" => "2.0", "method" => "eth_accounts", "params" => params, "id" => ":1"}
  @http_client.post(data) do |response|
    NSLog(response.to_s)
    @accounts_result.stringValue = response
  end
end

#returns the Keccak-256 Hash (not the standardized SHA3-256) given a hex string of data
def web3_sha3(hex_string)
  # hello world
  #params = ["0x68656c6c6f20776f726c64"]
  # bar(bytes3[2])
  #params = ["0x626172286279746573335b325d29"]
  params = [hex_string]
  data = {"jsonrpc" => "2.0", "method" => "web3_sha3", "params" => params, "id" => ":64"}
  #note:  web3_sha3 is really only responsible for providing the keccak hash and so the callback sent to the @http_client should be a callback input to the web3_sha3 itself.
  @http_client.post(data) do |response|
    NSLog(response.to_s)
    @function_selector = response[0..9]
    @main_button_result.stringValue = @function_selector
    encoded_data = @function_selector # we'll add in encoidng for contract method later
    eth_call(encoded_data)
  end

end


def eth_call(encoded_data)
#   <build the abi encoded data>
#
  params = [{
#    "from" => "0xd0985573eb82faf69b2d4ef36d1e03fec5c43ae7",
    "to" => "0x52f35097D9B8E6324eb8720789AC66f8B3d24855", # contract address
#    "gas" => "0x76c0", # 30400
#    "gasPrice" => "0x9184e72a000", #  10000000000000
#    "value" => "0x9184e72a", # 2441406250
    "data" => encoded_data
#   "nonce":  # nonce is optional
  },
  "latest"]
   data = {"jsonrpc" => "2.0", "method" => "eth_call", "params" => params, "id" => ":1"}
   @http_client.post(data) do |response|
     NSLog("made it to the http_client posting eth_call")
     NSLog(response.to_s)
   end

end
