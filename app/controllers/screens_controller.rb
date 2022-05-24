class ScreensController < ApplicationController
  before_action :set_screen, only: %i[ show edit update destroy ]
  require 'bundler'
  Bundler.require


  # GET /screens or /screens.json
  def index
    @screens = Project.find(params[:project_id]).screens
    @project = Project.find(params[:project_id])
    @project_length = User.find(current_user.id).projects.length
  end

  # GET /screens/1 or /screens/1.json
  def show
  end

  # GET /screens/new
  def new
    @screen = Screen.new
  end

  # GET /screens/1/edit
  def edit
  end

  # POST /screens or /screens.json
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

  # PATCH/PUT /screens/1 or /screens/1.json
  def update

      if @screen.update(
        name: params[:name], 
        value: params[:value], 
      )

      put_into_json

      redirect_to project_screens_path
        #format.html { redirect_to screen_url(@screen), notice: "Screen was successfully updated." }
        #format.json { render :show, status: :ok, location: @screen }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @screen.errors, status: :unprocessable_entity }
      end
  end

  # DELETE /screens/1 or /screens/1.json
  def destroy
    @screen.destroy

    respond_to do |format|
      format.html { redirect_to screens_url, notice: "Screen was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_screen
      @screen = Screen.find(params[:id])
    end

    def put_into_json
      @screens = Project.find(params[:project_id]).screens
      @screen_array = []
      @screen_array << @screens 
      File.open("./db/data.json","w") do |i|
        i.write(JSON.pretty_generate(@screen_array))
      end
    end

    # Only allow a list of trusted parameters through.
    def screen_params
      params.fetch(:screen, {})
    end
end
