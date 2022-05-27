class ScreensController < ApplicationController
  before_action :set_screen, only: %i[ show edit update destroy ]
  before_action :set_project_screens, only: %i[ index update ]
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
      File.truncate("./db/data.json", 0)
      File.open("./db/data.json","w") do |i|
        i.write(JSON.pretty_generate(hash))
      end
    end

    def json_read 
      jsy = JSON.parse(File.read("./db/data.json"))
      JSON.pretty_generate(jsy)
    end


    # Only allow a list of trusted parameters through.
    def screen_params
      params.fetch(:screen, {})
    end
end
