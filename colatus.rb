require "open-uri"
require "sinatra"
require "oj"
require "builder"

REPO = "https://github.com/dailydiscovery/dailydiscovery"

helpers do
  def discovery?(event, repo, action)
    event == "PullRequestEvent" && repo == REPO && action == "opened"
  end
end

get "/" do
  "<a href=\"#{REPO}\">Daily Discovery</a> encourages life-long learning through GitHub."
end

get "/:login/pulls.rss" do |login|
  @login = login
  @items = []

  open "https://github.com/#{@login}.json" do |f|
    json = Oj.load f

    json.each do |event|
      next unless discovery?(event["type"], event["repository"]["url"], event["payload"]["action"])

      @items << {
        :link => event["payload"]["pull_request"]["html_url"],
        :title => event["payload"]["pull_request"]["title"],
        :description => event["payload"]["pull_request"]["body"].to_s,
        :pub_date => event["payload"]["pull_request"]["created_at"]
      }
    end
  end

  builder :rss
end
