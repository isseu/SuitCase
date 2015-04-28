class LitigantesController < ApplicationController
  before_action :set_litigante, only: [:show, :edit, :update, :destroy]

  # GET /litigantes
  # GET /litigantes.json
  def index
    @litigantes = Litigante.all
  end

  # GET /litigantes/1
  # GET /litigantes/1.json
  def show
  end

  # GET /litigantes/new
  def new
    @litigante = Litigante.new
  end

  # GET /litigantes/1/edit
  def edit
  end

  # POST /litigantes
  # POST /litigantes.json
  def create
    @litigante = Litigante.new(litigante_params)

    respond_to do |format|
      if @litigante.save
        format.html { redirect_to @litigante, notice: 'Litigante was successfully created.' }
        format.json { render :show, status: :created, location: @litigante }
      else
        format.html { render :new }
        format.json { render json: @litigante.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /litigantes/1
  # PATCH/PUT /litigantes/1.json
  def update
    respond_to do |format|
      if @litigante.update(litigante_params)
        format.html { redirect_to @litigante, notice: 'Litigante was successfully updated.' }
        format.json { render :show, status: :ok, location: @litigante }
      else
        format.html { render :edit }
        format.json { render json: @litigante.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /litigantes/1
  # DELETE /litigantes/1.json
  def destroy
    @litigante.destroy
    respond_to do |format|
      format.html { redirect_to litigantes_url, notice: 'Litigante was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_litigante
      @litigante = Litigante.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def litigante_params
      params.require(:litigante).permit(:case_id, :participante, :rut, :persona, :nombre)
    end
end
