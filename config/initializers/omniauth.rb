require 'omniauth'
require 'omniauth-facebook'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '144611749001917', '963f0c2549862e8fa5850ad9d0ba6aaa',
           :scope => 'email, user_photos, friends_photos' 
           #:client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}
end