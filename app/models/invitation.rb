class Invitation < ActiveRecord::Base
  after_create :generate_token

  belongs_to :inviter, class_name: "User"
  validates_presence_of :invitee_name, :invitee_email, :message

  private

  def generate_token
    update_column :token, SecureRandom.urlsafe_base64
  end
end
