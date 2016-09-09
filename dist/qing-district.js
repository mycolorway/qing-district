/**
 * qing-district v0.0.1
 * http://mycolorway.github.io/qing-district
 *
 * Copyright Mycolorway Design
 * Released under the MIT license
 * http://mycolorway.github.io/qing-district/license.html
 *
 * Date: 2016-09-9
 */
;(function(root, factory) {
  if (typeof module === 'object' && module.exports) {
    module.exports = factory(require('jquery'),require('qing-module'));
  } else {
    root.QingDistrict = factory(root.jQuery,root.QingModule);
  }
}(this, function ($,QingModule) {
var define, module, exports;
var b = require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Controller, ListView, Ref,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ListView = require("./view/list-view.coffee");

Ref = require("./view/ref.coffee");

Controller = (function(superClass) {
  extend(Controller, superClass);

  Controller.prototype.opts = {
    target: null,
    dataStore: null,
    type: null,
    codes: []
  };

  function Controller() {
    var ref;
    Controller.__super__.constructor.apply(this, arguments);
    ref = this.opts, this.target = ref.target, this.type = ref.type, this.dataStore = ref.dataStore, this.codes = ref.codes;
    this.field = this.target.find("[data-" + this.type + "-field]");
    this.dataMap = this.dataStore.findByType(this.type);
    this.listView = new ListView();
    this.ref = new Ref();
    this._init();
    this._bind();
  }

  Controller.prototype._init = function() {
    var code, item;
    code = this.field.val();
    if (item = this.dataMap[code]) {
      this.current = item;
      this.ref.linkTo(item);
      this.listView.highlightItem(item);
    }
    return this.render();
  };

  Controller.prototype._bind = function() {
    this.listView.on("select", (function(_this) {
      return function(e, code) {
        _this.selectByCode(code);
        _this.listView.hide();
        _this.trigger("afterSelect", [_this]);
        return false;
      };
    })(this));
    return this.ref.on("visit", (function(_this) {
      return function(e, code) {
        _this.selectByCode(code);
        _this.listView.show();
        _this.trigger("visit", _this);
        return false;
      };
    })(this));
  };

  Controller.prototype.selectByCode = function(code) {
    this.current = this.dataMap[code];
    this.ref.linkTo(this.current);
    this.listView.highlightItem(this.current);
    this.field.val(this.current.code);
    return this;
  };

  Controller.prototype.reset = function() {
    this.field.val(null);
    this.ref.reset();
    return this;
  };

  Controller.prototype.setCodes = function(codes) {
    this.codes = codes;
    return this;
  };

  Controller.prototype.isSelected = function() {
    return !!this.field.val();
  };

  Controller.prototype.render = function() {
    var code, i, items, len, ref, ref1;
    if (this.codes === "all") {
      this.codes = Object.keys(this.dataMap);
    }
    if (!this.codes) {
      return;
    }
    items = [];
    ref = this.codes;
    for (i = 0, len = ref.length; i < len; i++) {
      code = ref[i];
      items.push(this.dataMap[code]);
    }
    this.listView.render(items);
    this.listView.highlightItem(this.dataMap[(ref1 = this.current) != null ? ref1.code : void 0]);
    this.listView.show();
    return this;
  };

  return Controller;

})(QingModule);

module.exports = Controller;

},{"./view/list-view.coffee":3,"./view/ref.coffee":5}],2:[function(require,module,exports){
var DataStore;

DataStore = (function() {
  function DataStore(rawData) {
    this.data = this.formatData(rawData);
  }

  DataStore.prototype.findByType = function(type) {
    return this.data[type];
  };

  DataStore.prototype.formatData = function(data) {
    var c, city, county, ct, i, j, k, len, len1, len2, p, province, ref, ref1;
    if (!$.isArray(data)) {
      return;
    }
    province = {};
    city = {};
    county = {};
    for (i = 0, len = data.length; i < len; i++) {
      p = data[i];
      province[p.code] = {
        code: p.code,
        name: p.name,
        cities: []
      };
      ref = p.cities;
      for (j = 0, len1 = ref.length; j < len1; j++) {
        c = ref[j];
        province[p.code].cities.push(c.code);
        city[c.code] = {
          code: c.code,
          name: c.name,
          counties: []
        };
        ref1 = c.counties;
        for (k = 0, len2 = ref1.length; k < len2; k++) {
          ct = ref1[k];
          city[c.code].counties.push(ct.code);
          county[ct.code] = {
            code: ct.code,
            name: ct.name
          };
        }
      }
    }
    return {
      province: province,
      city: city,
      county: county
    };
  };

  return DataStore;

})();

module.exports = DataStore;

},{}],3:[function(require,module,exports){
var ListView,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ListView = (function(superClass) {
  extend(ListView, superClass);

  function ListView() {
    ListView.__super__.constructor.apply(this, arguments);
    this.el = $("<div class=\"district-list\">\n  <dl><dd></dd></dl>\n</div>").hide();
    this.el.on("click", "a", (function(_this) {
      return function(e) {
        var $item;
        $item = $(e.currentTarget);
        return _this.trigger("select", [$item.data("code")]);
      };
    })(this));
  }

  ListView.prototype.highlightItem = function(item) {
    if (!item) {
      return;
    }
    this.el.find("a").removeClass("active");
    return this.el.find("[data-code=" + item.code + "]").addClass("active");
  };

  ListView.prototype.show = function() {
    return this.el.show();
  };

  ListView.prototype.hide = function() {
    return this.el.hide();
  };

  ListView.prototype.render = function(items) {
    var i, item, len, results;
    this.el.find('dd').empty();
    results = [];
    for (i = 0, len = items.length; i < len; i++) {
      item = items[i];
      results.push($("<a title='" + item.name + "' data-code='" + item.code + "' href='javascript:;'>\n  " + item.name + "\n</a>").appendTo(this.el.find('dd')));
    }
    return results;
  };

  return ListView;

})(QingModule);

module.exports = ListView;

},{}],4:[function(require,module,exports){
var Popover,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Popover = (function(superClass) {
  extend(Popover, superClass);

  Popover.prototype.opts = {
    target: null,
    wrapper: null
  };

  function Popover() {
    Popover.__super__.constructor.apply(this, arguments);
    this.wrapper = $(this.opts.wrapper);
    this.target = $(this.opts.target);
    this.el = $('<div class="district-popover"></div>').appendTo(this.wrapper);
  }

  Popover.prototype.setActive = function(active) {
    if (active) {
      return this._show();
    } else {
      return this._hide();
    }
  };

  Popover.prototype._show = function() {
    this.el.show();
    $(document).off('click.qing-district').on('click.qing-district', (function(_this) {
      return function(e) {
        var $target;
        $target = $(e.target);
        if (!_this.wrapper.hasClass('active')) {
          return;
        }
        if (_this.target.has($target).length || $target.is(_this.target)) {
          return;
        }
        return _this._hide();
      };
    })(this));
    return this.trigger("show");
  };

  Popover.prototype._hide = function() {
    $(document).off('.qing-district');
    this.el.hide();
    return this.trigger("hide");
  };

  return Popover;

})(QingModule);

module.exports = Popover;

},{}],5:[function(require,module,exports){
var Ref,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Ref = (function(superClass) {
  extend(Ref, superClass);

  function Ref() {
    this.el = $('<a class="district-item" href="javascript:;"></a>').hide();
    this.el.on("click", (function(_this) {
      return function(e) {
        return _this.trigger("visit", [$(e.currentTarget).data("code")]);
      };
    })(this));
  }

  Ref.prototype.linkTo = function(item) {
    return this.el.text(item.name).data("code", item.code).show();
  };

  Ref.prototype.reset = function() {
    return this.el.text("").hide();
  };

  return Ref;

})(QingModule);

module.exports = Ref;

},{}],"qing-district":[function(require,module,exports){
var Controller, DataStore, Popover, QingDistrict,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

DataStore = require("./data-store.coffee");

Popover = require("./view/popover.coffee");

Controller = require("./controller.coffee");

QingDistrict = (function(superClass) {
  extend(QingDistrict, superClass);

  QingDistrict.opts = {
    el: null,
    dataSource: null
  };

  QingDistrict._tpl = '<div class="qing-district-wrapper">\n  <div class="district-info empty">\n    <span class="placeholder">点击选择城市</span>\n  </div>\n</div>';

  function QingDistrict(opts) {
    QingDistrict.__super__.constructor.apply(this, arguments);
    this.opts = $.extend({}, QingDistrict.opts, this.opts);
    this.el = $(this.opts.el);
    if (!(this.el.length > 0)) {
      throw new Error('QingDistrict: option el is required');
    }
    if (!$.isFunction(this.opts.dataSource)) {
      throw new Error('QingDistrict: option dataSource is required');
    }
    this._render();
    this.popover = new Popover({
      target: this.el,
      wrapper: this.wrapper
    });
    this.opts.dataSource.call(null, (function(_this) {
      return function(data) {
        var controller, i, len, ref, type;
        _this.dataStore = new DataStore(data);
        _this.register(new Controller({
          target: _this.el,
          dataStore: _this.dataStore,
          type: "province",
          codes: "all"
        }));
        _this.register(new Controller({
          target: _this.el,
          dataStore: _this.dataStore,
          type: "city"
        }));
        _this.register(new Controller({
          target: _this.el,
          dataStore: _this.dataStore,
          type: "county"
        }));
        _this._bind();
        ref = ["province", "city", "county"];
        for (i = 0, len = ref.length; i < len; i++) {
          type = ref[i];
          controller = _this.controllers[type];
          if (controller.isSelected()) {
            controller.trigger("afterSelect", [controller, true]);
          }
        }
        if (_this.isFullFilled()) {
          _this.setInfoBarActive(true);
        }
        return _this.trigger('ready');
      };
    })(this));
  }

  QingDistrict.prototype.isFullFilled = function() {
    var i, len, ref, type;
    ref = ["province", "city", "county"];
    for (i = 0, len = ref.length; i < len; i++) {
      type = ref[i];
      if (!this.controllers[type].isSelected()) {
        return false;
      }
    }
    return true;
  };

  QingDistrict.prototype.register = function(controller) {
    this.el.find(".district-info").append(controller.ref.el);
    this.popover.el.append(controller.listView.el);
    this.controllers || (this.controllers = {});
    return this.controllers[controller.type] = controller;
  };

  QingDistrict.prototype.setInfoBarActive = function(active) {
    return this.wrapper.find('.district-info').toggleClass("empty", !active);
  };

  QingDistrict.prototype._render = function() {
    this.wrapper = $(QingDistrict._tpl).data('district', this).prependTo(this.el);
    return this.el.addClass(' qing-district').data('qingDistrict', this);
  };

  QingDistrict.prototype._bind = function() {
    this.wrapper.on('click', '.district-info', (function(_this) {
      return function() {
        if (_this.wrapper.hasClass('active')) {
          return _this.popover.setActive(false);
        } else {
          _this.controllers.province.render();
          return _this.popover.setActive(true);
        }
      };
    })(this));
    this.popover.on("show", function() {
      return this.wrapper.addClass("active");
    }).on("hide", (function(_this) {
      return function() {
        var controller, ref, results, type;
        _this.wrapper.removeClass("active");
        if (!_this.isFullFilled()) {
          ref = _this.controllers;
          results = [];
          for (type in ref) {
            controller = ref[type];
            controller.reset();
            results.push(_this.setInfoBarActive(false));
          }
          return results;
        }
      };
    })(this));
    this.controllers.province.on("afterSelect", (function(_this) {
      return function(e, province, init) {
        var city, codes;
        if (!init) {
          _this.setInfoBarActive(true);
        }
        codes = province.current.cities;
        city = _this.controllers.city;
        if (codes.length === 1 && city.dataMap[codes[0]].name === province.current.name) {
          city.reset().selectByCode(codes[0]).ref.el.hide();
          if (!init) {
            city.trigger("afterSelect", city);
          }
        } else {
          if (!init) {
            city.reset();
          }
          city.setCodes(codes).render();
        }
        if (!init) {
          return _this.controllers.county.reset();
        }
      };
    })(this)).on("visit", (function(_this) {
      return function(e) {
        _this.controllers.city.listView.hide();
        _this.controllers.county.listView.hide();
        return _this.popover.setActive(true);
      };
    })(this));
    this.controllers.city.on("afterSelect", (function(_this) {
      return function(e, city, init) {
        var codes;
        if (!init) {
          _this.setInfoBarActive(true);
        }
        codes = city.current.counties;
        if (!init) {
          _this.controllers.county.reset();
        }
        return _this.controllers.county.setCodes(codes).render();
      };
    })(this)).on("visit", (function(_this) {
      return function(e) {
        _this.controllers.province.listView.hide();
        _this.controllers.county.listView.hide();
        return _this.popover.setActive(true);
      };
    })(this));
    return this.controllers.county.on("afterSelect", (function(_this) {
      return function(e, county, init) {
        if (!init) {
          _this.setInfoBarActive(true);
        }
        return _this.popover.setActive(false);
      };
    })(this)).on("visit", (function(_this) {
      return function(e) {
        _this.controllers.province.listView.hide();
        _this.controllers.city.listView.hide();
        return _this.popover.setActive(true);
      };
    })(this));
  };

  QingDistrict.prototype.destroy = function() {
    return this.el.empty().removeData('qingDistrict');
  };

  return QingDistrict;

})(QingModule);

module.exports = QingDistrict;

},{"./controller.coffee":1,"./data-store.coffee":2,"./view/popover.coffee":4}]},{},[]);

return b('qing-district');
}));
