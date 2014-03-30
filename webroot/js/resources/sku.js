'use strict';

angular.module( 'app.resources.sku', [ 'ngResource' ])

.factory( 'Sku', [ '$resource', function( $resource ) {
  var Sku = $resource( 'http://localhost:3000/sku/:did', { did: '@did' }, {
    query:  { method:  'GET', isArray: true }, 
    putSku:  { method: 'PUT', isArray: false },
  });

  return Sku;
}]);
