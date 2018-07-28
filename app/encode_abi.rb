# methods to encode the abi

class Element

  attr_accessor :type, :number_elements, :head, :tail, :hex_string, :offset,  :link, :static

  def initialize(type, *value)
    @type = type
    @number_elements = nil
    @head = nil
    @tail = nil
    @offset = nil
    @link = nil
    @static = nil

    case @type
    when :uint
      @hex_string = uint(value[0])
      @static = true
    when :int
      @hex_string = int(value[0])
      @static = true
    when :address
      @hex_string = address(value[0])
      @static = true
    when :bool
      @hex_string = bool(value[0])
      @static = true
    when :bytes_static
      @hex_string = static_bytes(value[0])
      @static = true
    when :bytes_dynamic
      @hex_string = dynamic_bytes(value[0])
      @static = false
    when :string
      @hex_string = dynamic_string(value[0])
      @static = false
    when :non_fixed_size_array
      # value array is an array of Elements--need to pass to non_fixed_size_array method the hex_string of each element in this array.
      values_as_hex_strings = value.map{|v| v.hex_string} #an array of the hex strings of values
      p "Non_Fixed_Array:  values as hex strings array"
      p values_as_hex_strings

      @hex_string = non_fixed_size_array(values_as_hex_strings)
      @static = false
    when :dynamic_array
      values_as_hex_strings = value.map{|v| v.hex_string}
      @hex_string = dynamic_array(value)
      @static = false
    when :static_tuple
      #+++
      # Need to confirm all elements are static
      #+++
      values_as_hex_strings = value.map{|v| v.hex_string}  #an array of the hex strings of values
      p "Static Tuple:  values as hex strings array"
      p values_as_hex_strings
      @hex_string = static_tuple(values_as_hex_strings)
      @static = true

    when :dynamic_tuple


    end
  end # end initialize method

  def dynamic_array(element_array)  #element_array is array of elements
    number= element_array.length
    self.number_elements = "%064x" % number
    array_skeleton = [self.number_elements]
    head_length = 0
    element_array.each do |e|
      if e.static
        e.head = e.hex_string
        p "static e.head.length"
        p e.head.length
        p "end static e.head.length"
      else
        e.head = "0" * 64
        e.tail = e.hex_string
        p "dynamic e.head.length"
        p e.head.length
        p "end dynamic e.head.length"
      end
      head_length += e.head.length  #for each head element add 64 hex digits
    end

    tail_length = 0
    offset_value = head_length

    element_array.each do |e|  # add the head elements or placeholders for the dynamic elements where the head will point to the position of the e.tail element.
      array_skeleton << e.head
      if e.tail
        e.link = array_skeleton.length - 1  # e.link value is the array_skeleton index value for the e.head element
      end
    end

    element_array.each do |e|  #add in the tail elements and revise head elements with the correct offset
      if e.tail
        p "tail:"
        p e.tail
        p "End tail"
        array_skeleton << e.tail
        e.offset = "%064x" % offset_value
        array_skeleton[e.link] = e.offset
        p "tail offset"
        p e.offset
        p "End tail offset"
        offset_value += e.tail.length
      end
    end
    array_skeleton.join
  end

  def uint(int)
    "%064x" % int
  end

  def int(int)  #returns the hex string of the two's compliment of a decimal integer
   p "Running signed int method..."
   abs_int = int.abs
   b_str = abs_int.to_s(2)
   pad_0s = "0" * (256 - b_str.length)
   b_padded = pad_0s + b_str
   p b_padded


    if int < 0  # if int is negative then need to flip and add to get two's compliement
     b_padded_array = b_padded.each_char.to_a
     b_flipped_array = b_padded_array.map do |c|
       if c == '1'
         c = '0'
       else
         c = '1'
       end
     end
      b_flipped = b_flipped_array.join  # a string
      p b_flipped
      int_flipped = b_flipped.to_i(2)  # a decimal integer
      p int_flipped
      two_comp_int = int_flipped + 1  # one to the flipped
      two_comp_b = two_comp_int.to_s(2)
      p two_comp_b
      two_comp_hex = two_comp_int.to_s(16)  # hex of the two's compliment maybe with extra digit
      p two_comp_hex
      p two_comp_hex.length
      two_comp_hex_64 = two_comp_hex[-64..two_comp_hex.length]  #hex of two's compliment sized at 32 bytes, 64 hex digits
      p two_comp_hex_64
      p two_comp_hex_64.length
      return two_comp_hex_64
    else
      two_comp_int = b_padded.to_i(2)
      two_comp_hex = "%064x" % two_comp_int
      return two_comp_hex
   end
  end

  def address(address_string)  #assume the address input is a string of the hex address
    pad = "0" * (64 - address_string.length)
    pad + address_string
  end

  def bool(bool)  # bool is either false or true
    if bool
      boolean = "0" * 63 + "1"
    else
      boolean = "0" * 63 + "0"
    end
    boolean
  end

  def static_bytes(b_string)
    b_string + "0" * (64 - b_string.length)
  end


  #convert string to ascii (utf-8) shown in 0x
  def string_to_utf8(string)
    # s is string form of the method signature
    # s = "bar(bytes3[2])"
    s = string
    # s.unpack returns the 0x representation of the string in 0th element of array
    "0x" + s.unpack('H*')[0]
  end


  def dynamic_string(string)
    utf8 = string.unpack('H*')[0]

    dynamic_bytes(utf8)
    # length = utf8.length # length of hex digits
    # number_bytes = "%064x" % (length/2 + (length % 2))  #number of bytes as a hex string--prepended with '0's so that the lnegth is 64.
    # utf8_with_zeros = utf8.ljust(64, padstr='0')
    # p "The encoded string: "
    # p number_bytes + utf8_with_zeros
    # p (number_bytes + utf8_with_zeros).length
    # number_bytes + utf8_with_zeros
  end

  def dynamic_bytes(byte_string)  # but these are dynamic and so do we pad?
    length = byte_string.length
    number_bytes_with_prepend_zeros = "%064x" % (length/2 + (length % 2)) #number of bytes as a hex string--prepended with '0's so that the lnegth is 64.

    ## need to rethink the padding on the dynamic byte string--padd 'if needed.'  Meaning what?  Needed when less than 64 hex digits?  or do you pad so that you have chunks of 64 hex digits?
    byte_string_with_append_zeros = byte_string + '0' * (64 - (length % 64))

    encoded_dynamic_byte = number_bytes_with_prepend_zeros + byte_string_with_append_zeros
    p "The encoded dynamic byte string:"
    p encoded_dynamic_byte
    p encoded_dynamic_byte.length

    encoded_dynamic_byte
  end

  def non_fixed_size_array(elements_array) # assume elements are encoded
    length = elements_array.length
    size = "%064x" % length
    p "array size size"
    p size.length
    p "number in array as decimal and then hex"
    p length
    p size
    size + elements_array.join
  end

  def static_tuple(elements_array)  #this assumes the arguments have already been encoded based on their individual types
    elements_array.join
  end



  # def dynamic_tuple(*args)  #each arg is an already encoded element
  #   head_elements = []
  #   tail_elements = []
  #   args.each_with_index do |i, arg|
  #     if <arg is a dynamic element>
  #       head_elements[i] = "0" * 64  # prestock the head elements
  #       tail_elements[i] = arg[i]
  #     else
  #       head_elements[i] = arg[i]
  #
  #
  # end



  # function_selector provides the truncated 0x keccah-256 of the contract method being called
  def function_selector(method_signature, &callback)
    web3_sha3(string_to_utf8(method_signature), &callback)  #note:  to do this properly, should be sending from here to web3_sha3 the callback to complete the truncating of the keccak hash--so that web3_sha3 is constrained to prodcuing the keccak hash only
  end

end

########
##  Methods below are repeated so as to be temporarily available outside of class Element
########

def uint(int)
  "%064x" % int
end

def int(int)  #returns the hex string of the two's compliment of a decimal integer
 p "Running signed int method..."
 abs_int = int.abs
 b_str = abs_int.to_s(2)
 pad_0s = "0" * (256 - b_str.length)
 b_padded = pad_0s + b_str
 p b_padded


  if int < 0  # if int is negative then need to flip and add to get two's compliement
   b_padded_array = b_padded.each_char.to_a
   b_flipped_array = b_padded_array.map do |c|
     if c == '1'
       c = '0'
     else
       c = '1'
     end
   end
    b_flipped = b_flipped_array.join  # a string
    p b_flipped
    int_flipped = b_flipped.to_i(2)  # a decimal integer
    p int_flipped
    two_comp_int = int_flipped + 1  # one to the flipped
    two_comp_b = two_comp_int.to_s(2)
    p two_comp_b
    two_comp_hex = two_comp_int.to_s(16)  # hex of the two's compliment maybe with extra digit
    p two_comp_hex
    p two_comp_hex.length
    two_comp_hex_64 = two_comp_hex[-64..two_comp_hex.length]  #hex of two's compliment sized at 32 bytes, 64 hex digits
    p two_comp_hex_64
    p two_comp_hex_64.length
    return two_comp_hex_64
  else
    two_comp_int = b_padded.to_i(2)
    two_comp_hex = "%064x" % two_comp_int
    return two_comp_hex
 end
end

def address(address_string)  #assume the address input is a string of the hex address
  pad = "0" * (64 - address_string.length)
  pad + address
end

def bool(bool)  # bool is either false or true
  if bool
    boolean = "0" * 63 + "1"
  else
    boolean = "0" * 63 + "0"
  end
  boolean
end

def static_bytes(b_string)
  b_string + "0" * (64 - b_string.length)
end


#convert string to ascii (utf-8) shown in 0x
def string_to_utf8(string)
  # s is string form of the method signature
  # s = "bar(bytes3[2])"
  s = string
  # s.unpack returns the 0x representation of the string in 0th element of array
  "0x" + s.unpack('H*')[0]
end


def dynamic_string(string)
  utf8 = string.unpack('H*')[0]

  dynamic_bytes(utf8)
  # length = utf8.length # length of hex digits
  # number_bytes = "%064x" % (length/2 + (length % 2))  #number of bytes as a hex string--prepended with '0's so that the lnegth is 64.
  # utf8_with_zeros = utf8.ljust(64, padstr='0')
  # p "The encoded string: "
  # p number_bytes + utf8_with_zeros
  # p (number_bytes + utf8_with_zeros).length
  # number_bytes + utf8_with_zeros
end

def dynamic_bytes(byte_string)  # but these are dynamic and so do we pad?
  length = byte_string.length
  number_bytes_with_prepend_zeros = "%064x" % (length/2 + (length % 2)) #number of bytes as a hex string--prepended with '0's so that the lnegth is 64.

  ## need to rethink the padding on the dynamic byte string--padd 'if needed.'  Meaning what?  Needed when less than 64 hex digits?  or do you pad so that you have chunks of 64 hex digits?
  byte_string_with_append_zeros = byte_string + '0' * (64 - (length % 64))

  encoded_dynamic_byte = number_bytes_with_prepend_zeros + byte_string_with_append_zeros
  p "The encoded dynamic byte string:"
  p encoded_dynamic_byte
  p encoded_dynamic_byte.length

  encoded_dynamic_byte
end

def non_fixed_size_array(*args) # assume args are already encoded elements
  length = args.length
  size = "%064x" % length
  p "array size size"
  p size.length
  size + args.join
end





def static_tuple(*args)  #this assumes the arguments have already been encoded based on their individual types
  args.join
end



# def dynamic_tuple(*args)  #each arg is an already encoded element
#   head_elements = []
#   tail_elements = []
#   args.each_with_index do |i, arg|
#     if <arg is a dynamic element>
#       head_elements[i] = "0" * 64  # prestock the head elements
#       tail_elements[i] = arg[i]
#     else
#       head_elements[i] = arg[i]
#
#
# end



# function_selector provides the truncated 0x keccah-256 of the contract method being called
def function_selector(method_signature, &callback)
  web3_sha3(string_to_utf8(method_signature), &callback)  #note:  to do this properly, should be sending from here to web3_sha3 the callback to complete the truncating of the keccak hash--so that web3_sha3 is constrained to prodcuing the keccak hash only
end
