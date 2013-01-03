class EpisodesController < ApplicationController

	require 'json'
	require 'sickbeard'

	def index

		sid = params[:showid].gsub(/[^0-9]/, "").to_i if params[:showid]
		sed = params[:seasonnr].gsub(/[^0-9]/, "").to_i if params[:seasonnr]

		episodes = Array.new

		Show.find_by_tvdbid(sid).episodes(sed).each do |episode| 

			if !episode[1]['airdate'].empty? && episode[1]['name'] != "TBA" then

				episodes.push(
					SB.episode(sid, sed, episode[0])
				)

			end

		end

		render :json => episodes
	end

	def download

		# filter params meuk

		if User.find_by_uid(session[:userid]).vip? then

			path = SB.episode(params[:showid], params[:seasonnr], params[:episodeid]).location
	
			if path.empty? then
				render :text => "File seems to be unavaliable, please contact me :)", :status => 404
			else 

				# fname = path.split('/')[path.split('/').length - 1]

				# head(
				# 	:x_accel_redirect => '/clouvirec/repo/' + path.gsub("/opt/clouvirec/", ""),
				# 	:content_type => "application/octet-stream",
				# 	:content_disposition => "attachment; filename=\"#{fname}\""
				# 	)


				# head("Content-Disposition: attachment; filename=#{fname}");
				# head("Content-type: application/octet-stream");
				# head("X-Accel-Redirect: ");

				# render :nothing => true
				## redirect_to repo.luminarium.nl/90210 etc. 


				redirect_to "http://repo.pingvin.nl/d/" + path.gsub("/opt/clouvirec/", "")
				# redirect_to "https://repo.luminarium.nl/" + params[:showid] + "/" + params[:seasonnr] + "/" + params[:episodeid]
			end
		else 

			render :text => "", :status => 403  

		end

	end

	def req

		if User.find_by_uid(session[:userid]).vip? then

			episode = SB.episode(params[:showid], params[:seasonnr], params[:episodeid])

			if episode.status != "Wanted" && episode.status != "Downloaded" && episode.status != "Snatched" then

				response = episode.req

				if response == "success" then
					r = Request.new
					r.uid = session[:userid]
					r.showid = params[:showid]
					r.season = params[:seasonnr]
					r.episode = params[:episodeid]
					r.save
				end

			else 
				response = "failure"
			end

			render :text => response

		end

	end

end

