class ScreensController < ApplicationController
  before_action :set_screen, only: %i[ show edit update destroy ]
  before_action :set_project_screens, only: %i[ index update ]
  require 'bundler'
  Bundler.require

  def index
    @project = Project.find(params[:project_id])
    @project_length = User.find(current_user.id).projects.length
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
      download_file
      
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

    def download_file
      open("http://localhost:3000/data.json") do |in_io|
          File.open("./db/data.json", 'w') do |out_io|
            out_io.print in_io.read
          end
        end
    end


    # Only allow a list of trusted parameters through.
    def screen_params
      params.fetch(:screen, {})
    end
end
