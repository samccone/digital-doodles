$ ->
  $(window).on 'scroll', advance

advance = () ->
  artHeight = 500
  elementHeight = 216
  finishedAt = artHeight + elementHeight
  @container = @container || $('#paralax-container div').first()
  scrollBy = window.scrollY*(216/580)
  @container.css 'transform', "translateY(#{-scrollBy}px)"