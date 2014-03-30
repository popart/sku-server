var app = angular.module('app', [
      'ngResource'
    , 'app.resources.sku'
])
//var app = angular.module('app', [])

app.controller('SkuCtrl', ['$scope', 'Sku', function($scope, Sku) {
    $scope.skus = Sku.query()
    $scope.select = function(did) {
        //$scope.selected = did
        Sku.query(
            {'did': did}, 
            function(response){
                $scope.selected=response[0]
                console.log(response[0])
            }
        )
    }
}])
