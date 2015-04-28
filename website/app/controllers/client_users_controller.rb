class ClientUsersController < ApplicationController
  before_action :set_client_user, only: [:show, :edit, :update, :destroy]

  # GET /client_users
  # GET /client_users.json
  def index
    @client_users = ClientUser.all
  end

  # GET /client_users/1
  # GET /client_users/1.json
  def show
  end

  # GET /client_users/new
  def new
    @client_user = ClientUser.new
  end

  # GET /client_users/1/edit
  def edit
  end

  # POST /client_users
  # POST /client_users.json
  def create
    @client_user = ClientUser.new(client_user_params)

    respond_to do |format|
      if @client_user.save
        format.html { redirect_to @client_user, notice: 'Client user was successfully created.' }
        format.json { render :show, status: :created, location: @client_user }
      else
        format.html { render :new }
        format.json { render json: @client_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /client_users/1
  # PATCH/PUT /client_users/1.json
  def update
    respond_to do |format|
      if @client_user.update(client_user_params)
        format.html { redirect_to @client_user, notice: 'Client user was successfully updated.' }
        format.json { render :show, status: :ok, location: @client_user }
      else
        format.html { render :edit }
        format.json { render json: @client_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client_users/1
  # DELETE /client_users/1.json
  def destroy
    @client_user.destroy
    respond_to do |format|
      format.html { redirect_to client_users_url, notice: 'Client user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client_user
      @client_user = ClientUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_user_params
      params.require(:client_user).permit(:user_id, :client_id)
    end
end
