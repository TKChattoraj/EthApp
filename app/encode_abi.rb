# methods to encode the abi

#convert string to ascii (utf-8) shown in 0x
def string_to_utf8(string)
  # s is string form of the method signature
  # s = "bar(bytes3[2])"
  s = string
  # s.unpack returns the 0x representation of the string in 0th element of array
  "0x" + s.unpack('H*')[0]
end




# function_selector provides the truncated 0x keccah-256 of the contract method being called
def function_selector(method_signature, &callback)
  web3_sha3(string_to_utf8(method_signature), &callback)  #note:  to do this properly, should be sending from here to web3_sha3 the callback to complete the truncating of the keccak hash--so that web3_sha3 is constrained to prodcuing the keccak hash only
end
