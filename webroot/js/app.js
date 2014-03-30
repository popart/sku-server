var app = angular.module('app', [
      'ngResource'
    , 'app.resources.sku'
])
//var app = angular.module('app', [])

app.controller('SkuCtrl', ['$scope', 'Sku', function($scope, Sku) {
    $scope.skus = Sku.query()
    Sku.query(
        {'did': 1}, 
        function(response){
            $scope.sku_uno=response[0]
            console.log(response[0])
        }
    )
}])
