window.onload = ->
  new DomCarousel $('#hold')

class DomCarousel
  constructor: (wrap) ->
    @wrap           = wrap
    @container      = @wrap.parent()
    @elements       = @wrap.find('td')
    @currentActive  = ~~(@elements.length/2)
    @currentShift   = 0;
    @canCall        = true

    @setListeners()
    @setActive @elements.eq @currentActive
    @

  setListeners: ->
    @wrap.on 'touchstart', @touchStart
    @wrap.on 'touchmove', @touchMove
    @elements.on 'click', @setActive

  touchMove: (e) =>
    moveDiff = e.originalEvent.touches[0].clientX - @touchDownPosition
    if Math.abs(moveDiff) > 150 and @canCall
      @canCall = false
      if moveDiff > 0 and moveDiff then @prevItem() else @nextItem()
      @touchDownPosition = e.originalEvent.touches[0].clientX
      setTimeout () =>
        @canCall = true
      , 90
    e.preventDefault()

  centerActive: () ->
    @centerElement @elements.eq @currentActive

  nextItem: () ->
    if @currentActive + 1 < @elements.length
      @setActive @elements.eq ++@currentActive

  prevItem: () ->
    if @currentActive
      @currentActive -= 1
      @setActive @elements.eq @currentActive

  touchStart: (e) =>
    @touchDownPosition = e.originalEvent.touches[0].clientX

  setActive: (elm) =>
    elm = if elm.currentTarget then $(elm.currentTarget) else elm
    if !elm.hasClass 'active'
      elm.removeAttr 'class'
      elm.siblings().removeAttr 'class'
      elm.prevAll().addClass 'before'
      elm.nextAll().addClass 'after'
      elm.addClass 'active'
      @centerElement elm

  centerElement: (elm) ->
    toMove = (elm.offset().left + elm.width()/2 - @container.width()/2 - @container.offset().left) + @currentShift
    @currentShift = toMove
    @wrap.css 'transform', "translateX(#{-1 * toMove}px)"
    @currentShift = toMove