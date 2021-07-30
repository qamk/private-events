class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.datetime :datetime

      t.references :users, :host, foreign_key: true

      t.timestamps
    end
  end
end
