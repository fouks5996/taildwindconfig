class ProjectController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy ]
  before_action :authenticate_user!, only: [:new, :edit, :destroy, :update, :show, :index]

  # GET /projects or /projects.json
  def index
    @user_projects = User.find(current_user.id).projects
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
        flash[:success] = "well done"
        redirect_to "/project"
      else
        flash[:error] = "Réessayer"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
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
    @project.destroy

    respond_to do |format|
      format.html { redirect_to "/project", notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
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
end
