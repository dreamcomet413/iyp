class Widget.Views.StandardOffer extends Widget.Views.BasicOffer
  template: JST['offer/standard_offer']
  events:
    "click .phone-number": "showPhoneNumber",
    'click .close-reveal-modal': "setCloseWindowTime"

  initialize: ->
    @setFinalizedPhoneNumber()

  setClickedTime: ->
    @requestFor "set_clicked_time"

  showPhoneNumber: ->
    @setClickedTime()
    counterClass = ".counter-#{@model.get('id')}"
    if @model.get('num_type') > 2
      $(counterClass).countdown({ until: +60, format: 'MS', layout: 'This number will expire in: {mn}:{sn}', onExpiry: ->
        $('.phone-number a').replaceWith('<h1>View Phone Number</h1>')
        $(counterClass).html('')
        $('.phone-number').bind("click", @showPhoneNumber)
        $(counterClass).removeClass('hasCountdown')
      })
    number = $('.phone-number h1').data("phone-number")
    link = $('.phone-number h1').data("phone-number-link")
    if number? and link?
      @addLink(number, link)
    else
      @getNewPhoneNumberFromDB()

  getNewPhoneNumberFromDB: ->
    $.ajax
      type: 'GET'
      url: "/api/offer/latest_num_match/#{@model.get('num_type')}"
      success: (resp) =>
        number = resp['display_num']
        @model.set('phone_number_from_num_matches', number)
        @setFinalizedPhoneNumber()
        number = @model.get('finalPhoneNumber')
        link = @model.get('finalPhoneNumberLink')
        @addLink(number, link)


  addLink: (number, link) ->
    $('.phone-number h1').replaceWith('<a href="tel:' + link + '">'+ number + '</a>')
    $('.phone-number').unbind("click")
    if jQuery.browser.mobile
      window.location = $('.phone-number a').first().attr('href')


  setFinalizedPhoneNumber: ->
    number = ""
    if @model.get('num_type') == 1
      number = @model.get('term_num')
    else if @model.get('num_type') == 2
      number = @model.get('alt_phone')
    else if @model.get('num_type') >= 3
      number = @model.get('phone_number_from_num_matches')

    link = ""
    if number.indexOf(" ") != -1
      array = number.split(" ")
      number = "#{@formatNumber(array[0])} Ext. #{array[1]}"
      link = "#{array[0]},,#{array[1]}"
    else
      link = number
      number = @formatNumber(number)

    @model.set('finalPhoneNumber', number)
    @model.set('finalPhoneNumberLink', link)

  formatNumber: (number) ->
    if number.substring(0, 2) == "+1"
      prefix = number.substring(1, 2)
      first = "(#{number.substring(2, 5)})"
      second = "#{number.substring(5, 8)}"
      third = "#{number.substring(8, 12)}"
      "#{prefix}-#{first}-#{second}-#{third}"
    else
      number




