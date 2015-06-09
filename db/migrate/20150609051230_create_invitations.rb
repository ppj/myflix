class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :inviter_id
      t.string :invitee_email, :invitee_name
      t.text :message
      t.timestamps
    end
  end
end
