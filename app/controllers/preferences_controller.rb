# frozen_string_literal: true
class PreferencesController < ApplicationController
  before_action :authenticate_user!

  def new
    # TODO: get preferences from user (location and massage preferences)
    url = "https://www.groupon.com/browse/new-york?lat=40.7411955&lng=-73.99591570000001&address=Near+Me&query=massage&locale=en_US&sort=distance"
    GrouponScraper.save_nearby_massages(url, 5, current_user)
  end

  def create; end

  private

  def user_params
    params.require(:user).permit
  end
end
