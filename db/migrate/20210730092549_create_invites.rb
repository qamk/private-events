class CreateInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :invites do |t|
      t.text :message
      t.boolean :rsvp, null: true, default: nil
      
      t.references :invited_user, foreign_key: { to_table: :users }
      t.references :event_invite, foreign_key: { to_table: :events }
      t.timestamps
    end
  end
end
