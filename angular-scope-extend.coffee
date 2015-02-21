angular.module('angular-scope-extend', [])

angular.module('angular-scope-extend').factory 'scopeExtend', ->

    # Internal functions
    _isObject = (obj) ->
        return typeof obj is 'object'

    _isFunction = (obj) ->
        return typeof obj is 'function'

    _isArray = (obj) ->
        return toString.call(obj) is '[object Array]'

    _warning = (msg) ->
        console.warn 'scopeExtend - ' + msg


    # The scopeExtend factory proper, which is a function
    return (scope, members) ->

        # Perform sanity checks
        unless _isObject(scope)
            _warning 'Scope parameter is not an object, exiting early.'
            return

        unless _isObject(members)
            _warning 'Members parameter is not an object, exiting early.'
            return


        # Setup internal members
        listens = []
        watches = []

        _setupWatch = (name, params) ->
            unless _isFunction(params) or _isObject(params)
                _warning 'Watch parameter must be a function or object, skipping.'
                return

            if _isFunction(params)
                expression = name
                callback = params
                depth = 'shallow'

            if _isObject(params)
                if params.expressionGroup
                    unless _isArray(params.expressionGroup)
                        _warning 'Watch parameter expressionGroup must be an array, skipping.'
                        return

                    expression = params.expressionGroup
                    depth = 'group'

                else
                    expression = params.expression || name
                    depth = params.depth || 'shallow'
                
                callback = params.callback

            deregister = switch depth
                when 'shallow' then scope.$watch(expression, -> callback.apply(scope, arguments))
                when 'deep' then scope.$watch(expression, (-> callback.apply(scope, arguments)), true)
                when 'collection' then scope.$watchCollection(expression, -> callback.apply(scope, arguments))
                when 'group' then scope.$watchGroup(expression, -> callback.apply(scope, arguments))

            watches.push
                key: name
                callback: deregister

        _setupListen = (name, callback) ->
            deregister = scope.$on(name, -> callback.apply(scope, arguments))
            listens.push
                key: name
                callback: deregister


        # Extend the scope with members
        if members.variables
            for own variableName, variableValue of members.variables
                scope[variableName] = variableValue 
        
        # Extend the scope with methods
        if members.methods
            for own methodName, methodBody of members.methods
                scope[methodName] = methodBody 

        # Register watch listeners
        if members.watch
            for own watchName, watchParams of members.watch
                _setupWatch(watchName, watchParams)

        # Register event listeners
        if members.listen
            for own listenName, listenCallback of members.listen
                _setupListen(listenName, listenCallback)


        # Extend the scope with _forgetWatch, for deregistering watches
        scope._forgetWatch = (watchName) ->
            watchesToRemove = []
            for watch in watches
                continue unless watch.key is watchName
                watch.callback()
                watchesToRemove.push(watch)
            for remove in watchesToRemove
                index = watches.indexOf(remove)
                watches.splice(index, 1)

        # Extend the scope with _forgetListen, for deregistering listeners
        scope._forgetListen = (listenName) ->
            listensToRemove = []
            for listen in listens
                continue unless listen.key is listenName
                listen.callback()
                listensToRemove.push(listen)
            for remove in listensToRemove
                index = listens.indexOf(remove)
                listens.splice(index, 1)


        # Call the initialize methods
        if members.initialize
            members.initialize.apply(scope)

