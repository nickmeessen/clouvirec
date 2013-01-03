class NotifiesController < ApplicationController

	require 'net/http'
	require 'net/https'
	require 'sickbeard'

	def post

		showid = 0
		season = 0
		episode = 0 

		params[:sbresult].each_line do |line| 

			line.lstrip!

			if line[0..30] == "Loading show object for tvdb_id" then
				showid = line[31..line.length].gsub(/[^0-9]/, "").to_i
			end

			if line[0..28] == "Retrieving episode object for" then
				season = line[28..line.length].gsub(/[^0-9x]/, "").split('x')[0].to_i
				episode = line[30..line.length].gsub(/[^0-9x]/, "").split('x')[1].to_i
			end

		end

		if showid != 0 && season != 0 && episode != 0 then

			d = Download.new
			d.showid = showid
			d.season = season
			d.episode = episode
			# d.size = File.size(SB.episode(showid, season, episode).location)
			d.location = SB.episode(showid, season, episode).location
			d.save
			
			r = Request.find(:first, :conditions => ['showid=' + showid.to_s + ' AND season=' + season.to_s + ' AND episode=' + episode.to_s])

			if season < 9 then season = "0#{season}" end
			if episode < 9 then episode = "0#{episode}" end

			if r.nil? then

				notified = User.find(:all, :conditions => ['tracking LIKE :showid', {:showid => "%;#{showid};%"}])

				notified.each do |user| 

					msg = "A new episode (S#{season}E#{episode}) of #{SB.show(showid).title} has aired!"	
					send_notify(user.uid, msg)

				end

			else 
				msg = "Your requested episode (S#{season}E#{episode}) of #{SB.show(showid).title} is ready!"	
				send_notify(r.uid, msg)
			end

		end

		render :text => "Show ID #{showid} | #{SB.show(showid).title}, Season #{season}, Episode #{episode}, notified."

	end

	# def refresh

	# 	airingSoon = SB.future
	# 	cachedSoon = Upcoming.all

	# 	cachedSoon.each do |c| 

	# 		if(!airingSoon.include?(c)) then

	# 			User.where({ tracking like c.tvdbid })

	# 			notify that user, a new episode has aired blabla.


	# 		end

	# 	end

	# end


	private

	def send_notify userid, msg

		app_id = 204722759596775
  		app_secret = "685676a513ace291037311d316e82a26"
  		callback_url = "https://apps.facebook.com/clouvirec/"
		auth_url = "https://graph.facebook.com/oauth/authorize?client_id=204722759596775&redirect_uri=https%3A%2F%2Fapps.facebook.com%2Fclouvirec%2F"

		@oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
		token = @oauth.get_app_access_token

		curl = "https://apps.facebook.com/clouvirec/"

		url = URI.parse("https://graph.facebook.com/#{userid}/notifications")

		req = Net::HTTP::Post.new(url.path)
		req.set_form_data({ 'access_token' => token, 'template' => msg, 'href' => curl })
		
		res = Net::HTTP.new(url.host, url.port)
		res.use_ssl = true
		res.start {|http| http.request(req) }

	end


end
