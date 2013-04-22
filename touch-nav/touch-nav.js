window.onload = setup;

function setup() {
  $('.touch-trigger ul').on("touchstart touchend", function(e) {
    e.preventDefault();
    return false;
  });

  $('.touch-trigger').on("touchstart", function() {
    var _this = $(this);
    _this.addClass("down");

    !_this.hasClass("opened") && _this.data({
        left: _this.css('left'),
        top: _this.css('top')
      });
  });

  $('.touch-trigger').on("touchmove", function(e) {
    var _this = $(this);
    !_this.hasClass("opened") && _this.css({
      left: e.originalEvent.touches[0].pageX - _this.width()/2,
      top: e.originalEvent.touches[0].pageY - _this.height()/2
    });
    e.preventDefault();
    return false;
  });

  $('.touch-trigger').on("touchend", function() {
    var _this = $(this);

    $("ul").removeClass("show");

    _this.toggleClass("opened")
      .removeClass("down")
      .css({
        top: _this.data("top"),
        left: _this.data("left")
      });
  });

  $('.touch-trigger').on("webkitTransitionEnd", function() {
    $(this).hasClass("opened") && $("ul").addClass("show");
  });
}
