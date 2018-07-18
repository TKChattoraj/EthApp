#contract specific methods

def reset_state
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
      if response2 == 0
        NSLog(response2)
        @current_state_result.stringValue = "Awaiting Payment"
      elsif response2 == 1
        NSLog(response2)
        @current_state_result.stringValue = "Awaiting Delivery"
      else
        NSLog(response2)
        @current_state_result.stringValue = "Current State"
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
