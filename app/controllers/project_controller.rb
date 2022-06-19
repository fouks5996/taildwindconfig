class ProjectController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy ]
  before_action :authenticate_user!, only: [:new, :edit, :destroy, :update, :show, :index]
  require 'bundler'
  Bundler.require

  # GET /projects or /projects.json
  def index
    @user_projects = User.find(current_user.id).projects
    @project_length = User.find(current_user.id).projects.length
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(
      project_name: params[:project_name], 
      type_project: params[:type_project], 
      exported: params[:exported], 
      user: current_user
    )
      if @project.save
        flash[:success] = "Project created"
        redirect_to "/project"
        create_json_directory
        create_screen_file
      else
        render 'project/new'
      end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @screens = @project.screens
    @screens.destroy_all
    @project.destroy
    
    delete_json
    flash[:error] = "Project destroyed"
    redirect_to '/project'
  end

  private
    # je défini le PROJECT ID
    def set_project
      @project = Project.find(params[:id])
    end

    # je défini les params du projet
    def project_params
      params.fetch(:project, {})
    end


    # CHECK IF DIRECTORIES EXISTS
    def current_user_file_exist?
      if File.exists?("./db/json/#{@current_user.first_name}")
        return true 
      else 
        return false
      end
    end

    def project_file_exist?
      if File.exists?("./db/json/#{@current_user.first_name}/project_#{@project.id}")
        return true 
      else 
        return false
      end
    end

    # CREATE USER, PROJECT AND JSON DIRECTORIES (called in create method)
    def create_json_directory
      if current_user_file_exist? == true && project_file_exist? == true
      elsif current_user_file_exist? == true && project_file_exist? == false 
        Dir.mkdir("./db/json/#{@current_user.first_name}/project_#{@project.id}")
      elsif current_user_file_exist? == false && project_file_exist? == true 
        Dir.mkdir("./db/json/#{@current_user.first_name}")
      else 
        Dir.mkdir("./db/json/#{@current_user.first_name}")
        Dir.mkdir("./db/json/#{@current_user.first_name}/project_#{@project.id}")
      end 
    end

    # CREATE JSON SCREEN FILE (called in create method)
    def create_screen_file
      Screen.create(name: "small", value: 375, project: @project)
      Screen.create(name: "medium", value: 850, project: @project)
      Screen.create(name: "large", value: 1440, project: @project)

      File.new("./db/json/#{@current_user.first_name}/project_#{@project.id}/screen.json", "w")
      File.write("./db/json/#{@current_user.first_name}/project_#{@project.id}/screen.json", '{
        "small": "375",
        "medium": "850",
        "large": "1440"
      }')
    end


    # DELETE PROJECT WITH CONTENT (called in destroy method)
    def delete_json
      FileUtils.rm_rf("./db/json/#{@current_user.first_name}/project_#{@project.id}")
    end
end
