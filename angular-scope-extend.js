(function() {
  'format global';
  'deps angular';
  var hasProp = {}.hasOwnProperty;

  (function() {
    var _isArray, _isFunction, _isObject, _warning, angularScopeExtend;
    _isObject = function(obj) {
      return typeof obj === 'object';
    };
    _isFunction = function(obj) {
      return typeof obj === 'function';
    };
    _isArray = function(obj) {
      return toString.call(obj) === '[object Array]';
    };
    _warning = function(msg) {
      return console.warn('scopeExtend - ' + msg);
    };
    angularScopeExtend = function(angular) {
      var module;
      module = angular.module('angular-scope-extend', []);
      module.factory('scopeExtend', function() {
        return function(scope, members) {
          var _setupListen, _setupWatch, listenCallback, listenName, listens, methodBody, methodName, ref, ref1, ref2, ref3, variableName, variableValue, watchName, watchParams, watches;
          if (!_isObject(scope)) {
            _warning('Scope parameter is not an object, exiting early.');
            return;
          }
          if (!_isObject(members)) {
            _warning('Members parameter is not an object, exiting early.');
            return;
          }
          listens = [];
          watches = [];
          _setupWatch = function(name, params) {
            var callback, depth, deregister, expression;
            if (!(_isFunction(params) || _isObject(params))) {
              _warning('Watch parameter must be a function or object, skipping.');
              return;
            }
            if (_isFunction(params)) {
              expression = name;
              callback = params;
              depth = 'shallow';
            }
            if (_isObject(params)) {
              if (params.expressionGroup) {
                if (!_isArray(params.expressionGroup)) {
                  _warning('Watch parameter expressionGroup must be an array, skipping.');
                  return;
                }
                expression = params.expressionGroup;
                depth = 'group';
              } else {
                expression = params.expression || name;
                depth = params.depth || 'shallow';
              }
              callback = params.callback;
            }
            deregister = (function() {
              switch (depth) {
                case 'shallow':
                  return scope.$watch(expression, function() {
                    return callback.apply(scope, arguments);
                  });
                case 'deep':
                  return scope.$watch(expression, (function() {
                    return callback.apply(scope, arguments);
                  }), true);
                case 'collection':
                  return scope.$watchCollection(expression, function() {
                    return callback.apply(scope, arguments);
                  });
                case 'group':
                  return scope.$watchGroup(expression, function() {
                    return callback.apply(scope, arguments);
                  });
              }
            })();
            return watches.push({
              key: name,
              callback: deregister
            });
          };
          _setupListen = function(name, callback) {
            var deregister;
            deregister = scope.$on(name, function() {
              return callback.apply(scope, arguments);
            });
            return listens.push({
              key: name,
              callback: deregister
            });
          };
          if (members.variables) {
            ref = members.variables;
            for (variableName in ref) {
              if (!hasProp.call(ref, variableName)) continue;
              variableValue = ref[variableName];
              scope[variableName] = variableValue;
            }
          }
          if (members.methods) {
            ref1 = members.methods;
            for (methodName in ref1) {
              if (!hasProp.call(ref1, methodName)) continue;
              methodBody = ref1[methodName];
              scope[methodName] = methodBody;
            }
          }
          if (members.watch) {
            ref2 = members.watch;
            for (watchName in ref2) {
              if (!hasProp.call(ref2, watchName)) continue;
              watchParams = ref2[watchName];
              _setupWatch(watchName, watchParams);
            }
          }
          if (members.listen) {
            ref3 = members.listen;
            for (listenName in ref3) {
              if (!hasProp.call(ref3, listenName)) continue;
              listenCallback = ref3[listenName];
              _setupListen(listenName, listenCallback);
            }
          }
          scope._forgetWatch = function(watchName) {
            var i, index, j, len, len1, remove, results, watch, watchesToRemove;
            watchesToRemove = [];
            for (i = 0, len = watches.length; i < len; i++) {
              watch = watches[i];
              if (watch.key !== watchName) {
                continue;
              }
              watch.callback();
              watchesToRemove.push(watch);
            }
            results = [];
            for (j = 0, len1 = watchesToRemove.length; j < len1; j++) {
              remove = watchesToRemove[j];
              index = watches.indexOf(remove);
              results.push(watches.splice(index, 1));
            }
            return results;
          };
          scope._forgetListen = function(listenName) {
            var i, index, j, len, len1, listen, listensToRemove, remove, results;
            listensToRemove = [];
            for (i = 0, len = listens.length; i < len; i++) {
              listen = listens[i];
              if (listen.key !== listenName) {
                continue;
              }
              listen.callback();
              listensToRemove.push(listen);
            }
            results = [];
            for (j = 0, len1 = listensToRemove.length; j < len1; j++) {
              remove = listensToRemove[j];
              index = listens.indexOf(remove);
              results.push(listens.splice(index, 1));
            }
            return results;
          };
          if (members.initialize) {
            return members.initialize.apply(scope);
          }
        };
      });
      return module;
    };
    if (typeof define === 'function' && define.amd) {
      return define('angular-scope-extend', ['angular'], angularScopeExtend);
    } else {
      return angularScopeExtend(window.angular);
    }
  })();

}).call(this);
