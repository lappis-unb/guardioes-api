class UsersController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :query_by_param]
  before_action :authenticate_user!, except: [:index, :query_by_param]
  before_action :set_user, only: [:show, :destroy]
  before_action :set_user_update, only: [:update]

  # GET /user
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # PATCH/PUT /apps/1
  def update
    if @user.update(update_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def reset_password
    @user = User.find_by_email(params[:email])

    if @user.present?
      @user.send_reset_password_instructions
    end

    render json: :no_content, status: :ok
  end
  
  def destroy
    @user.destroy!
  end

  def query_by_param
    param_to_search = params[:param_to_search]
    param_content = params[:param_content]
    if param_to_search == "gender"
      @users = User.where(gender: param_content)
    elsif param_to_search == "race"
      @users = User.where(race: param_content)
    elsif param_to_search == "is_professional"
      @users = User.where(is_professional: param_content)
    elsif param_to_search == "country"
      @users = User.where(country: param_content)
    elsif param_to_search == "name"
      @users = User.where(user_name: param_content)
    end
    
    render json: @users
  end

  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    # if current_user.id != params[:id]
    #   render json: { errors: [
    #     detail: I18n.t("user.access_forbiden")
    #   ]}
    # else
    #   @user = User.find(current_user.id)
    # end
    @user = User.find(params[:id])
  end

  def set_user_update
    @user = User.find(update_params[:id])
  end
  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:user_name, :email, :birthdate, :country, :gender, :race, :is_professional, :app_id, :password, :picture)
  end

  def update_params
    params.require(:user).permit(:user_name, :email, :birthdate, :country, :gender, :race, :is_professional, :app_id)
  end
end
