class CasesController < ApplicationController
  before_action :set_case, only: [:show, :edit, :update, :destroy]

  # GET /cases
  # GET /cases.json
  def index
    @cases = nil
    respond_to do |format|
      format.html { @cases = current_user.cases }
      format.json { @cases = Case.all }
    end
    @cases = @cases.includes(:case_records, :case_users)
    if not params[:queries].nil? and not params[:queries][:search].nil?
      #TODO consulta de busqueda
      @cases = @cases.where('rol LIKE :search', search: '%' + params[:queries][:search] + '%')
    end
    if not params[:page].blank? and not params[:per_page].blank?
      @cases = @cases.paginate(:page => params[:page].to_i, :per_page => params[:per_page].to_i)
    end
    if not params[:order].blank?
      @cases = @cases.order(params[:order])
    end
    @cases = @cases.all
  end

  # GET /cases/1
  # GET /cases/1.json
  def show
  end

  # GET /cases/new
  def new
    @case = Case.new
  end

  # GET /cases/1/edit
  def edit
  end

  # POST /cases
  # POST /cases.json
  def create
    @case = Case.new(case_params)

    respond_to do |format|
      if @case.save
        format.html { redirect_to @case, notice: 'Case was successfully created.' }
        format.json { render :show, status: :created, location: @case }
      else
        format.html { render :new }
        format.json { render json: @case.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cases/1
  # PATCH/PUT /cases/1.json
  def update
    respond_to do |format|
      if @case.update(case_params)
        format.html { redirect_to @case, notice: 'Case was successfully updated.' }
        format.json { render :show, status: :ok, location: @case }
      else
        format.html { render :edit }
        format.json { render json: @case.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cases/1
  # DELETE /cases/1.json
  def destroy
    @case.destroy
    respond_to do |format|
      format.html { redirect_to cases_url, notice: 'Case was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_case
      @case = Case.includes(:case_records, :case_users).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def case_params
      params.require(:case).permit(:rol, :fecha, :tribunal, :caratula, :info_id, :info_type)
    end
end
