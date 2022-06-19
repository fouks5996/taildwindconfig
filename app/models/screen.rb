class Screen < ApplicationRecord
   belongs_to :project

   def put_into_json(screens, user, project)
      arr1 = []
      arr2 = []
      screens.each do |screen|
        name = screen.as_json.values[1]
        value = screen.as_json.values[2]
        arr1 << name
        arr2 << value
      end
      hash = Hash[arr1.zip(arr2)]
      File.truncate("./db/json/#{user.first_name}/project_#{project.id}/screen.json", 2)
      File.open("./db/json/#{user.first_name}/project_#{project.id}/screen.json","w") do |i|
        i.write(JSON.pretty_generate(hash))
      end
    end
end
