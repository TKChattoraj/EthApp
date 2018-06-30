# methods to encode the abi

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
