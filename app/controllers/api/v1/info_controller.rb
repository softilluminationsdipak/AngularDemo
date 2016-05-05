class Api::V1::InfoController < ApplicationController

    #PUBLIC API
    #before_filter :authenticate_user!

    def index

      render :status => 200,
              :json => { :success => true,
                        :info => "Test Info",
                        :data => { :author => 'Dipak Panchal',
                                :angular_js => 'Yuppi, It working!',
                                :credits => [
                                    { name: 'Michael J.', msg:'Thank You.'}
                                ]
                        }
              }
    end
end
