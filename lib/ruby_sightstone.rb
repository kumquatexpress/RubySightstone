require 'net/http'
require 'uri'
require 'json'
# @author Boyang Niu
# Lightweight wrapper for some of the Riot API
class RubySightstone
  # Creates a new client to the Riot API given a key and a region
  #
  # @param api_key [String] the api key to be used with this client
  # @param region [String] the region that this client will use to get responses (na, eu, kr, ...)
  def initialize(api_key, region)
    @base_params = {api_key: api_key}
    @base_url = "https://na.api.pvp.net/api/lol"
    @region = region
  end

  def champions(params={})
    req = URI("#{@base_url}/#{@region}/v1.2/champion")
    make_request_and_validate(req, params)
  end

  def champion(*ids)
    champions["champions"].select { |x| ids.include?(x["id"]) }
  end

  def recent_games(summoner_id, params={})
    req = URI("#{@base_url}/#{@region}/v1.3/game/by-summoner/#{summoner_id}/recent")
    make_request_and_validate(req, params)
  end

  def league(summoner_ids, params={})
    req = URI("#{@base_url}/#{@region}/v2.5/league/by-summoner/#{summoner_ids.join(",")}")
    make_request_and_validate(req, params)
  end

  def matchlist(summoner_id, params={})
    req = URI("#{@base_url}/#{@region}/v2.2/matchlist/by-summoner/#{summoner_id}")
    make_request_and_validate(req, params)
  end

  def latest_match(summoner_id)
    matchlist(summoner_id, {"begin": 0, "end": 1})["matches"].first
  end

  def static_data(type, params={})
    req = URI("#{@base_url}/static-data/#{@region}/v1.2/#{type}")
    make_request_and_validate(req, params) 
  end

  def match(match_id, params={})
    req = URI("#{@base_url}/#{@region}/v2.2/match/#{match_id}")
    make_request_and_validate(req, params)
  end

  def summoner(name, params={})
    req = URI("#{@base_url}/#{@region}/v1.4/summoner/by-name/#{name}")
    make_request_and_validate(req, params)
  end

  def stats_ranked(summoner_id, params={})
    req = URI("#{@base_url}/#{@region}/v1.3/stats/by-summoner/#{summoner_id}/ranked")
    make_request_and_validate(req, params)
  end

  def stats_summary(summoner_id, params={})
    req = URI("#{@base_url}/#{@region}/v1.3/stats/by-summoner/#{summoner_id}/summary")
    make_request_and_validate(req, params)
  end

  private
  def make_request_and_validate(req, params)
    req.query = URI.encode_www_form(@base_params.merge! params)
    resp = Net::HTTP.get_response(req)

    validate_and_respond(resp){ JSON(resp.body) }
  end

  def validate_and_respond(resp, &data)
    if resp.kind_of? Net::HTTPSuccess
      yield
    else
      raise RiotAPIException.new("#{resp.code} encountered from riot for #{resp.uri}")
    end
  end
end

class RiotAPIException < Exception
end