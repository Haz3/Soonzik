class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :finish_signup]

  # GET /users/:id.:format
  def show
    # authorize! :read, @user
    @viewArtist = false
    if (@user.isArtist?)
      @viewArtist = true
      @topFive = @user.giveTopFive
      @packsImplicated = @user.givePack
    end
  end

  # GET /users/:id/edit
  def edit
    # authorize! :update, @user
    respond_to do |format|
      if (!(user_signed_in? && params[:id].to_i == current_user.id))
        format.html { redirect_to root_path }
        format.json { render :json => {}, status: :forbidden }
      else
        set_user
        format.html
        format.json { render :json => @user.as_json(except: [:salt, :password, :idAPI, :secureKey, :created_at, :updated_at, :address_id], :include => {
            :address => { :only => Address.miniKey }
          }) }
      end
    end
  end

  # PATCH/PUT /users/:id.:format
  # Won't be call
  # Can be delete ?
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(User.user_params params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    if current_user && ( current_user.email_verified?() && current_user.username_verified?())
      redirect_to root_path
    # authorize! :update, @user 
    elsif request.patch? && params[:user] #&& params[:user][:email]
      @user.skip_reconfirmation!
      if @user.update(User.user_params params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  # DELETE /users/:id.:format
  # Won't be call
  # Can be delete ?
  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end
end