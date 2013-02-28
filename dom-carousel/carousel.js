// Generated by CoffeeScript 1.3.3
(function() {
  var DomCarousel,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.onload = function() {
    return new DomCarousel($('#hold'));
  };

  DomCarousel = (function() {

    function DomCarousel(wrap) {
      this.setActive = __bind(this.setActive, this);

      this.touchStart = __bind(this.touchStart, this);

      this.touchMove = __bind(this.touchMove, this);
      this.wrap = wrap;
      this.container = this.wrap.parent();
      this.elements = this.wrap.find('td');
      this.currentActive = ~~(this.elements.length / 2);
      this.currentShift = 0;
      this.canCall = true;
      this.setListeners();
      this.setActive(this.elements.eq(this.currentActive));
      this;

    }

    DomCarousel.prototype.setListeners = function() {
      this.wrap.on('touchstart', this.touchStart);
      this.wrap.on('touchmove', this.touchMove);
      return this.elements.on('click', this.setActive);
    };

    DomCarousel.prototype.touchMove = function(e) {
      var moveDiff,
        _this = this;
      moveDiff = e.originalEvent.touches[0].clientX - this.touchDownPosition;
      if (Math.abs(moveDiff) > 150 && this.canCall) {
        this.canCall = false;
        if (moveDiff > 0 && moveDiff) {
          this.prevItem();
        } else {
          this.nextItem();
        }
        this.touchDownPosition = e.originalEvent.touches[0].clientX;
        setTimeout(function() {
          return _this.canCall = true;
        }, 90);
      }
      return e.preventDefault();
    };

    DomCarousel.prototype.centerActive = function() {
      return this.centerElement(this.elements.eq(this.currentActive));
    };

    DomCarousel.prototype.nextItem = function() {
      if (this.currentActive + 1 < this.elements.length) {
        return this.setActive(this.elements.eq(++this.currentActive));
      }
    };

    DomCarousel.prototype.prevItem = function() {
      if (this.currentActive) {
        this.currentActive -= 1;
        return this.setActive(this.elements.eq(this.currentActive));
      }
    };

    DomCarousel.prototype.touchStart = function(e) {
      return this.touchDownPosition = e.originalEvent.touches[0].clientX;
    };

    DomCarousel.prototype.setActive = function(elm) {
      elm = elm.currentTarget ? $(elm.currentTarget) : elm;
      if (!elm.hasClass('active')) {
        elm.removeAttr('class');
        elm.siblings().removeAttr('class');
        elm.prevAll().addClass('before');
        elm.nextAll().addClass('after');
        elm.addClass('active');
        return this.centerElement(elm);
      }
    };

    DomCarousel.prototype.centerElement = function(elm) {
      var toMove;
      toMove = (elm.offset().left + elm.width() / 2 - this.container.width() / 2 - this.container.offset().left) + this.currentShift;
      this.currentShift = toMove;
      this.wrap.css('transform', "translateX(" + (-1 * toMove) + "px)");
      return this.currentShift = toMove;
    };

    return DomCarousel;

  })();

}).call(this);