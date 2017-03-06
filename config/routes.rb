# frozen_string_literal: true
Rails.application.routes.draw do
  root to: "preferences#new"
  devise_for :users
  resources :preferences, only: [:new, :create]
end
