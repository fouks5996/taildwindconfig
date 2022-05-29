class ScreensController < ApplicationController
  before_action :set_screen, only: %i[ show edit update destroy ]
  before_action :set_project_screens, only: %i[ index update ]
  before_action :set_project_id
  require 'bundler'
  Bundler.require

  

  def index
    @project = Project.find(params[:project_id])
    @project_length = User.find(current_user.id).projects.length
    @json_read = json_read
    @put_into_json = put_into_json
  end

  def show
  end

  def new
    @screen = Screen.new
  end

  def edit
  end

  def create
    @screen = Screen.new(screen_params)

    respond_to do |format|
      if @screen.save
        format.html { redirect_to screen_path(@screen), notice: "Screen was successfully created." }
        format.json { render :show, status: :created, location: @screen }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @screen.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
      if @screen.update(
        name: params[:name], 
        value: params[:value], 
      )
      # Update data.json at each screen update
      put_into_json

      # redirect after screen update
      redirect_to project_screens_path
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @screen.errors, status: :unprocessable_entity }
      end
  end


  def destroy
    @screen.destroy

    respond_to do |format|
      format.html { redirect_to screens_url, notice: "Screen was successfully destroyed." }
      format.json { head :no_content }
    end
  end



  private
    def set_screen
      @screen = Screen.find(params[:id])
    end

    def set_project_screens
      @screens = Project.find(params[:project_id]).screens.reorder('id ASC')
    end

    def set_project_id
      @project_id = Project.find(params[:project_id]).id
    end

    def put_into_json
      arr1 = []
      arr2 = []
      @screens.each do |screen|
        name = screen.as_json.values[1]
        value = screen.as_json.values[2]
        arr1 << name
        arr2 << value
      end
      hash = Hash[arr1.zip(arr2)]
      File.truncate("./db/json/project_#{@project_id}_data.json", 2)
      File.open("./db/json/project_#{@project_id}_data.json","w") do |i|
        i.write(JSON.pretty_generate(hash))
      end
    end

    def json_read 
      file_to_parse = File.read("./db/json/project_#{@project_id}_data.json")
      jsy = JSON.parse(file_to_parse)
      JSON.pretty_generate(jsy)
    end


    # Only allow a list of trusted parameters through.
    def screen_params
      params.fetch(:screen, {})
    end
end
