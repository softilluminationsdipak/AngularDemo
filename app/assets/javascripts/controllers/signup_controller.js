angular.module('demoAngular')
.controller('SignupController', function ($scope, $http, $location, UserService, config, FlashService){
  $scope.user = {};

  $scope.signup = function() {
  	UserService.Signup($scope.user, function(response){
  		if (response.success){        
  			$location.path('/login')
        FlashService.Success('Login successfully.');
  		}else{
  			FlashService.Error(response.errors);
  		}
  	})
    
  };

})
.directive('validPasswordC', function() {
  return {
    require: 'ngModel',
    link: function(scope, elm, attrs, ctrl) {
      ctrl.$parsers.unshift(function(viewValue, $scope) {
        var noMatch = viewValue != scope.registerForm.password.$viewValue;
        ctrl.$setValidity('noMatch', !noMatch);
      })
    }
  }
})