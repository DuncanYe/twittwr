class UsersController < ApplicationController

  before_action :find_user

  def tweets
    @user = User.find(params[:id])
    @tweets = @user.tweets.order(created_at: :desc)

  end

  def edit
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to tweets_user_path(current_user), alert: "Can't edit other's profile"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user
      if @user.update(user_params)
        flash[:notice] = "Profile updated"
        redirect_to edit_user_path
      else
        flash[:alert] = @user.errors.full_messages.to_sentence
        render :edit
      end
    else
      flash[:alert] = "Can't edit other's profile"
      redirect_to edit_user_path
    end
  end

  def followings
    @followings = @user.followings.includes(:followships).order("followships.created_at desc") # 基於測試規格，必須講定變數名稱
  end

  def followers
    @followers = @user.followers.includes(:followships).order("followships.created_at desc") # 基於測試規格，必須講定變數名稱
  end

  def likes
    @user = User.find(params[:id])
    @likes = @user.like_tweets # 基於測試規格，必須講定變數名稱
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :avatar)
  end

  def find_user
    @user = User.find(params[:id])
  end

end
