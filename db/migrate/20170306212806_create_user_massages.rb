class CreateUserMassages < ActiveRecord::Migration[5.0]
  def change
    create_table :user_massages do |t|
      t.references :user, foreign_key: true
      t.references :massage, foreign_key: true

      t.timestamps
    end
  end
end
