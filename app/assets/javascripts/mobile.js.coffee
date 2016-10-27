jQuery ->
  if jQuery.browser.mobile
    if $("#banner_480").length < 1
      $("header .wrapper").before("<div id='banner_480'><img src='/assets/banner_480.png'/></div>")
      $("header .report-a-problem").hide()
    if $("#header_text_480").length < 1
      $("header .form form").before("<div id='header_text_480'><label class='title'>Find a Business</label><label class='login'><a href='http://earn.paypercall.org'>Log in</a></label></div>")
      $("header .form form").css("clear", "both")
    if $("#input_text_1").length < 1
      $("#search_form .input_2").before("<div id='input_text_1' class='sample_text_input'><label>City, State (e.g Seattle, WA)</label></div>")
    if $("#input_text_2").length < 1
      $("#search_form .input_2").after("<div id='input_text_2' class='sample_text_input'><label>Business Name or Category (e.g. Plumbers)</label></div>")
    if $("#search_form button.submit").text() == ""
      $("#search_form button.submit").text("Find")

