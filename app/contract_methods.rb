#contract specific methods

def reset_state

  element = Element.new(:string, "Hello world !")
  p "Create Element"
  p element.hex_string
  p "End Create Element"
  # ds = dynamic_string("Hello world !")
  # db = dynamic_bytes("0123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210007")
  # p "Dynamic Bytes:"
  # p db
  # p db.length
  # db1 = dynamic_bytes("007")
  # p "Dynamic Bytes:"
  # p db1
  # p db1.length
  # p "Entering two's compliment portion:...."
  # p "Zero"
  #   zero = int(0)
  #   p zero
  #   p zero.length
  # p "-13"
  #   minus_thirteen = int(-13)
  #   p minus_thirteen
  #   p minus_thirteen.length
  # p "1"
  #   one = int(1)
  #   p one
  #   p one.length
  # p "-1"
  #   minus_one = int(-1)
  #   p minus_one
  #   p minus_one.length
  # p "End two's compliment"
  #
  # p "Start bool"
  # bool = bool(true)
  # p bool
  # p bool.length
  #
  # bool = bool(false)
  # p bool
  # p bool.length
  # p "End bool"
  #
  #
  #
  # array = non_fixed_size_array(bool, ds, db, minus_thirteen)
  # p "Array:......"
  # p array
  # p array.length
  # p "End Array"
  # tuple = static_tuple(one, bool(false), bool(true), minus_thirteen)
  # p "tuple:  "
  # p tuple
  # p tuple.length
  # p "End tuple"
  #

  method = 'resetState'
  method_signature = 'resetState()'
  function_selector(method_signature) do |response|
    NSLog(response.to_s)
    @function_selector = response[0..9]
    from = "0x7f8f132cd2a73097182408592699477e0462d54b"  # from buyer address
    to = "0xf20bb3f05bda77f5c4c4fd5d23ccf9c1c93d6a1e"  #contract address
    # 1 ether = 10 ^ 18 wei
    gas = "0x" + 100000.to_s(16)  #getting the hex string value of the gas
    gasPrice = "0x" + 1000000000000.to_s(16)  #getting the hex string value of the gas price
    value = "0x" + 0.to_s(16) #getting the hex string of the value of ether in wei
    encoded_abi = @function_selector #the encoded abi for the particular contract method in question
    #nonce = <optional>
    eth_sendTransaction(from, to, gas, gasPrice, value, encoded_abi) do |response2|
      #if response2 is valie
        current_state()
      #end
    end
  end
end




def current_state
  method = 'currentState'
  method_signature = "currentState()"  # we'll add in hex for argument functionality later for a method that requires arguments
  #function_selector(method_signature)


  function_selector(method_signature) do |response|
    NSLog(response.to_s)
    @function_selector = response[0..9]
    @current_state_result.stringValue = @function_selector
    encoded_abi = @function_selector  ## note:  a different contract method will require encoded data that might include input types in the method signature and also the actual input data.  These should be the 'response' to the callback here--which will use @function_selector and combine it with the other inputs (input types and values)
    eth_call(encoded_abi) do |response2|
      string = response2[2..-1].to_i(16)
      if string == 0
        NSLog(response2)
        @current_state_result.stringValue = "Awaiting Payment"
      elsif string == 1
        NSLog(response2)
        @current_state_result.stringValue = "Awaiting Delivery"
      elsif string == 2
        NSLog(response2)
        @current_state_result.stringValue = "Complete"
      elsif string == 3
        NSLog(response2)
        @current_state_result.stringValue = "Refunded"
      else
        NSLog(response2)
        @current_state_result.stringValue = "Current State Undetermined"
      end
    end
  end

end


#function confirmPayment
def confirm_payment
  method = "confirmPayment"
  method_signature = "confirmPayment()"

  function_selector(method_signature) do |response|
    NSLog(response.to_s)
    @function_selector = response[0..9]
    from = "0x7f8f132cd2a73097182408592699477e0462d54b"  # from buyer address
    to = "0xf20bb3f05bda77f5c4c4fd5d23ccf9c1c93d6a1e"  #contract address
    # 1 ether = 10 ^ 18 wei
    gas = "0x" + 100000.to_s(16)  #getting the hex string value of the gas
    gasPrice = "0x" + 1000000000000.to_s(16)  #getting the hex string value of the gas price
    value = "0x" + 2441406250.to_s(16) #getting the hex string of the value of ether in wei
    encoded_abi = @function_selector #the encoded abi for the particular contract method in question
    #nonce = <optional>
    eth_sendTransaction(from, to, gas, gasPrice, value, encoded_abi) do |response2|
      current_state()
    end
  end

end

def confirm_delivery
  method = "confirmDelivery"
  method_signature = method + "()"

  function_selector(method_signature) do |response|
    NSLog(response.to_s)
    @function_selector = response[0..9]
    #from = "0x7f8f132cd2a73097182408592699477e0462d54b"  # from buyer address
    from = "0xfc69e7fc3c55f9146b3d32b11bb5ba6aec27c359"  # from arbiter address
    to = "0xf20bb3f05bda77f5c4c4fd5d23ccf9c1c93d6a1e"  #contract address
    # 1 ether = 10 ^ 18 wei
    gas = "0x" + 100000.to_s(16)  #getting the hex string value of the gas
    gasPrice = "0x" + 1000000000000.to_s(16)  #getting the hex string value of the gas price
    value = nil #setting the vaule to null for a non payable contract method.
    encoded_abi = @function_selector #the encoded abi for the particular contract method in question
    #nonce = <optional>
    eth_sendTransaction(from, to, gas, gasPrice, value, encoded_abi) do |response2|
      current_state()
    end
  end

end


def refund_buyer
  method = "refundBuyer"
  method_signature = method + "()"

  function_selector(method_signature) do |response|
    NSLog(response.to_s)
    @function_selector = response[0..9]
    #from = "0x7f8f132cd2a73097182408592699477e0462d54b"  # from buyer address
    from = "0xfc69e7fc3c55f9146b3d32b11bb5ba6aec27c359"  # from arbiter address
    to = "0xf20bb3f05bda77f5c4c4fd5d23ccf9c1c93d6a1e"  #contract address
    # 1 ether = 10 ^ 18 wei
    gas = "0x" + 100000.to_s(16)  #getting the hex string value of the gas
    gasPrice = "0x" + 1000000000000.to_s(16)  #getting the hex string value of the gas price
    value = nil #setting the vaule to null for a non payable contract method.
    encoded_abi = @function_selector #the encoded abi for the particular contract method in question
    #nonce = <optional>
    eth_sendTransaction(from, to, gas, gasPrice, value, encoded_abi) do |response2|
      current_state()
    end
  end

end
