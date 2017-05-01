module Protectable
  extend ActiveSupport::Concern

  included do
  	#this method return an array of all roles the logged in user have against a Thing or an Image where this Protectable is included
    def user_roles
      @user_roles ||= []
    end
  end
end
