require 'uri'
require 'net/http'

uri = URI('https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY')
res = Net::HTTP.get_response(uri)
puts res.body if res.is_a?(Net::HTTPSuccess)

# nethttp2.rb
require 'uri'
require 'net/http'

uri = URI('https://api.nasa.gov/planetary/apod')
params = { :api_key => 'your_api_key' }
uri.query = URI.encode_www_form(params)

res = Net::HTTP.get_response(uri)
puts res.body if res.is_a?(Net::HTTPSuccess)

# nethttp3.rb
require 'uri'
require 'net/http'

uri = URI('https://jsonplaceholder.typicode.com/posts')
res = Net::HTTP.post_form(uri, 'title' => 'foo', 'body' => 'bar', 'userID' => 1)
puts res.body  if res.is_a?(Net::HTTPSuccess)

# httparty.rb
require 'httparty'

response = HTTParty.get('https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY')
puts response.body if response.code == 200

# httparty2.rb
require "httparty"

class PostManager
  include HTTParty
  base_uri 'https://jsonplaceholder.typicode.com'

  def initialize()

  end

  def create_post(title, body, user_id)
    params = { body: { title: title, body: body, userID: user_id } }
    self.class.post("/posts", params).parsed_response
  end
end

post_manager = PostManager.new()
p post_manager.create_post("foo", "bar", 1)


# http.rb
require "http"

response = HTTP.get("https://api.nasa.gov/planetary/apod", :params => {:api_key => "DEMO_KEY"})
p response.parse

# http2.rb
require "http"

response = HTTP.post("https://jsonplaceholder.typicode.com/posts", :form => {'title' => 'foo', 'body' => 'bar', 'userID' => 1})
p response.parse

# httpx.rb
require "httpx"

response = HTTPX.get("https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")
puts response.body if response.status == 200

# httpx2.rb
require "httpx"

response = HTTPX.post("https://jsonplaceholder.typicode.com/posts", :json => {'title' => 'foo', 'body' => 'bar', 'userID' => 1})
puts response.body if response.status == 201


# httpx3.rb
require 'httpx'

base_url = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
response, response2 = HTTPX.get(base_url, base_url + "&date=2019-07-20")
puts response.body if response.status == 200
puts response2.body if response2.status == 200

# faraday.rb
require "faraday"

response = Faraday.get("https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")
p response.body if response.status == 200

# faraday2.rb
require "faraday"
require 'uri'

params = {title: "foo", body: "bar", userID: 1}
encoded_params = URI.encode_www_form(params)
response = Faraday.post("https://jsonplaceholder.typicode.com/posts", encoded_params)
p response.body if response.status == 201


# faraday3.rb
require "faraday"

response = Faraday.post "https://jsonplaceholder.typicode.com/posts" do |request|
  request.body = URI.encode_www_form({title: "foo", body: "bar", userID: 1})
end
p response.body if response.status == 201

# app/controllers/travel_controller.rb
class TravelController < ApplicationController
  def index
  end
end
​
<!-- app/views/travel/index.html.erb -->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-5">
      <div class="mx-auto mt-5" style="width: 400px">
        <%= form_with(url: search_path, method: 'get', local: true) do %>
          <div class="form-group">
            <%= label_tag :country, 'Search for a country '%>
            <%= text_field_tag :country, nil, placeholder: 'Eg. Germany', class: 'form-control' %>
          </div>
​
          <%= button_tag 'Search', class: 'btn btn-success btn-block' %>
        <% end %>
      </div>
    </div>
  </div>
</div>
​
# config/routes.rb
Rails.application.routes.draw do
  root to: 'travel#index'
​
  get '/search' => 'travel#search'
end
​
# app/controllers/travel_controller.rb
# ...
def search
  countries = find_country(params[:country])
​
  unless countries
    flash[:alert] = 'Country not found'
    return render action: :index
  end
​
  # ...
end
​
<!-- app/views/travel/index.html.erb -->
    
    <!-- ... -->
    <div class="col-lg-12 mt-5">
      <% if flash[:alert] %>
        <div class="alert alert-warning"><%= flash[:alert] %></div>
      <% end %>
​
      <div class="mx-auto mt-5" style="width: 400px">
    <!-- ... -->
​
​
 # app/controllers/travel_controller.rb
  private
​
  def request_api(url)
    response = Excon.get(
      url,
      headers: {
        'X-RapidAPI-Host' => URI.parse(url).host,
        'X-RapidAPI-Key' => ENV.fetch('RAPIDAPI_API_KEY')
      }
    )
​
    return nil if response.status != 200
​
    JSON.parse(response.body)
  end
​
  def find_country(name)
    request_api(
      "https://restcountries-v1.p.rapidapi.com/name/#{URI.encode(name)}"
    )
  end
​
 # app/controllers/travel_controller.rb
  def find_weather(city, country_code)
    query = URI.encode("#{city},#{country_code}")
​
    request_api(
      "https://community-open-weather-map.p.rapidapi.com/forecast?q=#{query}"
    )
  end
