'use strict';

var Caml_option = require("rescript/lib/js/caml_option.js");

function NavigationHelpersCommon(M) {
  var navigateByKey = function (key, params, param) {
    var tmp = {
      key: key
    };
    if (params !== undefined) {
      tmp.params = Caml_option.valFromOption(params);
    }
    tmp.navigate();
    
  };
  var navigateByName = function (name, key, params, param) {
    var tmp = {
      name: name
    };
    if (key !== undefined) {
      tmp.key = key;
    }
    if (params !== undefined) {
      tmp.params = Caml_option.valFromOption(params);
    }
    tmp.navigate();
    
  };
  return {
          navigateByKey: navigateByKey,
          navigateByName: navigateByName
        };
}

function EventConsumer(M) {
  return {};
}

function NavigationScreenProp(M) {
  var navigateByKey = function (key, params, param) {
    var tmp = {
      key: key
    };
    if (params !== undefined) {
      tmp.params = Caml_option.valFromOption(params);
    }
    tmp.navigate();
    
  };
  var navigateByName = function (name, key, params, param) {
    var tmp = {
      name: name
    };
    if (key !== undefined) {
      tmp.key = key;
    }
    if (params !== undefined) {
      tmp.params = Caml_option.valFromOption(params);
    }
    tmp.navigate();
    
  };
  return {
          navigateByKey: navigateByKey,
          navigateByName: navigateByName
        };
}

exports.NavigationHelpersCommon = NavigationHelpersCommon;
exports.EventConsumer = EventConsumer;
exports.NavigationScreenProp = NavigationScreenProp;
/* No side effect */
