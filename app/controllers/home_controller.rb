class HomeController < ApplicationController

	before_filter :set_p3p

  def index

  	## catch notification redirects, doe with #hash locations.

  	# app_id = 101723746665010
  	# app_secret = "79377d44f5617e07c73ebad7f8030291"
  	# callback_url = "https://apps.facebook.com/clouvirec/"
	# auth_url = "https://graph.facebook.com/oauth/authorize?client_id=101723746665010&redirect_uri=https%3A%2F%2Fapps.facebook.com%2Fclouvirec%2F"

	# @oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)

	# if params[:signed_request].nil? then
		# redirect_to auth_url
	# else
		# oauth_token = @oauth.parse_signed_request(params[:signed_request])['oauth_token']
		# profile = Koala::Facebook::API.new(oauth_token).get_object("me")
		# uid = profile['id']
		# name = profile['name']

		uid = "100001479177341"
		name = "Nick Meessen"

		if uid.empty? then
			redirect_to auth_url
		else

			u = User.where(:uid => uid).first_or_create!
			# u.name = name
			u.lastvisit = DateTime.now.to_s
			# u.tracking = ";;"
			# u.save

			session[:userid] = u.uid

		end

	# end

  end

    def set_p3p
      headers['P3P'] = 'CP="ALL DSP COR CURa ADMa DEVa OUR IND COM NAV"'
    end

end
