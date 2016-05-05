angular.module('demoAngular')
.controller('WelcomeController', function ($scope, $rootScope, UserService){
  $scope.name = "welcomeController2";

	$scope.isAuthenticated = UserService.isAuthenticated;
	
	$scope.$watch(function() {		
    return $rootScope.globals.currentUser;
  }, function(currentUser) {
    $scope.currentUser = currentUser
  });

});