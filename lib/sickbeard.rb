class SB

	require 'net/http'
	require 'uri'
	require 'json'
	require 'cgi'

  def self.request(cmd, options = {})
    options = { cmd: cmd }.merge(options)
    path = "/api/933a8eb69f569eddc4c6182da5cc228e/"
    uri = URI::join(URI.parse('http://10.0.0.2:2121'), path)
    uri.query = URI.encode_www_form( options )
    Net::HTTP.get(uri)
  end

  def self.json(cmd, options = {})
    response = JSON.parse(request(cmd, options))
  end

  def self.searchtvdb(name)
    json('sb.searchtvdb', name: name)['data']['results'].collect do |result|
      Show.from_response(result['tvdbid'], result)
    end
  end

  def self.episode(show_id, season, episode)

    resp = SB.json('episode', tvdbid: show_id, season: season, episode: episode, full_path: 1)

    if resp['result'] == 'success' then
      Episode.from_response(show_id, season, episode, resp['data'])
    else
      nil
    end
  end

  def self.show(show_id)

    resp = SB.json('show', tvdbid: show_id)

    if resp['result'] == 'success' then
      Show.from_response(show_id, resp['data'])
    else
      nil
    end

  end

  def self.future

    response = Array.new
    SB.json('future', type: "today", paused: "1")['data']['today'].each do |show|

      day = show['weekday'].to_i + 1

      if day == 7 then day = 0 end
      if day == 8 then day = 1 end

      season = show['season'].to_i
      episode = show['episode'].to_i

      if season < 10 then season = "0#{season}" end
      if episode < 10 then episode = "0#{episode}" end

      if show['ep_plot'].empty? then show['ep_plot'] = "There is no description filled for this episode." end

      response.push({
        tvdbid: show['tvdbid'],
        title: show['show_name'],
        eptitle: show['ep_name'],
        epdesc: show['ep_plot'],
        epseason: show['season'],
        epnumber: "S#{season}E#{episode}",
        airdate: show['airdate'],
        weekday: "Tomorrow"
        })
    end

    SB.json('future', type: "soon", paused: "1")['data']['soon'].each do |show|

      day = show['weekday'].to_i + 1

      if day == 7 then day = 0 end
      if day == 8 then day = 1 end

      season = show['season'].to_i
      episode = show['episode'].to_i

      if season < 10 then season = "0#{season}" end
      if episode < 10 then episode = "0#{episode}" end

      if show['ep_plot'].empty? then show['ep_plot'] = "There is no description filled for this episode." end

      if show['airdate'].to_datetime < (Date.today + 2) then

        response.push({
          tvdbid: show['tvdbid'],
          title: show['show_name'],
          eptitle: show['ep_name'],
          epdesc: show['ep_plot'],
          epnumber: "S#{season}E#{episode}",
          weekday: Date::DAYNAMES[day]
          })
        end

      end

    response

  end

end
