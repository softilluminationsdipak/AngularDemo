angular.module('demoAngular')
.controller('AboutController', function ($scope, $rootScope, UserService, $location){  
  if( $rootScope.isAuthenticated ){
  	$scope.name = "About Content";
  }else{
  	$location.path('/login')
  }
  
});