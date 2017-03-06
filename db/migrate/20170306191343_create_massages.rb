# frozen_string_literal: true
class CreateMassages < ActiveRecord::Migration[5.0]
  def change
    create_table :massages do |t|
      t.string :address
      t.string :title
      t.float :rating
      t.integer :rating_count
      t.text :fine_print
      t.text :merchant_profile

      t.timestamps
    end
  end
end
