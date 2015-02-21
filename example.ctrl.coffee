angular.module('example-module').controller 'ExampleCtrl', ($scope, scopeExtend) ->
    
    scopeExtend $scope,
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
            'SOME_EVENT': (event, coolArg) -> 
                console.log 'SOME_EVENT received', coolArg

            'SOME_OTHER_EVENT': (event, coolArg) -> 
                console.log 'SOME_OTHER_EVENT received', coolArg

        watch:
            'test': (newValue) -> 
                console.log 'test changed to', newValue

            'testDeep': 
                expression: 'test2'
                depth: 'deep'
                callback: (newValue) ->
                    console.log 'test2 deeply changed to', newValue

            'testCollection': 
                expression: 'test3'
                depth: 'collection'
                callback: (newValue) ->
                    console.log 'test3 collection changed to', newValue

            'testGroup':
                expressionGroup: ['test1', 'test2']
                callback: (newValues) ->
                    console.log 'test1 and test2 changed to', newValues

        initialize: ->
            @test1 = 2
            @test2.value = 5
            @test3.push(4)
