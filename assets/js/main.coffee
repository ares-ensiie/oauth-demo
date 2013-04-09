send_api_request = (event) ->
  input = $('input[type=text]')
  if input.val() != "" && (event.type == "click" || event.which == 13)
    $.ajax
      type: "POST",
      url: "/api_request",
      data:
        endpoint: input.val()
      success: (data) ->
        result = $("code")
        result.html(hljs.highlight("json", JSON.stringify(JSON.parse(data), null, "  ")).value)
        result.css('display', 'block')
        if result.css('opacity') == "1"
          result.animate
            opacity: 0
            200, 'ease-out', ->
              result.animate
                opacity: 1
                200, 'ease-out'
        else
          result.animate
            opacity: 1
            400, 'ease-out'
          
      error: (xhr, type) ->
        if xhr.statusCode == 401
          location.reload()
        else
          alert(xhr.response)

$ ->
  $('input[type=text]').on 'keypress', send_api_request
  $('input[type=submit]').on 'click', send_api_request
  
  $("#self").on "click", ->
    $('input[type=text]').val("/users/self")
    $('input[type=submit]').click()
  $("#everybody").on "click", ->
    $('input[type=text]').val("/promotions")
    $('input[type=submit]').click()
