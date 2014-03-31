var app = angular.module('app', [
      'ngResource'
    , 'app.resources.sku'
])

app.config(function($httpProvider) {
    $httpProvider.defaults.useXDomain = true
    delete $httpProvider.defaults.headers.common['X-Requested-With'];
    console.log($httpProvider.defaults.headers);
})

app.controller('SkuCtrl', ['$scope', 'Sku', function($scope, Sku) {
    $scope.skus = Sku.query()
    editSku = {}
    $scope.sku = editSku
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
            $scope.sku = editSku
            $scope.edit = true
        }
    }

    $scope.cancel = function() {
        if(!!$scope.sku.did) {
            $scope.select($scope.sku.did)
        } else {
            editSku = {}
            $scope.sku = editSku
        }
    }

    var f = new FileReader()
    f.onload = function(e) {
        $scope.sku.photo = e.target.result
        save($scope.sku)
    }

    $scope.save = function() {
        if(!encodeFile(document.getElementById("photo-upload"))) {
            save($scope.sku)
        }
    }

    function save(sku) {
        Sku.save({}, sku, function(success) {
            $scope.sku = success[0]
            $scope.skus = Sku.query()
            $scope.edit = false
        })
    }

    function encodeFile(el) {
        var file = el.files[0]
        if(file && file.type.match(/^image/)) {
            f.readAsDataURL(file)
            return true
        }
        return false
    }

}])
