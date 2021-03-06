module SessionsHelper
	def log_in(user)
		session[:user_id] = user.id
	end

	#gets the current user based on temporary or permanent session id
	def current_user

		#first check for temporary sessions (the if is nullcheck on assignment)
		if(user_id = session[:user_id])
			@curent_user ||= User.find_by(id: session[:user_id])

		#else, grab the perm session from browser cookies
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	def logged_in?
		!current_user.nil?
	end

	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end
	
	#remembers a user in a persistent session via permanent cookies
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def current_project(user = current_user)
		@project = Project.find_by(id: user[:current_project])
	end

end
