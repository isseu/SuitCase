class CaseRecordsController < ApplicationController
  before_action :set_case_record, only: [:show, :edit, :update, :destroy]

  # GET /case_records
  # GET /case_records.json
  def index
    @case_records = CaseRecord.all
  end

  # GET /case_records/1
  # GET /case_records/1.json
  def show
  end

  # GET /case_records/new
  def new
    @case_record = CaseRecord.new
  end

  # GET /case_records/1/edit
  def edit
  end

  # POST /case_records
  # POST /case_records.json
  def create
    @case_record = CaseRecord.new(case_record_params)

    respond_to do |format|
      if @case_record.save
        format.html { redirect_to @case_record, notice: 'Case record was successfully created.' }
        format.json { render :show, status: :created, location: @case_record }
      else
        format.html { render :new }
        format.json { render json: @case_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /case_records/1
  # PATCH/PUT /case_records/1.json
  def update
    respond_to do |format|
      if @case_record.update(case_record_params)
        format.html { redirect_to @case_record, notice: 'Case record was successfully updated.' }
        format.json { render :show, status: :ok, location: @case_record }
      else
        format.html { render :edit }
        format.json { render json: @case_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /case_records/1
  # DELETE /case_records/1.json
  def destroy
    @case_record.destroy
    respond_to do |format|
      format.html { redirect_to case_records_url, notice: 'Case record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_case_record
      if not params[:case_id].nil?
        @case_record = CaseRecord.where(case_id: params[:case_id]).first
        return
      end
      @case_record = CaseRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def case_record_params
      params.require(:case_record).permit(:case_id, :user_id)
    end
end
