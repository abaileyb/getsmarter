class UsersController < ApplicationController

	def new
		@user = User.new
	end

	def create
		@user = User.new

		if @user.save
			redirect_to #courses
		else
			render 'new'
		end
	end

	def destroy
	end

end
