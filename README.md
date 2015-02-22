# angular-scope-extend
An Angular service for organizing controller code.

## Installation
``` bower install angular-scope-extend --save```

or download at [https://github.com/civilframe/angular-scope-extend/releases](https://github.com/civilframe/angular-scope-extend/releases)

## Benefits

Organize your angular controller code in object notation, using 'this' to refer to $scope. Works best with CoffeeScript.

### Before

```coffeescript
angular.module('my-module').controller 'MyCtrl', ($scope, myService) ->
    
    $scope.myVariable = 5
    
    $scope.myFunction = ->
        myService.doStuff($scope.myVariable)
        
    $scope.myOtherFunction = ->
        console.log('reticulating spleens')
        
    $scope.$watch 'myVariable', (newValue, oldValue) ->
        $scope.myFunction()
        
    $scope.$on 'SOME_EVENT', (event) ->
        $scope.myOtherFunction()
        $scope.myVariable++
    
    # Initialization
    $scope.myFunction()
    console.log('Phew. Much $scope everywhere.')
```

### After

```coffeescript
angular.module('my-module').controller 'MyCtrl', ($scope, scopeExtend, myService) -> scopeExtend $scope,
    
    variables:
        myVariable: 5

    methods: 
        myFunction: ->
            myService.doStuff(@myVariable)
            
        myOtherFunction: ->
            console.log('reticulating spleens')
        
    watch:
        'myVariable': (newValue, oldValue) ->
            @myFunction()
        
    listen:
        'SOME_EVENT', (event) ->
            @myOtherFunction()
            @myVariable++
        
    initialize: ->
        @myFunction()
        console.log('Ahh, much better!')
```
