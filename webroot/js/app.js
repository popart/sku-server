var app = angular.module('app', [
      'ngResource'
    , 'app.resources.sku'
])
//var app = angular.module('app', [])

app.controller('SkuCtrl', ['$scope', 'Sku', function($scope, Sku) {
    $scope.skus = Sku.query()
}])
