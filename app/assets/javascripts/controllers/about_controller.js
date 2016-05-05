angular.module('demoAngular')
.controller('AboutController', function ($scope, $rootScope, UserService, $location){
  
  console.log('-----1-----------'+$rootScope.isAuthenticated)
  console.log('-----2-----------'+UserService.isAuthenticated())
  if( $rootScope.isAuthenticated ){
  	$scope.name = "About Content";
  }else{
  	$location.path('/login')
  }
  

});