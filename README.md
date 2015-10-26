###Ruby Sightstone: A small wrapper for the Riot API

To use:

`gem install ruby_sightstone`

Or add `gem 'ruby_sightstone'` to your Gemfile.

Example calls:
```
require 'ruby_sightstone'

# api_key should be private and kept in your environment or config. Region is one of the riot region strings (na, eu, kr, cn, etc.)
riot = RubySightstone.new(api_key, region)
# returns a hash of champion data
riot.champions
# returns a list of recent games after looking up the summoner id for a username
id = riot.summoner("Excessively")["id"]
riot.recent_games(id)
# returns the latest match id, then looks up all the details of the match
riot.match(riot.latest_match(id)["id"])
```

If any response from the Riot API is unsuccessful, the Ruby Sightstone client raises a `RiotAPIException` with the error code in the response. This can be useful if you're creating an API layer on top of Riot:
```
begin
	riot.match(match_id)
	# do other stuff here if successful
rescue RiotAPIException => e
	"Riot failed with #{e}"
end
```
