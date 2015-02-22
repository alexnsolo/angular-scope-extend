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
                myService.doStuff(this.myVariable);
            },
            myOtherFunction: function() {
                console.log('reticulating spleens');
            }
        },

        watch: {
            'myVariable': function(newValue, oldValue) {
                this.myFunction();
            }
        },

        listen: {
            'SOME_EVENT': function(event) {
                this.myOtherFunction();
                this.myVariable++;
            }
        },

        initialize: function() {
            this.myFunction();
            console.log('Ahh, much better!');
        }
        
    });
});
```

## Advanced Usage
```coffeescript
angular.module('example-module').controller 'ExampleCtrl', ($scope, scopeExtend) -> scopeExtend $scope,
    variables:
        'test': 1
        'test2': {value: 2}
        'test3': [1,2,3]

    methods:
        'readTest': -> 
            console.log 'test is', @test

        'readTest2': -> 
            console.log 'test2 is', @test2

    listen:
        # The name of the event corresponds to the key, in this case 'SOME_EVENT'
        'SOME_EVENT': (event, coolArg) ->
            console.log 'SOME_EVENT received', coolArg

        'SOME_OTHER_EVENT': (event) -> 
            console.log 'SOME_OTHER_EVENT received'

    watch:
        # For simple watches, the watch expression corresponds to the key
        'test': (newValue) -> 
            console.log 'test changed to', newValue

        # For more complex watches, the key is arbitrary
        'testDeep': 
            expression: 'test2' # and the expression is specified here
            depth: 'deep' # as well as the watch depth
            callback: (newValue) -> # and lastly the callback
                console.log 'test2 deeply changed to', newValue

        # You can also watch collections by specifying depth as 'collection'
        'testCollection': 
            expression: 'test3'
            depth: 'collection'
            callback: (newValue) ->
                console.log 'test3 collection changed to', newValue

        # You can also watch groups by specifying an array of expressions for expressionGroup
        'testGroup':
            expressionGroup: ['test1', 'test2']
            callback: (newValues) ->
                console.log 'test1 and test2 changed to', newValues

    initialize: ->
        @test1 = 2
        @test2.value = 5
        @test3.push(4)

        @$emit('SOME_EVENT')
        @_forgetListen('SOME_EVENT') # The built-in _forgetListen function removes the listener for the specified key
        @$emit('SOME_EVENT') # so this shouldn't be received

        @_forgetWatch('testCollection') # You can also forget watches by specifying the key
```
