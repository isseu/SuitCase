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
    if params[:only_user]
      @cases = current_user.cases
    end
    if not params[:user_id].blank?
      @cases = User.find(params[:user_id].to_i).cases
    end
    @cases = @cases.includes(:case_records, :case_users)
    # Busqueda en search
    if not params[:rol].nil?
      @cases = @cases.joins(:litigantes)
                   .where( 'lower(rol)               LIKE ?',
                            '%' + params[:rol].downcase + '%'
      )
    # Busqueda por dynatable
    elsif not params[:queries].nil? and not params[:queries][:search].nil?
      @cases = @cases.joins(:litigantes).where(
         'lower(rol)               LIKE :search OR
          lower(tribunal)          LIKE :search OR
          lower(caratula)          LIKE :search OR
          lower(info_type)         LIKE :search OR
          lower(litigantes.nombre) LIKE :search OR
          lower(litigantes.rut) LIKE :search',
          search: '%' + params[:queries][:search].downcase + '%')
    end
    if not params[:page].blank? and not params[:per_page].blank?
      @cases = @cases.paginate(:page => params[:page].to_i, :per_page => params[:per_page].to_i)
    end
    if not params[:order].blank?
      atributo = params[:order].keys[0].to_s == 'portal' ? 'info_type' : params[:order].keys[0].to_s
      @cases = @cases.order(atributo + ' ' + (params[:order].values[0].to_i == 1 ? 'DESC':'ASC'))
    end
    @cases = @cases.all
  end

  # GET /cases/1
  # GET /cases/1.json
  def show
    @users = User.all
    @all_users = User.all
    @case_user = @case.case_users.build
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
