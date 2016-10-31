/**
 * qing-district v0.0.1
 * http://mycolorway.github.io/qing-district
 *
 * Copyright Mycolorway Design
 * Released under the MIT license
 * http://mycolorway.github.io/qing-district/license.html
 *
 * Date: 2016-11-1
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
var DataStore,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

DataStore = (function(superClass) {
  extend(DataStore, superClass);

  function DataStore() {
    return DataStore.__super__.constructor.apply(this, arguments);
  }

  DataStore.prototype.load = function(dataSource) {
    return dataSource.call(null, (function(_this) {
      return function(data) {
        _this.data = _this.formatData(data);
        return _this.trigger("loaded", [_this.data]);
      };
    })(this));
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

})(QingModule);

module.exports = DataStore;

},{}],2:[function(require,module,exports){
var FieldProxyGroup,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

FieldProxyGroup = (function(superClass) {
  extend(FieldProxyGroup, superClass);

  function FieldProxyGroup() {
    return FieldProxyGroup.__super__.constructor.apply(this, arguments);
  }

  FieldProxyGroup.prototype.opts = {
    wrapper: null,
    placeholder: null
  };

  FieldProxyGroup.prototype._init = function() {
    this.el = $("<div class=\"district-field-proxy-group\">\n  <a class=\"placeholder\">" + this.opts.placeholder + "</a>\n</div>").appendTo(this.opts.wrapper);
    return this.setEmpty(true);
  };

  FieldProxyGroup.prototype.isEmpty = function() {
    return this.el.is(".empty");
  };

  FieldProxyGroup.prototype.setEmpty = function(empty) {
    return this.el.toggleClass("empty", empty);
  };

  return FieldProxyGroup;

})(QingModule);

module.exports = FieldProxyGroup;

},{}],3:[function(require,module,exports){
var FieldProxy,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

FieldProxy = (function(superClass) {
  extend(FieldProxy, superClass);

  function FieldProxy() {
    return FieldProxy.__super__.constructor.apply(this, arguments);
  }

  FieldProxy.prototype.opts = {
    group: null,
    data: null,
    field: null
  };

  FieldProxy.prototype._init = function() {
    var ref;
    ref = this.opts, this.group = ref.group, this.data = ref.data, this.field = ref.field;
    this.el = $('<a class="district-field-proxy" href="javascript:;"></a>').hide().appendTo(this.group.el);
    return this.el.on("click", (function(_this) {
      return function(e) {
        _this.setActive(true);
        return false;
      };
    })(this)).on("keydown", (function(_this) {
      return function(e) {
        if ($(e.target).is(_this.el) && e.which === 13) {
          return _this.setActive(true);
        }
      };
    })(this));
  };

  FieldProxy.prototype.restore = function() {
    var code, item;
    if (code = this.field.val()) {
      this.setItem(item = this.data[code]);
      return this.trigger("restore", [item]);
    }
  };

  FieldProxy.prototype.isFilled = function() {
    return !!this.field.val();
  };

  FieldProxy.prototype.setActive = function(active) {
    this.el.toggle(active);
    this.highlight(active);
    if (active) {
      this.trigger("active", this.getItem());
    }
    return this;
  };

  FieldProxy.prototype.highlight = function(active) {
    this.el.attr("tabindex", (active ? -1 : 0));
    return this.el.toggleClass("active", active);
  };

  FieldProxy.prototype.getItem = function() {
    return this.el.data("item");
  };

  FieldProxy.prototype.setItem = function(item) {
    this.el.text(item.name).data("item", item).show();
    this.field.val(item.code);
    return this;
  };

  FieldProxy.prototype.clear = function() {
    this.field.val(null);
    this.el.text("").data("item", null).hide();
    return this;
  };

  return FieldProxy;

})(QingModule);

module.exports = FieldProxy;

},{}],4:[function(require,module,exports){
var List,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

List = (function(superClass) {
  extend(List, superClass);

  function List() {
    return List.__super__.constructor.apply(this, arguments);
  }

  List.prototype.opts = {
    wrapper: null,
    data: null,
    codes: []
  };

  List.prototype._init = function() {
    var ref;
    ref = this.opts, this.wrapper = ref.wrapper, this.data = ref.data, this.codes = ref.codes;
    this.el = $("<div class=\"district-list\">\n  <dl><dd></dd></dl>\n</div>").hide().appendTo(this.wrapper);
    this.render();
    return this._bind();
  };

  List.prototype.highlightItem = function(item) {
    this.el.find("a").removeClass("active");
    if (item) {
      return this.el.find("[data-code=" + item.code + "]").addClass("active");
    }
  };

  List.prototype.show = function() {
    this.el.show();
    return this.trigger("show");
  };

  List.prototype.hide = function() {
    this.el.hide();
    return this.trigger("hide");
  };

  List.prototype._bind = function() {
    return this.el.on("click", "a", (function(_this) {
      return function(e) {
        var $item;
        $item = $(e.currentTarget);
        _this.setCurrent(_this.data[$item.data("code")]);
        _this.hide();
        _this.trigger("afterSelect", [_this.current]);
        return false;
      };
    })(this));
  };

  List.prototype.setCurrent = function(item) {
    this.highlightItem(this.current = item);
    return this;
  };

  List.prototype.setCodes = function(codes) {
    this.codes = codes;
    return this;
  };

  List.prototype.render = function() {
    var code, i, item, len, ref, ref1;
    if (this.codes === "all") {
      this.codes = Object.keys(this.data);
    }
    if (!this.codes) {
      return;
    }
    this.el.find('dd').empty();
    ref = this.codes;
    for (i = 0, len = ref.length; i < len; i++) {
      code = ref[i];
      item = this.data[code];
      $("<a data-code='" + item.code + "' tabindex='-1' href='javascript:;'>\n  " + item.name + "\n</a>").appendTo(this.el.find('dd'));
    }
    this.highlightItem(this.data[(ref1 = this.current) != null ? ref1.code : void 0]);
    this.show();
    return this;
  };

  return List;

})(QingModule);

module.exports = List;

},{}],5:[function(require,module,exports){
var Popover,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Popover = (function(superClass) {
  extend(Popover, superClass);

  function Popover() {
    return Popover.__super__.constructor.apply(this, arguments);
  }

  Popover.prototype.opts = {
    target: null,
    appendTo: null,
    offset: null
  };

  Popover.instanceCount = 0;

  Popover.prototype._init = function() {
    this.target = $(this.opts.target);
    this.el = $('<div class="qing-district-popover"></div>').appendTo(this.opts.appendTo || this.target);
    this.id = ++Popover.instanceCount;
    this.active = false;
    return this._bind();
  };

  Popover.prototype._bind = function() {
    return $(document).on("click.qing-district-popover-" + this.id, (function(_this) {
      return function(e) {
        if ($(e.target).is(_this.el) || $.contains(_this.el[0], e.target) || $.contains(_this.target[0], e.target)) {
          return;
        }
        _this.setActive(false);
        return null;
      };
    })(this));
  };

  Popover.prototype.setActive = function(active) {
    if (active === this.active) {
      return;
    }
    if (active) {
      this.el.addClass('active').appendTo(this.opts.appendTo);
      this.el.css({
        width: this.target.width()
      });
      this.resetPosition();
      this.trigger('show');
    } else {
      this.el.removeClass('active').detach();
      this.trigger('hide');
    }
    this.active = active;
    return this;
  };

  Popover.prototype.resetPosition = function() {
    var inputOffset, offsetLeft, offsetTop, wrapperOffset;
    inputOffset = this.target.offset();
    wrapperOffset = this.el.offsetParent().offset();
    offsetTop = inputOffset.top - wrapperOffset.top;
    offsetLeft = inputOffset.left - wrapperOffset.left;
    return this.el.css({
      top: offsetTop + this.target.outerHeight() + this.opts.offset,
      left: offsetLeft || 0
    });
  };

  Popover.prototype.destroy = function() {
    this.setActive(false);
    $(document).off(".qing-district-popover-" + this.id);
    return this.el.remove();
  };

  return Popover;

})(QingModule);

module.exports = Popover;

},{}],"qing-district":[function(require,module,exports){
var DataStore, FieldProxy, FieldProxyGroup, List, Popover, QingDistrict,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

DataStore = require("./data-store.coffee");

Popover = require("./popover.coffee");

FieldProxy = require("./field-proxy.coffee");

FieldProxyGroup = require("./field-proxy-group.coffee");

List = require("./list.coffee");

QingDistrict = (function(superClass) {
  extend(QingDistrict, superClass);

  function QingDistrict() {
    return QingDistrict.__super__.constructor.apply(this, arguments);
  }

  QingDistrict.name = "QingDistrict";

  QingDistrict.opts = {
    el: null,
    dataSource: null,
    renderer: null,
    popoverAppendTo: 'body',
    popoverOffset: 12
  };

  QingDistrict.locales = {
    placeholder: "Click to select"
  };

  QingDistrict.instanceCount = 0;

  QingDistrict.prototype._setOptions = function(opts) {
    QingDistrict.__super__._setOptions.apply(this, arguments);
    return $.extend(this.opts, QingDistrict.opts, opts);
  };

  QingDistrict.prototype._init = function(opts) {
    var initialized;
    QingDistrict.__super__._init.apply(this, arguments);
    this.el = $(this.opts.el);
    if (!(this.el.length > 0)) {
      throw new Error('QingDistrict: option el is required');
    }
    if (initialized = this.el.data("qingDistrict")) {
      return initialized;
    }
    if (!$.isFunction(this.opts.dataSource)) {
      throw new Error('QingDistrict: option dataSource is required');
    }
    this.locales = $.extend({}, QingDistrict.locales, this.opts.locales);
    this.id = ++QingDistrict.instanceCount;
    this._render();
    this.dataStore = new DataStore();
    this.dataStore.on("loaded", (function(_this) {
      return function(e, data) {
        _this._setup(data);
        _this._bind();
        _this._restore();
        if ($.isFunction(_this.opts.renderer)) {
          _this.opts.renderer.call(_this, _this.wrapper, _this);
        }
        return _this.trigger('ready');
      };
    })(this));
    return this.dataStore.load(this.opts.dataSource);
  };

  QingDistrict.prototype._render = function() {
    this.wrapper = $("<div class=\"qing-district-wrapper\"></div>").data('district', this).prependTo(this.el);
    return this.el.attr('tabindex', 0).addClass(' qing-district').data('qingDistrict', this);
  };

  QingDistrict.prototype._setup = function(data) {
    this.popover = new Popover({
      target: this.el,
      appendTo: this.opts.popoverAppendTo,
      offset: this.opts.popoverOffset
    });
    this.provinceList = new List({
      wrapper: this.popover.el,
      data: data.province,
      codes: "all"
    });
    this.cityList = new List({
      wrapper: this.popover.el,
      data: data.city
    });
    this.countyList = new List({
      wrapper: this.popover.el,
      data: data.county
    });
    this.fieldGroup = new FieldProxyGroup({
      wrapper: this.wrapper,
      placeholder: this.locales.placeholder
    });
    this.provinceField = new FieldProxy({
      group: this.fieldGroup,
      data: data.province,
      field: this.el.find("[data-province-field]")
    });
    this.cityField = new FieldProxy({
      group: this.fieldGroup,
      data: data.city,
      field: this.el.find("[data-city-field]")
    });
    return this.countyField = new FieldProxy({
      group: this.fieldGroup,
      data: data.county,
      field: this.el.find("[data-county-field]")
    });
  };

  QingDistrict.prototype._bind = function() {
    this.el.on("keydown", (function(_this) {
      return function(e) {
        if (!$(e.target).is(_this.el)) {
          return;
        }
        switch (e.which) {
          case 13:
          case 40:
            return _this.fieldGroup.el.trigger("click");
          case 27:
            return _this.popover.setActive(false);
        }
      };
    })(this));
    this.fieldGroup.el.on("click", (function(_this) {
      return function() {
        if (_this.popover.active) {
          return _this.popover.setActive(false);
        } else if (_this.fieldGroup.isEmpty()) {
          _this.cityList.hide();
          _this.countyList.hide();
          _this.provinceList.render();
          return _this.popover.setActive(true);
        } else {
          return _this.provinceField.setActive(true);
        }
      };
    })(this));
    this.popover.on("show", (function(_this) {
      return function() {
        _this.wrapper.addClass("active");
        return _this.el.addClass("active");
      };
    })(this)).on("hide", (function(_this) {
      return function() {
        _this.wrapper.removeClass("active");
        _this.el.removeClass("active");
        _this._hideAllExcpet("none");
        if (!_this._isFullFilled()) {
          _this.provinceList.setCurrent(null);
          _this.provinceField.clear();
          _this.cityField.clear();
          _this.countyField.clear();
          return _this.fieldGroup.setEmpty(true);
        }
      };
    })(this));
    this.provinceField.on("active", (function(_this) {
      return function(e, item) {
        _this._hideAllExcpet("province");
        if (item) {
          _this.provinceList.setCurrent(item).show();
        }
        return _this.popover.setActive(true);
      };
    })(this));
    this.provinceList.on("afterSelect", (function(_this) {
      return function(e, province) {
        var firstCity;
        _this.fieldGroup.setEmpty(false);
        _this.provinceField.setItem(province).highlight(false);
        firstCity = _this.cityList.data[province.cities[0]];
        if (_this._isMunicipality(province, firstCity)) {
          _this.cityList.setCurrent(firstCity).hide();
          _this.cityList.trigger("afterSelect", _this.cityList.current);
          return _this.cityField.setActive(false);
        } else {
          _this.cityList.setCodes(province.cities).render();
          _this.cityField.clear();
          return _this.countyField.clear();
        }
      };
    })(this));
    this.cityField.on("active", (function(_this) {
      return function(e, item) {
        _this._hideAllExcpet("city");
        if (item) {
          _this.cityList.setCurrent(item).show();
        }
        return _this.popover.setActive(true);
      };
    })(this)).on("restore", (function(_this) {
      return function() {
        return _this.cityList.setCodes(_this.provinceField.getItem().cities).render();
      };
    })(this));
    this.cityList.on("afterSelect", (function(_this) {
      return function(e, city) {
        _this.fieldGroup.setEmpty(false);
        _this.cityField.setItem(city).highlight(false);
        _this.countyList.setCodes(city.counties).render();
        return _this.countyField.clear();
      };
    })(this));
    this.countyField.on("active", (function(_this) {
      return function(e, item) {
        _this._hideAllExcpet("county");
        if (item) {
          _this.countyList.setCurrent(item).show();
        }
        return _this.popover.setActive(true);
      };
    })(this)).on("restore", (function(_this) {
      return function() {
        return _this.countyList.setCodes(_this.cityField.getItem().counties).render();
      };
    })(this));
    return this.countyList.on("afterSelect", (function(_this) {
      return function(e, county) {
        _this.fieldGroup.setEmpty(false);
        _this.countyField.setItem(county).highlight(false);
        return _this.popover.setActive(false);
      };
    })(this));
  };

  QingDistrict.prototype._restore = function() {
    this.provinceField.restore();
    this.cityField.restore();
    if (this._isMunicipality(this.provinceField.getItem(), this.cityField.getItem())) {
      this.cityField.setActive(false);
    }
    this.countyField.restore();
    if (this._isFullAny()) {
      return this.fieldGroup.setEmpty(false);
    }
  };

  QingDistrict.prototype._isMunicipality = function(province, city) {
    if (!(province && city)) {
      return false;
    }
    return province.cities.length === 1 && city.name === province.name;
  };

  QingDistrict.prototype._hideAllExcpet = function(type) {
    var _type, i, len, ref, results;
    ref = ["province", "city", "county"];
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      _type = ref[i];
      if (_type !== type) {
        this[_type + "List"].hide();
        results.push(this[_type + "Field"].highlight(false));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  QingDistrict.prototype._isFullFilled = function() {
    return this.provinceField.isFilled() && this.cityField.isFilled() && this.countyField.isFilled();
  };

  QingDistrict.prototype._isFullAny = function() {
    return this.provinceField.isFilled() || this.cityField.isFilled() || this.countyField.isFilled();
  };

  QingDistrict.prototype.destroy = function() {
    this.popover.destroy();
    this.wrapper.remove();
    return this.el.removeClass("qing-district").removeData('qingDistrict');
  };

  return QingDistrict;

})(QingModule);

module.exports = QingDistrict;

},{"./data-store.coffee":1,"./field-proxy-group.coffee":2,"./field-proxy.coffee":3,"./list.coffee":4,"./popover.coffee":5}]},{},[]);

return b('qing-district');
}));
