(function(angular) {
  'use strict';
	angular.module('demoAngular', [])
  .controller('WelcomeController',['$scope', '$route', '$routeParams', '$location', function($scope, $route, $routeParams, $location) {
    $scope.name = "welcomeController";
  }])	
});