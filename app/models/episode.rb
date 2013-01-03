class Episode < ActiveRecord::Base

    def self.from_response(tvdbid, season, number, response)

        ep = Episode.where(
            :tvdbid => tvdbid, 
            :season => season, 
            :number => number,
            ).first_or_create!

    	ep.title = response['name']
    	ep.description = response['description'].split('Recap')[0]
    	ep.location = response['location']
    	ep.airdate = response['airdate'] 

        # if User.find_by_uid(session[:userid]).vip? then
        if User.find(1).vip? then

            case response['status']
                when "Downloaded" then ep.status = "Avaliable"
                when "Snatched" then ep.status = "Requested"
                when "Wanted" then ep.status = "Requested"
                when "Unaired" then ep.status = "Unaired"
                else ep.status = "Unavailable"
            end

        else

            case response['status']
                when "Downloaded" then ep.status = "Aired"
                when "Snatched" then ep.status = "Aired"
                when "Wanted" then ep.status = "Aired"
                else ep.status = "Unaired"
            end            
    
        end

    	ep.save
        ep
    end

    def req
      SB.json('episode.setstatus', tvdbid: tvdbid, season: season, episode: number, status: "wanted")['result']
    end


    def remove 

        puts "Refreshing : " + SB.json('show.refresh', tvdbid: tvdbid)['result']
        puts "Setting status : " + SB.json('episode.setstatus', tvdbid: tvdbid, season: season, episode: number, status: "archived")['result']
        
        puts "Deleting file : " + File.delete(location)
        
        Download.where({tvdbid: tvdbid, season: season, episode: number}).destroy
        delete

    end


end
