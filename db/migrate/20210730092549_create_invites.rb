class CreateInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :invites do |t|
      t.text :message
      t.boolean :rsvp, null: true, default: nil
      
      t.references :users, :invited_user, foreign_key: true
      t.references :events, :event_invite, foreign_key: true
      t.timestamps
    end
  end
end
