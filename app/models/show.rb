class Show < ActiveRecord::Base

    attr_accessor :first_aired

    def self.from_response(tvdbid, response)

    	s = Show.new
    	s.title = response['show_name'] || response['name']
    	s.tvdbid = tvdbid
    	s.first_aired = response['first_aired']

    	s
    end

    def add
  		response = SB.json('show.addnew', tvdbid: tvdbid)['result']

  		i = 0

      until SB.show(tvdbid)
        sleep 1

        i += 1
        break if i == 10

      end

      self.title = SB.show(tvdbid).title

  		save
      response
    end

    def delete
      SB.json('show.delete', tvdbid: tvdbid)['result']
    end

    def episodes(season = nil)
      SB.json('show.seasons', tvdbid: tvdbid, season: season)['data']
    end

    def state
      SB.json('show', tvdbid: tvdbid)['data']['status']	
    end

    def next_ep_airdate
      SB.json('show', tvdbid: tvdbid)['data']['next_ep_airdate']
    end

    def get_banner
      SB.request('show.getbanner', tvdbid: tvdbid)
    end

    def get_poster
      SB.request('show.getposter', tvdbid: tvdbid)
    end
    
    def pause
      SB.json('show.pause', tvdbid: tvdbid, pause: 1)['result']
    end

    def unpause
      SB.json('show.pause', tvdbid: tvdbid)['result']
    end

    def paused?
      SB.json('show', tvdbid: tvdbid)['data']['paused'] == 1
    end

    def seasons
      (SB.json('show.seasonlist', tvdbid: tvdbid)['data'].sort) - [0]
    end

    def has_cached_poster?
      SB.json('show.cache', tvdbid: tvdbid)['data']['poster'] == 1
    end

    def has_cached_banner?
      SB.json('show.cache', tvdbid: tvdbid)['data']['banner'] == 1
    end

    def update
      SB.json('show.update', tvdbid: tvdbid)['result']
    end

    def refresh
      SB.json('show.refresh', tvdbid: tvdbid)['result']
    end

end