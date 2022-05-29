class ProjectController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy ]
  before_action :authenticate_user!, only: [:new, :edit, :destroy, :update, :show, :index]

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
        create_screen
        create_json
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
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.fetch(:project, {})
    end

    # create screen after create project
    def create_screen
      Screen.create(name: "XS", value: 300, project: @project)
      Screen.create(name: "S", value: 750, project: @project)
      Screen.create(name: "M", value: 1200, project: @project)
      Screen.create(name: "L", value: 1500, project: @project)
      Screen.create(name: "XL", value: 1850, project: @project)
    end

    # create json after create project
    def create_json
      File.new("./db/json/project_#{@project.id}_data.json", "w")
      File.write("./db/json/project_#{@project.id}_data.json", '{
        "XS": "300",
        "S": "750",
        "M": "1200",
        "L": "1500",
        "XL": "1850"
      }')

    end

    # delete json after delete project
    def delete_json
      File.delete("./db/json/project_#{@project.id}_data.json")
    end
end
