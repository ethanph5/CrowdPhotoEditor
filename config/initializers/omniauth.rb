require 'omniauth'
require 'omniauth-facebook'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '336797796381086', 'a43647f8d6ad499af512635ee6a6c7d3',
   #        :scope => 'email, user_photos, friends_photos, publish_stream' 
  #provider :facebook, '144611749001917', '963f0c2549862e8fa5850ad9d0ba6aaa',
           :scope => 'email, user_photos, friends_photos, publish_stream' 
           #:client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}
end