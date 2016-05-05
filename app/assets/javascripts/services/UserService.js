'use strict';
  angular.module('demoAngular')
    .factory('UserService', function ($rootScope, $http, $location, config, $cookieStore) {
      var service   			= {};
      service.Login       = Login;
      service.Logout      = Logout;
      service.Signup 			= Signup;
      service.SetCredentials    = SetCredentials;
      service.ClearCredentials  = ClearCredentials;
      service.isAuthenticated   = isAuthenticated;
      
      return service;

      // Registration 
      function Signup(user, callback){
        $http.post(config + '/registrations', {user})
        .success(function(response){
          callback(response);
        })
        .error(function(response){
          callback(response);
        });
      }

      // Authentication
      function Login(username, password, callback) {
        $http.post(config + '/sessions', { login: username, password: password })
        .success(function (response) {
          callback(response);
        })
        .error(function (response){
          callback(response);
        });
      };

      // Set Credentail
      function SetCredentials(access_token) {
        $http.get(config+"/current_user?access_token="+access_token)
        .success(function(response) {
          $rootScope.globals.currentUser = response;          
          $http.defaults.headers.common['Authorization'] = 'Basic ' + access_token; 
          $cookieStore.put('globals',$rootScope.globals);
          $cookieStore.put('isAuthenticated', true);
        });
      }

      // Logout
      function Logout(access_token, callback){
        $http.delete(config + '/logout/' + access_token)
        .success(function(response){
          ClearCredentials()
          callback(response)
        }).error(function(response){          

        });
      };
      
      // Clear Credential
      function ClearCredentials() {
        $rootScope.globals = {};
        $cookieStore.remove('globals');
        $cookieStore.remove('isAuthenticated');
        $http.defaults.headers.common.Authorization = 'Basic';
      }

      // boolean method for is authenticated or not
      function isAuthenticated() {
        return !!$rootScope.globals.currentUser
      }

    // Exit
 		})
