Backbone.View::formatPhoneNumber = (number) ->
  only_digits = number.replace(/\D/g,"")
  number_result = number

  if number[0] == "+"
    if only_digits.length > 11
      number_result = "#{only_digits[0]}-(#{only_digits.substring(1,4)})-#{only_digits.substring(4,7)}-#{only_digits.substring(7,11)}&nbsp;&nbsp;Ext. #{only_digits.substring(11,only_digits.length)}"
    else
      if only_digits.length <= 11
        number_result = "#{only_digits[0]}-(#{only_digits.substring(1,4)})-#{only_digits.substring(4,7)}-#{only_digits.substring(7,only_digits.length)}"
  else
    if only_digits.length <= 11
      number_result = "(#{only_digits.substring(0,3)})-#{only_digits.substring(3,6)}-#{only_digits.substring(6,only_digits.length)}"

  link_number = number.replace(/\ /g, ",,")

  "<a href=\"tel:#{link_number}\">#{number_result}</a>"
