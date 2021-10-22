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
