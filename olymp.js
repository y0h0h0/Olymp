(function() {
  var OLYMP;

  OLYMP = function() {
    var byDragGroup, byID, primary;
    if (arguments[0] !== void 0) {
      primary = arguments[0];
      byDragGroup = $('[draggroup="' + primary + '"]');
      if (byDragGroup.length > 0) {
        OLYMP.nearly = primary;
        return OLYMP.fn;
      }
      byID = $('[olympid="' + primary + '"]');
      if (byID.length > 0) {
        OLYMP.nearly = byID;
        return OLYMP.fn;
      }
    }
    return OLYMP;
  };

  OLYMP.fn = {};

  OLYMP.fn.getArgs = function() {
    var args;
    args = [].slice.call(arguments[0]);
    args.unshift(OLYMP.nearly);
    delete OLYMP.nearly;
    return args;
  };

  OLYMP.fn.click = {};

  OLYMP.fn.click.on = function() {
    return OLYMP.click.on.apply(this, OLYMP.fn.getArgs(arguments));
  };

  OLYMP.fn.click.off = function() {
    return OLYMP.click.off.apply(this, OLYMP.fn.getArgs(arguments));
  };

  OLYMP.fn.drag = {};

  OLYMP.fn.drag.on = function() {
    return OLYMP.drag.on.apply(this, OLYMP.fn.getArgs(arguments));
  };

  OLYMP.fn.drag.off = function() {
    return OLYMP.drag.off.apply(this, OLYMP.fn.getArgs(arguments));
  };

  OLYMP.fn.input = {};

  OLYMP.fn.input.on = function() {
    return OLYMP.input.on.apply(this, OLYMP.fn.getArgs(arguments));
  };

  OLYMP.fn.input.off = function() {
    return OLYMP.input.off.apply(this, OLYMP.fn.getArgs(arguments));
  };

  OLYMP.fn.input.get = function() {
    return OLYMP.input.get.apply(this, OLYMP.fn.getArgs(arguments));
  };

  OLYMP.fn.input.set = function() {
    return OLYMP.input.set.apply(this, OLYMP.fn.getArgs(arguments));
  };

  OLYMP.fn.input.wrong = function() {
    return OLYMP.input.wrong.apply(this, OLYMP.fn.getArgs(arguments));
  };

  OLYMP.__typeOf = function(value) {
    var s, tty;
    s = typeof value;
    if (s === 'object') {
      if (value) {
        tty = Object.prototype.toString.call(value);
        if (tty !== '[object Object]') {
          if (tty === '[object Array]') {
            s = 'array';
          } else {
            s = 'null';
          }
        }
      }
    }
    return s;
  };

  OLYMP.start = (function(_this) {
    return function(AT) {
      if (OLYMP.AT || OLYMP.__typeOf(AT) !== 'object') {
        return OLYMP;
      }
      OLYMP.__storage = {};
      OLYMP.__storage.currentscreen = '';
      OLYMP.__storage.activeinput = null;
      OLYMP.__storage.callbackoninputdeactivate = null;
      OLYMP.__storage.callbackoninputenter = null;
      OLYMP.actiondata = {};
      OLYMP.obj = null;
      OLYMP.char = null;
      OLYMP.event = null;
      OLYMP.AT = AT;
      $('.card_header>.card_name').remove();
      $('.card_header>.score_wrapper').remove();
      $('.card_header').width(120);
      $('#board').addClass('cr');
      AT.place.addClass("placesettings");
      AT.scene = $.div('scene').attr({
        'olympid': 'scene'
      }).appendTo(AT.place);
      return OLYMP;
    };
  })(this);

  OLYMP.finish = function(a) {
    OLYMP.click.off();
    OLYMP.drag.off();
    if (a === 'trial') {
      return OLYMP.AT.place.find(".card_header a.card_back").trigger($$.buttonDown('up'));
    } else {
      return OLYMP.AT.tutor.the_end();
    }
  };

  OLYMP.animate = (function(_this) {
    return function() {
      var args, cb, css, duration, easing, selector;
      args = OLYMP.__parseArguments(arguments);
      if (args.subject === null) {
        return false;
      }
      selector = args.subject;
      css = args.object[0] || {};
      duration = args.number[0] || 1000;
      easing = args.string[0] || 'linear';
      cb = args["function"][0];
      OLYMP.lock();
      $(selector).animate(css, duration, easing, function() {
        OLYMP.unlock();
        if (cb) {
          return cb();
        }
      });
      return OLYMP;
    };
  })(this);

  OLYMP.lock = (function(_this) {
    return function() {
      return $.div('scenelocker').appendTo($('.scene'));
    };
  })(this);

  OLYMP.unlock = (function(_this) {
    return function(a) {
      if (a) {
        return $('.scenelocker').remove();
      } else {
        return $('.scenelocker').eq(0).remove();
      }
    };
  })(this);

  OLYMP.delay = (function(_this) {
    return function() {
      var args, cb, duration;
      args = OLYMP.__parseArguments(arguments);
      duration = args.number[0] || 1000;
      cb = args["function"][0];
      OLYMP.lock();
      $.delay(duration, function() {
        OLYMP.unlock();
        if (cb) {
          return cb();
        }
      });
      return OLYMP;
    };
  })(this);

  OLYMP.screen = function() {
    var a, args, b, cb, duration, screen;
    if (arguments.length === 0) {
      return OLYMP.__storage.currentscreen;
    }
    args = OLYMP.__parseArguments(arguments);
    if (!args.string[0]) {
      return false;
    }
    duration = args.number[0] || 0;
    screen = args.string[0];
    cb = args["function"][0];
    a = $('[data-screen]').not('[data-screen=' + screen + ']');
    b = $('[data-screen="' + screen + '"]');
    OLYMP.__storage.currentscreen = screen;
    if (duration === 0) {
      a.css({
        opacity: 0
      }).hide();
      b.css({
        opacity: 1
      }).show();
      if (cb) {
        return cb();
      }
    } else {
      if ($('[data-screen]').length > 1) {
        OLYMP.animate(a, {
          'opacity': 0
        }, duration / 2, function() {
          return a.hide();
        });
        $.delay(duration / 2, function() {
          b.show();
          return OLYMP.animate(b, {
            'opacity': 1
          }, duration / 2);
        });
      } else {
        b.show();
        OLYMP.animate(b, {
          'opacity': 1
        }, duration);
      }
      return $.delay(duration, (function(_this) {
        return function() {
          if (cb) {
            cb();
          }
          return OLYMP;
        };
      })(this));
    }
  };

  OLYMP.__parseArguments = function() {
    var arg, b, fnl, i, ii, _i, _j, _ref, _ref1;
    fnl = {};
    fnl.string = [];
    fnl.number = [];
    fnl.breaker = false;
    fnl.array = [];
    fnl.object = [];
    fnl["function"] = [];
    fnl.subject = null;
    for (i = _i = 0, _ref = arguments[0].length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      arg = arguments[0][i];
      if (arg === void 0) {
        continue;
      }
      if (arg instanceof jQuery) {
        fnl.subject = arg;
      } else {
        if (arg === false) {
          fnl.breaker = true;
        } else {
          if (OLYMP.__typeOf(arg) !== void 0) {
            fnl[OLYMP.__typeOf(arg)].push(arg);
          }
        }
      }
    }
    if (arguments[1] === void 0) {
      if (fnl.subject === null && fnl.string.length > 0) {
        ii = -1;
        for (i = _j = 0, _ref1 = fnl.string.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          ii++;
          b = $(fnl.string[ii]);
          if (b.length > 0) {
            fnl.subject = b;
            fnl.string.splice(ii, 1);
            break;
          }
        }
      }
    }
    return fnl;
  };

  OLYMP.__runcb = function(cb) {
    if (OLYMP.__typeOf(cb) === 'function') {
      return cb();
    }
  };

  OLYMP.render = (function(_this) {
    return function(layout) {
      var adobjx, appendPlace, currelem, i, scrn, _i, _ref;
      if (OLYMP.__typeOf(layout) === 'object') {
        layout = [layout];
      }
      adobjx = [];
      for (i = _i = 0, _ref = layout.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        if ($('[data-screen="' + layout[i]['screen'] + '"]').length === 0) {
          scrn = $.div('').attr('data-screen', layout[i]['screen']).hide().css({
            'opacity': 0
          }).appendTo(OLYMP.AT.scene);
        } else {
          scrn = $('[data-screen="' + layout[i]['screen'] + '"]').eq(0);
        }
        if (layout[i]['parent'] === void 0) {
          appendPlace = scrn;
        } else {
          appendPlace = $('[olympid="' + layout[i]['parent'] + '"]');
        }
        currelem = $.div(layout[i]['class']).css({
          'position': 'absolute',
          'left': layout[i]['x'],
          'top': layout[i]['y']
        }).html(layout[i]['content']).appendTo(appendPlace);
        if (layout[i]['css'] !== void 0) {
          currelem.css(layout[i]['css']);
        }
        if (layout[i]['attr'] !== void 0) {
          currelem.attr(layout[i]['attr']);
        }
        if (layout[i]['id'] !== void 0) {
          currelem.attr('olympid', layout[i]['id']);
        }
        if (layout[i]['digits'] !== void 0) {
          currelem.attr('olympdigits', layout[i]['digits']).append('<span></span>');
        }
        if (layout[i]['draggroup'] !== void 0) {
          currelem.attr('draggroup', layout[i]['draggroup']);
          if (layout[i]['slotid'] !== void 0) {
            currelem.attr({
              'slotid': layout[i]['slotid'],
              'storing': ''
            });
          } else {
            currelem.attr({
              'itemid': layout[i]['itemid'],
              'init_x': layout[i]['x'],
              'init_y': layout[i]['y']
            });
          }
        }
        adobjx.push(currelem);
      }
      if (adobjx.length > 1) {
        return adobjx;
      } else {
        return adobjx[0];
      }
    };
  })(this);

  OLYMP.__clearEvents = function(selector) {
    $(document).off("mousedown touchstart touchmove mousemove touchend mouseup mouseleave", selector);
    return $(selector).removeClass('olympclickable');
  };

  OLYMP.click = {};

  OLYMP.click.__storage = {};

  OLYMP.click.on = function() {
    var args;
    args = OLYMP.__parseArguments(arguments);
    if (args.subject) {
      if (args.subject.length === 0) {
        return false;
      }
      OLYMP.click.__storage[args.subject.selector] = true;
      OLYMP.__clearEvents(args.subject.selector);
      args.subject.addClass('olympclickable');
      return $(document).on("mousedown touchstart", args.subject.selector, function(event) {
        event.preventDefault();
        OLYMP.event = event;
        OLYMP.obj = $(this);
        return OLYMP.__runcb(args["function"][0]);
      });
    }
  };

  OLYMP.click.off = function() {
    var args, i, keys, _i, _ref, _results;
    args = OLYMP.__parseArguments(arguments);
    if (args.subject) {
      keys = [args.subject.selector];
    } else {
      keys = Object.keys(OLYMP.click.__storage);
    }
    _results = [];
    for (i = _i = 0, _ref = keys.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      delete OLYMP.click.__storage[keys[i]];
      _results.push(OLYMP.__clearEvents(keys[i]));
    }
    return _results;
  };

  OLYMP.drag = {};

  OLYMP.drag.__storage = {};

  OLYMP.drag.slot = null;

  OLYMP.drag.off = function() {
    var i, keys, _i, _ref, _results;
    if (arguments[0]) {
      keys = [arguments[0]];
    } else {
      keys = Object.keys(OLYMP.drag.__storage);
    }
    _results = [];
    for (i = _i = 0, _ref = keys.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      delete OLYMP.drag.__storage[keys[i]];
      _results.push(OLYMP.__clearEvents('[draggroup="' + keys[i] + '"][itemid]'));
    }
    return _results;
  };

  OLYMP.drag.on = function() {
    var argarr, argg, args, duration, hoverClass, i, options, opts, subject, tmp, _i, _ref;
    args = OLYMP.__parseArguments(arguments, true);
    subject = $('[draggroup="' + args.string[0] + '"][itemid]');
    OLYMP.__clearEvents(subject);
    options = {};
    if (args.string[1]) {
      argarr = args.string[1].toLowerCase().split(',');
      for (i = _i = 0, _ref = argarr.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        argg = argarr[i].trim();
        if (argg.indexOf(':') < 0) {
          options[argg] = true;
        } else {
          tmp = argg.split(':');
          options[tmp[0]] = tmp[1].trim();
        }
      }
    }
    if (args.number[0] !== void 0) {
      duration = args.number[0];
    } else {
      duration = 1000;
    }
    hoverClass = '';
    if (args.object[0]) {
      opts = args.object[0];
    } else {
      opts = {};
    }
    opts.options = options;
    opts.duration = duration;
    subject.addClass('olympclickable');
    OLYMP.drag.__storage[args.string[0]] = opts;
    $(document).on("mousedown touchstart", subject.selector, function(event) {
      var continuedrag, eventer, group, opt, _j, _ref1;
      event.preventDefault();
      group = $(this).attr('draggroup');
      if (!OLYMP.drag.currentDrag) {
        OLYMP.event = event;
        OLYMP.obj = $(this);
        continuedrag = true;
        continuedrag = OLYMP.__runcb(OLYMP.drag.__storage[group].beforestart);
        if (continuedrag === false) {
          return false;
        }
        if (!options.nozindex) {
          OLYMP.obj.css('z-index', 9999);
        }
        if (event.type === 'mousedown') {
          eventer = event.originalEvent;
        } else {
          eventer = event.originalEvent.touches[0];
        }
        OLYMP.drag.currentDrag = {
          group: group,
          obj: $(this),
          pagex: eventer['pageX'],
          pagey: eventer['pageY'],
          thisx: $(this).position().left,
          thisy: $(this).position().top,
          runonce: true
        };
        OLYMP.drag.slots = {};
        OLYMP.drag.slotcoordinates = [];
        opt = '';
        if (!options.filled && !options.exchange) {
          opt = '[storing=""]';
        }
        OLYMP.drag.slots = $('.scene').find('[slotid][draggroup="' + group + '"]' + opt + ',[slotid][draggroup="' + group + '"][storing="' + OLYMP.obj.attr('itemid') + '"]');
        for (i = _j = 0, _ref1 = OLYMP.drag.slots.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          OLYMP.drag.slotcoordinates.push(OLYMP.__getCoordinates(OLYMP.drag.slots.eq(i)));
        }
        OLYMP.__runcb(OLYMP.drag.__storage[group].start);
      }
      return false;
    });
    $(document).on("touchmove mousemove", OLYMP.AT.place, function(event) {
      var CDrug, eventer, group, newX, newY, step, target, ths;
      if (OLYMP.drag.currentDrag) {
        event.preventDefault();
        event.stopPropagation();
        OLYMP.event = event;
        CDrug = OLYMP.drag.currentDrag;
        ths = CDrug.obj;
        group = CDrug.group;
        options = OLYMP.drag.__storage[group].options;
        if (event.type === 'mousemove') {
          eventer = event.originalEvent;
        } else {
          eventer = event.originalEvent.touches[0];
        }
        if (options.direction !== 'y') {
          newX = +CDrug.thisx + (eventer['pageX'] - CDrug.pagex);
        }
        if (options.direction !== 'x') {
          newY = +CDrug.thisy + (eventer['pageY'] - CDrug.pagey);
        }
        if (options.step) {
          if (options.step === true) {
            step = 20;
          } else {
            step = +options.step;
          }
          newX = (+(Math.floor(newX / +step)) + (Math.round(newX % step / step))) * step;
          newY = (+(Math.floor(newY / +step)) + (Math.round(newY % step / step))) * step;
        }
        if (options.capped) {
          newX = Math.max(0, Math.min(ths.parent().outerWidth() - ths.outerWidth(), newX));
          newY = Math.max(0, Math.min(ths.parent().outerHeight() - ths.outerHeight(), newY));
        }
        ths.css({
          'left': newX,
          'top': newY
        });
        target = OLYMP.__getDragTarget();
        $('[slotid]').removeClass(OLYMP.drag.__storage[group].hover);
        if (target !== null) {
          target.addClass(OLYMP.drag.__storage[group].hover);
        }
        OLYMP.targetSlot = target;
        if (CDrug.runonce) {
          OLYMP.__runcb(OLYMP.drag.__storage[group].moveonce);
          CDrug.runonce = false;
        }
        return OLYMP.__runcb(OLYMP.drag.__storage[group].move);
      }
    });
    $(document).on("mouseleave", OLYMP.AT.place, function(event) {
      return OLYMP.__dragFinishing(event);
    });
    $(document).on("touchend mouseup", OLYMP.AT.place, function(event) {
      return OLYMP.__dragFinishing();
    });
    return OLYMP.__dragFinishing = function(event) {
      var CDrug, exchangerslot, group, obj, prevobj, prevslot, storage, target;
      if (OLYMP.drag.currentDrag) {
        OLYMP.event = event;
        CDrug = OLYMP.drag.currentDrag;
        target = OLYMP.__getDragTarget();
        OLYMP.targetSlot = target;
        obj = CDrug.obj;
        group = CDrug.group;
        storage = OLYMP.drag.__storage[group];
        exchangerslot = OLYMP.drag.currentDrag.exchangerslot;
        delete OLYMP.drag.currentDrag;
        OLYMP.drag.slots = {};
        OLYMP.drag.slotcoordinates = [];
        $('[slotid]').removeClass(OLYMP.drag.__storage[group].hover);
        if (target === null) {
          if (!storage.options.free) {
            return OLYMP.__moveToInitPosition(obj, storage.duration, storage.finish, storage.out);
          } else {
            obj.attr({
              'init_x': obj.position().left,
              'init_y': obj.position().top
            });
            $('[storing="' + obj.attr('itemid') + '"]').attr('storing', '');
            OLYMP.__runcb(storage.finish);
            return OLYMP.__runcb(storage.out);
          }
        } else {
          prevslot = exchangerslot;
          if (exchangerslot) {
            prevslot = exchangerslot;
          } else {
            prevslot = null;
          }
          prevobj = $('[itemid="' + target.attr('storing') + '"]');
          if (prevobj.length === 0) {
            prevobj = null;
          }
          if (prevobj !== null && obj.get(0) !== prevobj.get(0)) {
            if (prevslot === null || storage.options.filled) {
              OLYMP.__moveToInitPosition(prevobj, storage.duration);
            } else {
              if (storage.options.exchange) {
                if (prevslot.length === 1) {
                  OLYMP.__moveToSlot(prevobj, prevslot, storage.duration);
                } else {
                  OLYMP.__moveToInitPosition(prevobj, storage.duration);
                }
              }
            }
          }
          return OLYMP.__moveToSlot(obj, target, storage.duration, storage.finish, storage["in"]);
        }
      }
    };
  };

  OLYMP.__moveToSlot = function(item, slot, duration, cbfinish, cb) {
    var px, py;
    if (cbfinish == null) {
      cbfinish = null;
    }
    if (cb == null) {
      cb = null;
    }
    $('[storing="' + item.attr('itemid') + '"]').attr('storing', '');
    slot.attr('storing', item.attr('itemid'));
    px = slot.outerWidth() - item.outerWidth();
    py = slot.outerHeight() - item.outerHeight();
    return OLYMP.animate(item, {
      'left': slot.position().left + px / +2,
      'top': slot.position().top + py / +2
    }, duration, (function(_this) {
      return function() {
        OLYMP.obj.css('z-index', "");
        OLYMP.drag.slot = slot;
        OLYMP.__runcb(cbfinish);
        return OLYMP.__runcb(cb);
      };
    })(this));
  };

  OLYMP.__moveToInitPosition = function(item, duration, cbfinish, cb) {
    if (cbfinish == null) {
      cbfinish = null;
    }
    if (cb == null) {
      cb = null;
    }
    $('[storing="' + item.attr('itemid') + '"]').attr('storing', '');
    return OLYMP.animate(item, {
      'left': item.attr('init_x'),
      'top': item.attr('init_y')
    }, duration, (function(_this) {
      return function() {
        OLYMP.obj.css('z-index', "");
        OLYMP.drag.slot = null;
        OLYMP.__runcb(cbfinish);
        return OLYMP.__runcb(cb);
      };
    })(this));
  };

  OLYMP.getSlotValues = function() {
    var currentslot, i, slots, total, vall, _i, _ref;
    total = {};
    slots = $('[slotid]');
    for (i = _i = 0, _ref = slots.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      currentslot = slots.eq(i);
      if (currentslot.attr('storing') === '') {
        vall = null;
      } else {
        vall = currentslot.attr('storing');
      }
      if (total[currentslot.attr('draggroup')] === void 0) {
        total[currentslot.attr('draggroup')] = {};
      }
      total[currentslot.attr('draggroup')][currentslot.attr('slotid')] = vall;
    }
    return total;
  };

  OLYMP.setSlotValues = function() {
    var data, group, groups, item, px, py, slot, slotname, slotnames, _i, _len, _results;
    data = arguments[0];
    groups = Object.keys(data);
    _results = [];
    for (_i = 0, _len = groups.length; _i < _len; _i++) {
      group = groups[_i];
      slotnames = Object.keys(data[group]);
      _results.push((function() {
        var _j, _len1, _results1;
        _results1 = [];
        for (_j = 0, _len1 = slotnames.length; _j < _len1; _j++) {
          slotname = slotnames[_j];
          slot = $('[draggroup="' + group + '"][slotid="' + slotname + '"]');
          if (data[group][slotname] !== null) {
            item = $('[draggroup="' + group + '"][itemid="' + data[group][slotname] + '"]');
            slot.attr('storing', item.attr('itemid'));
            px = slot.outerWidth() - item.outerWidth();
            py = slot.outerHeight() - item.outerHeight();
            _results1.push(item.css({
              'left': slot.position().left + px / +2,
              'top': slot.position().top + py / +2
            }));
          } else {
            if (slot.attr('storing') !== '') {
              item = $('[draggroup="' + group + '"][itemid="' + slot.attr('storing') + '"]');
              slot.attr('storing', '');
              _results1.push(item.css({
                left: +item.attr('init_x'),
                top: +item.attr('init_y')
              }));
            } else {
              _results1.push(void 0);
            }
          }
        }
        return _results1;
      })());
    }
    return _results;
  };

  OLYMP.__getDragTarget = function() {
    var Interseption, currslot, group, h, i, mycoords, opt, options, square, target, w, _i, _len, _ref;
    if (!OLYMP.drag.currentDrag) {
      return false;
    }
    group = OLYMP.drag.currentDrag.group;
    options = OLYMP.drag.__storage[group].options;
    opt = '';
    if (!options.filled && !options.exchange) {
      opt = '[storing=""]';
    }
    target = null;
    square = 0;
    mycoords = OLYMP.__getCoordinates(OLYMP.obj);
    _ref = OLYMP.drag.slotcoordinates;
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      currslot = _ref[i];
      w = Math.min(mycoords.x2, currslot.x2) - Math.max(mycoords.x1, currslot.x1);
      h = Math.min(mycoords.y2, currslot.y2) - Math.max(mycoords.y1, currslot.y1);
      Interseption = Math.max(0, w) * Math.max(0, h);
      if (Interseption > square) {
        square = Interseption;
        target = OLYMP.drag.slots.eq(i);
      }
    }
    return target;
  };

  OLYMP.__getCoordinates = function(obj) {
    var coord;
    coord = {
      x1: $(obj).position().left,
      y1: $(obj).position().top,
      x2: $(obj).position().left + $(obj).outerWidth(),
      y2: $(obj).position().top + $(obj).outerHeight()
    };
    return coord;
  };

  OLYMP.input = {};

  OLYMP.input.on = function() {
    var args, input;
    args = OLYMP.__parseArguments(arguments);
    OLYMP.__storage.callbackoninputdeactivate = null;
    OLYMP.__storage.callbackoninputenter = null;
    input = args.subject;
    if (OLYMP.__storage.activeinput !== null) {
      OLYMP.input.off();
    }
    input = $(input);
    OLYMP.__storage.activeinput = input;
    if (args["function"][0] !== void 0) {
      OLYMP.__storage.callbackoninputdeactivate = args["function"][0];
    }
    if (args["function"][1] !== void 0) {
      OLYMP.__storage.callbackoninputenter = args["function"][1];
    }
    input.addClass('activeinput');
    return OLYMP.AT.tutor.keypad_start(['numeric', 'input'], (function(_this) {
      return function(char) {
        OLYMP.char = char;
        return OLYMP.input.__keypad(char);
      };
    })(this));
  };

  OLYMP.input.off = function() {
    if (OLYMP.__storage.activeinput !== null) {
      OLYMP.__storage.activeinput.removeClass('activeinput');
      OLYMP.__storage.activeinput = null;
      OLYMP.AT.tutor.keypad_finish();
      if (OLYMP.__storage.callbackoninputdeactivate !== null) {
        return OLYMP.__storage.callbackoninputdeactivate();
      }
    }
  };

  OLYMP.input.set = function(input, str) {
    var args;
    args = OLYMP.__parseArguments(arguments);
    input = args.subject;
    str = args.string[0];
    input.removeClass('inputWrong');
    return input.html(('' + str).substr(0, input.attr('olympdigits')) + '<span></span>');
  };

  OLYMP.input.get = function(input) {
    var ans, str;
    input = $(input);
    str = '' + input.html();
    ans = str.substr(0, str.length - 13);
    if (ans === '') {
      return '';
    } else {
      return parseInt(ans);
    }
  };

  OLYMP.input.__keypad = function(char) {
    var value;
    value = '' + OLYMP.input.get(OLYMP.__storage.activeinput);
    if (char !== 'tab') {
      if (char === 'backspace') {
        if (value.length > 0) {
          OLYMP.input.set(OLYMP.__storage.activeinput, value.substr(0, value.length - 1));
        }
      } else {
        if (char === 'enter') {
          OLYMP.input.off();
        } else {
          if (value.length < OLYMP.__storage.activeinput.attr('olympdigits')) {
            OLYMP.input.set(OLYMP.__storage.activeinput, value + char);
          }
        }
      }
    }
    if (OLYMP.__storage.callbackoninputenter !== null) {
      return OLYMP.__storage.callbackoninputenter();
    }
  };

  OLYMP.input.wrong = function(input) {
    input = $(input);
    return input.addClass('inputWrong');
  };

  OLYMP.action = {};

  OLYMP.action.off = function(selector) {
    return OLYMP.__clearEvents(selector);
  };

  OLYMP.action.on = function() {
    var args, onFinish, onMove, onStart, target;
    args = OLYMP.__parseArguments(arguments);
    onStart = onMove = onFinish = null;
    if (args["function"][0] !== void 0) {
      onStart = args["function"][0];
    } else {
      return false;
    }
    if (args["function"][1] !== void 0) {
      onMove = args["function"][1];
    }
    if (args["function"][2] !== void 0) {
      onFinish = args["function"][2];
    }
    if (onFinish === null) {
      onFinish = onMove;
    }
    target = args.subject || OLYMP.AT.place;
    $(document).on("mousedown touchstart", target.selector, function(event) {
      var eventer, pgx, pgy;
      if (args.subject) {
        event.preventDefault();
      }
      OLYMP.obj = $(this);
      OLYMP.event = event;
      if (event.type === 'mousedown') {
        eventer = event.originalEvent;
      } else {
        eventer = event.originalEvent.touches[0];
      }
      pgx = Math.floor(eventer['pageX'] - OLYMP.AT.scene.offset().left);
      pgy = Math.floor(eventer['pageY'] - OLYMP.AT.scene.offset().top);
      OLYMP.actiondata = {
        on: true,
        startx: pgx,
        starty: pgy,
        newx: pgx,
        newy: pgy
      };
      if (onStart) {
        return onStart();
      }
    });
    $(document).on("touchmove mousemove", OLYMP.AT.place, function(event) {
      var eventer;
      if (OLYMP.actiondata.on) {
        OLYMP.event = event;
        if (event.type === 'mousemove') {
          eventer = event.originalEvent;
        } else {
          eventer = event.originalEvent.touches[0];
        }
        OLYMP.actiondata.newx = Math.floor(eventer['pageX'] - OLYMP.AT.scene.offset().left);
        OLYMP.actiondata.newy = Math.floor(eventer['pageY'] - OLYMP.AT.scene.offset().top);
        if (onMove) {
          return onMove();
        }
      }
    });
    $(OLYMP.AT.place).on("mouseleave", function(event) {
      return OLYMP.__actionFinishing(event);
    });
    $(OLYMP.AT.place).on("touchend mouseup", function(event) {
      return OLYMP.__actionFinishing(event);
    });
    return OLYMP.__actionFinishing = function(event) {
      if (OLYMP.actiondata.on) {
        OLYMP.event = event;
        OLYMP.actiondata.on = false;
        if (onFinish) {
          return onFinish();
        }
      }
    };
  };

  window.onerror = function(msg, url, lineNo, columnNo, error) {
    var imsg;
    imsg = msg;
    if (imsg.indexOf(':') > -1) {
      imsg = imsg.split(':')[1].trim();
    }
    console.error('');
    console.error(imsg);
    console.error("%cDetails: " + url + ':' + lineNo, 'color: #1975d1;');
    return true;
  };

}).call(this);
