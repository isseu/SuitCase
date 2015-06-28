class SearchesController < ApplicationController
  before_action :set_search, only: [:show]

  def new
    @search = Search.new
  end

  def show

  end

  def create
    @search = Search.new(search_params)
    @search.state = false
    # Deberia iniciar busqueda asincronica

    respond_to do |format|
      if @search.save
        format.html { redirect_to @search, notice: 'Case was successfully created.' }
        format.json { render :show, status: :created, location: @search }
      else
        format.html { render :new }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params.require(:search).permit(:rol, :name, :first_lastname, :second_lastname, :rut)
    end
end
