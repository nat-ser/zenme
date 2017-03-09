class UserMassage < ApplicationRecord
  belongs_to :user
  belongs_to :massage
end
