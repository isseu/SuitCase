class PossibleNamesController < ApplicationController
  before_action :set_possible_name, only: [:show, :edit, :update, :destroy]
  autocomplete :user, :name, :full => true, :extra_data => [:first_lastname, :second_lastname], :display_value => :inspect

  # GET /possible_names
  # GET /possible_names.json
  def index
    @possible_names = current_user.possible_names.all
  end

  # GET /possible_names/1
  # GET /possible_names/1.json
  def show
  end

  # GET /possible_names/new
  def new
  end

  # GET /possible_names/1/edit
  def edit
  end

  # POST /possible_names
  # POST /possible_names.json
  def create
    @possible_name = PossibleName.new(possible_name_params)

    respond_to do |format|
      if @possible_name.save
        format.html { redirect_to possible_names_url, notice: 'Possible name was successfully created.' }
        format.json { render :show, status: :created, location: @possible_name }
      else
        format.html { render :new }
        format.json { render json: @possible_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /possible_names/1
  # PATCH/PUT /possible_names/1.json
  def update
    respond_to do |format|
      if @possible_name.update(possible_name_params)
        format.html { redirect_to @possible_name, notice: 'Possible name was successfully updated.' }
        format.json { render :show, status: :ok, location: @possible_name }
      else
        format.html { render :edit }
        format.json { render json: @possible_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /possible_names/1
  # DELETE /possible_names/1.json
  def destroy
    @possible_name.destroy
    respond_to do |format|
      format.html { redirect_to possible_names_url, notice: 'Possible name was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_possible_name
      @possible_name = PossibleName.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def possible_name_params
      params.require(:possible_name).permit(:user_id, :name, :first_lastname, :second_lastname)
    end
end
