var app = angular.module('app', [
      'ngResource'
    , 'app.resources.sku'
])

app.controller('SkuCtrl', ['$scope', 'Sku', function($scope, Sku) {
    $scope.skus = Sku.query()
    $scope.sku = {}
    $scope.edit = true

    $scope.select = function(did) {
        if(did) {
            Sku.query({'did': did}, 
                function(response){
                    $scope.sku=response[0]
                    $scope.edit=false
                }
            )
        } else {
            $scope.sku = {}
            $scope.edit = true
        }
    }

    $scope.cancel = function() {
        $scope.select($scope.sku.did)
    }
    $scope.save = function() {
        console.log($scope.sku)
    }
}])
