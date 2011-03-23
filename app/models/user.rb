class User < ActiveRecord::Base
  attr_protected :admin
  acts_as_authentic do |config|
    config.crypted_password_field = :crypted_password
    config.require_password_confirmation = true
  end
end
