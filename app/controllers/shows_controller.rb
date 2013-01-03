class ShowsController < ApplicationController

	require 'json'
	require 'sickbeard'

	include ERB::Util

	def index

		user = User.find_by_uid(session[:userid])

		if user

			shows = Array.new

			Show.order(:title).each do |show| 

				if user.tracking.include? ";#{show.tvdbid};" 
				
				if show.next_ep_airdate.empty? then 

					if show.state == "Ended" then
						next_airdate = "N/A"
					else
						next_airdate = "-1" 
					end

				else 
					next_airdate = (show.next_ep_airdate.to_datetime - Date.today).to_i
				end 

					shows.push(
						{ 
							tvdbid: show.tvdbid, 
							title: show.title,
							state: show.state,
							seasons: show.seasons.length,
							next_episode: next_airdate
						}) 

				end

			end

			render :json => JSON.generate(shows)

		end

	end

	def recent

		user = User.find_by_uid(session[:userid])

		if user

			episodes = Array.new

			Episode.where({ airdate: (Date.today - 1).to_s }).each do |ep| 

				if user.tracking.include? ";#{ep[:tvdbid]};"
				
			      season = ep[:season].to_i
			      episode = ep[:number].to_i

			      if season < 10 then season = "0#{season}" end
			      if episode < 10 then episode = "0#{episode}" end

			      if ep[:description].empty? then ep[:description] = "There is no description filled for this episode." end

					episodes.push(
						{ 
	        			tvdbid: ep[:tvdbid],
	        			show: Show.find_by_tvdbid(ep[:tvdbid]).title,
	        			title: ep[:title],
	        			description: ep[:description],
	        			season: season,
	        			number: episode,
	        			epnumber: "S#{season}E#{episode}",
	        			weekday: "Today"
						}) 

				end

			end

			Episode.where({ airdate: (Date.today - 2).to_s }).each do |ep| 

				if user.tracking.include? ";#{ep[:tvdbid]};"
				
			      season = ep[:season].to_i
			      episode = ep[:number].to_i

			      if season < 10 then season = "0#{season}" end
			      if episode < 10 then episode = "0#{episode}" end

			      if ep[:description].empty? then ep[:description] = "There is no description filled for this episode." end

					episodes.push(
						{ 
	        			tvdbid: ep[:tvdbid],
	        			show: Show.find_by_tvdbid(ep[:tvdbid]).title,
	        			title: ep[:title],
	        			description: ep[:description],
	        			season: season,
	        			number: episode,
	        			epnumber: "S#{season}E#{episode}",
	        			weekday: "Yesterday"
						}) 

				end

			end

			render :json => JSON.generate(episodes)

		end

	end

	def upcoming

		user = User.find_by_uid(session[:userid])

		if user

			shows = Array.new

			Episode.where({ airdate: (Date.today - 2).to_s }).each do |ep| 

				if user.tracking.include? ";#{ep[:tvdbid]};"
				
			      season = ep[:season].to_i
			      episode = ep[:number].to_i

			      if season < 10 then season = "0#{season}" end
			      if episode < 10 then episode = "0#{episode}" end

			      if ep[:description].empty? then ep[:description] = "There is no description filled for this episode." end

					shows.push(
						{ 
	        			tvdbid: ep[:tvdbid],
	        			title: Show.find_by_tvdbid(ep[:tvdbid]).title,
	        			eptitle: ep[:title],
	        			epdesc: ep[:description],
	        			epseason: season,
	        			epnumber: "S#{season}E#{episode}",
	        			airdate: ep[:airdate],
	        			weekday: "Yesterday"
						}) 

				end

			end

			Episode.where({ airdate: (Date.today - 1).to_s }).each do |ep| 

				if user.tracking.include? ";#{ep[:tvdbid]};"
				
			      season = ep[:season].to_i
			      episode = ep[:number].to_i

			      if season < 10 then season = "0#{season}" end
			      if episode < 10 then episode = "0#{episode}" end

			      if ep[:description].empty? then ep[:description] = "There is no description filled for this episode." end
					
					shows.push(
						{ 
	        			tvdbid: ep[:tvdbid],
	        			title: Show.find_by_tvdbid(ep[:tvdbid]).title,
	        			eptitle: ep[:title],
	        			epdesc: ep[:description],
	        			epseason: season,
	        			epnumber: "S#{season}E#{episode}",
	        			airdate: ep[:airdate],
	        			weekday: "Today"
						}) 

				end

			end

			SB.future.each do |show|

				if user.tracking.include? ";#{show[:tvdbid]};" 
				
					shows.push(
						{ 
	        			tvdbid: show[:tvdbid],
	        			title: show[:title],
	        			eptitle: show[:eptitle],
	        			epdesc: show[:epdesc],
	        			epseason: show[:epseason],
	        			epnumber: show[:epnumber],
	        			airdate: show[:airdate],
	        			weekday: show[:weekday]
						}) 

				end

			end

			render :json => JSON.generate(shows)

		end

	end

	def banner

		## todo if no banner, then generate GD image with text header.

  		response.headers['Cache-Control'] = "public, max-age=#{12.hours.to_i}"
  		response.headers['Content-Type'] = 'image/jpeg'
  		response.headers['Content-Disposition'] = 'inline'

		sid = params[:id].gsub(/[^0-9]/, "").to_i if params[:id]

		render :text => Show.find_by_tvdbid(sid).get_banner

	end

	def poster

		## todo if no poster, then generate GD image with text header.

  		response.headers['Cache-Control'] = "public, max-age=#{12.hours.to_i}"
  		response.headers['Content-Type'] = 'image/jpeg'
  		response.headers['Content-Disposition'] = 'inline'

		sid = params[:id].gsub(/[^0-9]/, "").to_i if params[:id]

		render :text => Show.find_by_tvdbid(sid).get_poster

	end

	def seasons
		sid = params[:id].gsub(/[^0-9]/, "").to_i if params[:id]

		render :text => Show.find_by_tvdbid(sid).seasons.length.to_s
	end

	def search

		search = params[:searchTerm].gsub('/[^\w@.\ ]/', "")

		shows = Array.new

		if (search.length > 0)

			SB.searchtvdb(search).each do |show| 

				if show.first_aired.nil? then 
					aired = "Unknown" 
				else 
					aired = show.first_aired.to_datetime.strftime('%d %B %Y') 
				end 

				shows.push(
					{ 
						tvdbid: show.tvdbid, 
						title: show.title,
						first_aired: aired
					}) 

			end

			render :json => JSON.generate(shows)

		else 

			render :json => JSON.generate(shows)

		end
	end

	def track

		tvdbid = params[:id].gsub(/[^0-9]/, "").to_i
		user = User.find_by_uid(session[:userid])

		if SB.show(tvdbid).nil?

			s = Show.new
			s.tvdbid = tvdbid

			response = s.add

			if !user.vip? then s.pause end

		else 
			if user.vip? then Show.find_by_tvdbid(tvdbid).unpause end
			response = "success"
		end

		user.tracking = ";" + ((user.tracking.split(';') - ["", "#{tvdbid}"]).push(["#{tvdbid}"]).join(';')).to_s + ";"

		user.save

		render :text => response
	end

	def untrack

		tvdbid = params[:id].gsub(/[^0-9]/, "").to_i
		user = User.find_by_uid(session[:userid])

		user.tracking = ";" + ((user.tracking.split(';') - ["", "#{tvdbid}"]).join(';')).to_s + ";"

  		user.save

 		if User.find(:all, :conditions=> 'tracking like "%;#{tvdbid};%"').length == 0 then
 			Show.find_by_tvdbid(tvdbid).pause
 		end
  		
		render :text => "success"
	end

end

