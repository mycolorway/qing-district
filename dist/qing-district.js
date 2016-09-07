/**
 * qing-district v0.0.1
 * http://mycolorway.github.io/qing-district
 *
 * Copyright Mycolorway Design
 * Released under the MIT license
 * http://mycolorway.github.io/qing-district/license.html
 *
 * Date: 2016-09-8
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
var Controller,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Controller = (function() {
  function Controller(context, type, codes1) {
    this.context = context;
    this.type = type;
    this.codes = codes1 != null ? codes1 : [];
    this._onClickListItem = bind(this._onClickListItem, this);
    this.ref = $('<a class="district-item" href="javascript:;"></a>').hide();
    this.list = $('<div class="district-list"><dl><dd></dd></dl></div>').hide();
    this.field = this.context.el.find("[data-" + this.type + "-field]");
    this.dataMap = this.context.data[this.type];
    this._bind();
    this._init();
  }

  Controller.prototype._init = function() {
    var code, data;
    code = this.field.val();
    if (data = this.dataMap[code]) {
      this.current = data;
      this.ref.text(data.name).show();
      this.list.find("[data-code=" + code + "]").addClass("active");
    }
    return this.render();
  };

  Controller.prototype._bind = function() {
    this.list.on("click", "a", this._onClickListItem);
    return this.ref.on("click", (function(_this) {
      return function(e) {
        _this.show();
        _this.context.showPopover();
        return false;
      };
    })(this));
  };

  Controller.prototype._onClickListItem = function(e) {
    var $item;
    $item = $(e.currentTarget);
    this.list.find("a").removeClass('active');
    $item.addClass('active');
    this.selectByCode($item.data('code'));
    if (!(this.field.length > 0)) {
      this.context.hidePopover();
      return false;
    }
    this.context.afterSelect(this.type);
    return false;
  };

  Controller.prototype.selectByCode = function(code) {
    this.current = this.dataMap[code];
    this.ref.text(this.current.name).show();
    this.field.val(this.current.code);
    return this;
  };

  Controller.prototype.reset = function() {
    this.field.val(null);
    this.ref.text("").hide();
    return this;
  };

  Controller.prototype.show = function() {
    this.context.el.find(".district-list").hide();
    this.list.show();
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
    var code, curCode, data, i, len, ref, ref1;
    this.list.find('dd').empty();
    if (this.codes === "all") {
      this.codes = Object.keys(this.dataMap);
    }
    ref = this.codes;
    for (i = 0, len = ref.length; i < len; i++) {
      code = ref[i];
      data = this.dataMap[code];
      $("<a title='" + data.name + "' data-code='" + code + "' href='javascript:;'>\n  " + data.name + "\n</a>").appendTo(this.list.find('dd'));
    }
    if (curCode = (ref1 = this.current) != null ? ref1.code : void 0) {
      this.list.find("[data-code=" + curCode + "]").addClass("active");
    }
    return this;
  };

  return Controller;

})();

module.exports = Controller;

},{}],2:[function(require,module,exports){
var Util;

Util = {
  normalizeData: function(data) {
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
  }
};

module.exports = Util;

},{}],"qing-district":[function(require,module,exports){
var Controller, QingDistrict, Util,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Util = require("./util.coffee");

Controller = require("./controller.coffee");

QingDistrict = (function(superClass) {
  extend(QingDistrict, superClass);

  QingDistrict.opts = {
    el: null,
    dataSource: null
  };

  QingDistrict._tpl = '<div class="qing-district">\n  <div class="district-info empty">\n    <span class="placeholder">点击选择城市</span>\n  </div>\n  <div class="district-popover">\n  </div>\n</div>';

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
    this.opts.dataSource.call(null, (function(_this) {
      return function(data) {
        var i, len, ref, type;
        _this.data = Util.normalizeData(data);
        _this._render();
        _this._bind();
        _this.register(new Controller(_this, "province", "all"));
        _this.register(new Controller(_this, "city"));
        _this.register(new Controller(_this, "county"));
        ref = ["province", "city", "county"];
        for (i = 0, len = ref.length; i < len; i++) {
          type = ref[i];
          if (_this.controllers[type].isSelected()) {
            _this.afterSelect(type, true);
          }
        }
        if (_this.isFullFilled()) {
          _this.resetSelectedInfoStatus(true);
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
    this.el.find(".district-info").append(controller.ref);
    this.el.find(".district-popover").append(controller.list);
    this.controllers || (this.controllers = {});
    return this.controllers[controller.type] = controller;
  };

  QingDistrict.prototype.resetSelectedInfoStatus = function(isEmpty) {
    return this.selectEl.find('.district-info').toggleClass("empty", !isEmpty);
  };

  QingDistrict.prototype.afterSelect = function(type, init) {
    var cityCtrl, codes, curProvice;
    if (init == null) {
      init = false;
    }
    if (!init) {
      this.resetSelectedInfoStatus(true);
    }
    switch (type) {
      case "province":
        curProvice = this.controllers.province.current;
        codes = curProvice.cities;
        cityCtrl = this.controllers.city;
        if (codes.length === 1 && cityCtrl.dataMap[codes[0]].name === curProvice.name) {
          cityCtrl.reset().selectByCode(codes[0]).ref.hide();
          if (!init) {
            this.afterSelect("city");
          }
        } else {
          if (!init) {
            cityCtrl.reset();
          }
          cityCtrl.setCodes(codes).render(true).show();
        }
        if (!init) {
          return this.controllers.county.reset();
        }
        break;
      case "city":
        codes = this.controllers.city.current.counties;
        if (!init) {
          this.controllers.county.reset();
        }
        return this.controllers.county.setCodes(codes).render(true).show();
      default:
        return this.hidePopover();
    }
  };

  QingDistrict.prototype._render = function() {
    this.selectEl = $(QingDistrict._tpl).data('district', this).prependTo(this.el);
    return this.el.addClass(' qing-district').data('qingDistrict', this);
  };

  QingDistrict.prototype._bind = function() {
    return this.selectEl.on('click', '.district-info', (function(_this) {
      return function() {
        if (_this.selectEl.hasClass('active')) {
          return _this.hidePopover();
        } else {
          _this.controllers.province.show();
          return _this.showPopover();
        }
      };
    })(this));
  };

  QingDistrict.prototype.showPopover = function() {
    this.selectEl.addClass('active');
    $(document).off('click.qing-district').on('click.qing-district', (function(_this) {
      return function(e) {
        var $target;
        $target = $(e.target);
        if (!_this.selectEl.hasClass('active')) {
          return;
        }
        if (_this.el.has($target).length || $target.is(_this.el)) {
          return;
        }
        return _this.hidePopover();
      };
    })(this));
    return this.trigger("showPopover");
  };

  QingDistrict.prototype.hidePopover = function() {
    var controller, ref, results, type;
    this.selectEl.removeClass('active');
    $(document).off('.qing-district');
    this.trigger("hidePopover");
    if (!this.isFullFilled()) {
      ref = this.controllers;
      results = [];
      for (type in ref) {
        controller = ref[type];
        controller.reset();
        results.push(this.resetSelectedInfoStatus(false));
      }
      return results;
    }
  };

  QingDistrict.prototype.destroy = function() {
    return this.el.empty().removeData('qingDistrict');
  };

  return QingDistrict;

})(QingModule);

module.exports = QingDistrict;

},{"./controller.coffee":1,"./util.coffee":2}]},{},[]);

return b('qing-district');
}));
