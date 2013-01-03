class UsersController < ApplicationController

  def show
  	
  	render :text => User.all
	  
  end

  def destroy 

  	## remove user User.find(params[:uid]).destroy

  	render :text => "Success"


  end



end

