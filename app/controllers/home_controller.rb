class HomeController < ApplicationController
  def index
    render plain: "Bienvenue sur Pokecoin API"
  end
end