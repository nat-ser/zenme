# frozen_string_literal: true
class Massage < ApplicationRecord
	has_many :user_massages
	has_many :users, through: :user_massages
end
