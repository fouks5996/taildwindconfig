class Project < ApplicationRecord
   #relations
   belongs_to :user
   has_many :screens

   #validates
   validates :project_name, length: {minimum: 3, maximum:16}, presence: true
   validates :type_project, length: {minimum: 3, maximum:12}, presence: true

   
end
