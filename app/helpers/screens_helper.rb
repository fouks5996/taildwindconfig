module ScreensHelper

   def json_read(to_read)
      file_to_parse = File.read("./db/json/#{@user.first_name}/project_#{@project.id}/#{to_read}.json")
      jsy = JSON.parse(file_to_parse)
      JSON.pretty_generate(jsy)
    end
end
