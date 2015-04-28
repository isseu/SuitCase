class CaseUsersController < ApplicationController
  before_action :set_case_user, only: [:show, :edit, :update, :destroy]

  # GET /case_users
  # GET /case_users.json
  def index
    @case_users = CaseUser.all
  end

  # GET /case_users/1
  # GET /case_users/1.json
  def show
  end

  # GET /case_users/new
  def new
    @case_user = CaseUser.new
  end

  # GET /case_users/1/edit
  def edit
  end

  # POST /case_users
  # POST /case_users.json
  def create
    @case_user = CaseUser.new(case_user_params)

    respond_to do |format|
      if @case_user.save
        format.html { redirect_to @case_user, notice: 'Case user was successfully created.' }
        format.json { render :show, status: :created, location: @case_user }
      else
        format.html { render :new }
        format.json { render json: @case_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /case_users/1
  # PATCH/PUT /case_users/1.json
  def update
    respond_to do |format|
      if @case_user.update(case_user_params)
        format.html { redirect_to @case_user, notice: 'Case user was successfully updated.' }
        format.json { render :show, status: :ok, location: @case_user }
      else
        format.html { render :edit }
        format.json { render json: @case_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /case_users/1
  # DELETE /case_users/1.json
  def destroy
    @case_user.destroy
    respond_to do |format|
      format.html { redirect_to case_users_url, notice: 'Case user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_case_user
      @case_user = CaseUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def case_user_params
      params.require(:case_user).permit(:case_id, :user_id)
    end
end
