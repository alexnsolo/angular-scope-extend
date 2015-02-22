# angular-scope-extend
An Angular service for organizing controller code.

## Installation
``` bower install angular-scope-extend --save```

or download at [https://github.com/civilframe/angular-scope-extend/releases](https://github.com/civilframe/angular-scope-extend/releases)

## Benefits

Organize your angular controller code in object notation, using 'this' to refer to $scope. Works best with CoffeeScript.

### Before

CoffeeScript:
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
JavaScript:
```javascript
angular.module('my-module').controller('MyCtrl', function($scope, myService) {

    $scope.myVariable = 5;

    $scope.myFunction = function() {
        return myService.doStuff($scope.myVariable);
    };

    $scope.myOtherFunction = function() {
        return console.log('reticulating spleens');
    };

    $scope.$watch('myVariable', function(newValue, oldValue) {
        return $scope.myFunction();
    });

    $scope.$on('SOME_EVENT', function(event) {
        $scope.myOtherFunction();
        return $scope.myVariable++;
    });

    // Initialization
    $scope.myFunction();
    console.log('Phew. Much $scope everywhere.');
});
```

### After

CoffeeScript:
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
        'SOME_EVENT': (event) ->
            @myOtherFunction()
            @myVariable++
        
    initialize: ->
        @myFunction()
        console.log('Ahh, much better!')
```
JavaScript:
```javascript
angular.module('my-module').controller('MyCtrl', function($scope, scopeExtend, myService) {
    scopeExtend($scope, {

        variables: {
            myVariable: 5
        },

        methods: {
            myFunction: function() {
                return myService.doStuff(this.myVariable);
            },
            myOtherFunction: function() {
                return console.log('reticulating spleens');
            }
        },

        watch: {
            'myVariable': function(newValue, oldValue) {
                return this.myFunction();
            }
        },

        listen: {
            'SOME_EVENT': function(event) {
                this.myOtherFunction();
                return this.myVariable++;
            }
        },

        initialize: function() {
            this.myFunction();
            return console.log('Ahh, much better!ere.');
        }
        
    });
});
```
