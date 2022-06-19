class ScreensController < ApplicationController
  before_action :set_screen, only: %i[ show edit update destroy ]
  before_action :set_project_screens, only: %i[ index update create destroy]
  before_action :set_project
  before_action :set_user
  require 'bundler'
  Bundler.require

  def index
    @project = Project.find(params[:project_id])
    @project_length = @user.projects.length
    @json_read = json_read("screen")
  end

  def show
  end

  def new
    @screen = Screen.new
  end

  def edit
  end

  def create
    @screen = Screen.create(
      name: params[:name], 
      value: params[:value], 
      project: @project
    )
    respond_to do |format|
      if @screen.save
        @screen.put_into_json(@screens, @user, @project)
        format.html { redirect_to project_screens_path(@project)}
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end


  def update
      if @screen.update(
        name: params[:name], 
        value: params[:value], 
      )
      @screen.put_into_json(@screens, @user, @project)

      redirect_to project_screens_path
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @screen.errors, status: :unprocessable_entity }
      end
  end


  def destroy
    @screen.destroy
    @screen.put_into_json(@screens, @user, @project)

    respond_to do |format|
      format.html { redirect_to project_screens_path(@project) }
      format.json { head :no_content }
    end
  end



  private
    def set_screen
      @screen = Screen.find(params[:id])
    end

    def set_project_screens
      @screens = Project.find(params[:project_id]).screens

    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_user
      @user = User.find(current_user.id)
    end

    def screen_params
      params.fetch(:screen, {})
    end

    def json_read(to_read)
      file_to_parse = File.read("./db/json/#{@user.first_name}/project_#{@project.id}/#{to_read}.json")
      jsy = JSON.parse(file_to_parse)
      JSON.pretty_generate(jsy)
    end
end
