class StaticPageController < ApplicationController
   def index
      @project_length = User.find(current_user.id).projects.length
   end
end
