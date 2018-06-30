
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
def web3_sha3(utf8)
  # hello world
  #params = ["0x68656c6c6f20776f726c64"]
  # bar(bytes3[2])
  #params = ["0x626172286279746573335b325d29"]
  params = [utf8]
  data = {"jsonrpc" => "2.0", "method" => "web3_sha3", "params" => params, "id" => ":64"}
  @http_client.post(data) do |response|
    NSLog(response.to_s)
    method_id = response[0..9]
    @main_button_result.stringValue = method_id
  end

end

#convert string to ascii (utf-8) shown in 0x
def string_to_utf8
  # s is string form of the method signature
  s = "bar(bytes3[2])"
  # s.unpack returns the 0x representation of the string in 0th element of array
  "0x" + s.unpack('H*')[0]
end

def method_id
  web3_sha3(string_to_utf8)
end


# def eth_sendTransaction
#   params = [
#     "from": "0xfe879311e339402c085599ed96e06859aa88943e"
#     "to": "0xb7e99dfc03bc71e827ba4ddd36b02ae7819489cb" # contract address
#     "gas": "0x76c0", # 30400
#     "gasPrice": "0x9184e72a000", #  10000000000000
#     "value": "0x9184e72a", # 2441406250
#     "data": [encoded data]
#     "nonce":
#   ]
#
# end
