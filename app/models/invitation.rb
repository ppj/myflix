class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :inviter, class_name: "User"
  validates_presence_of :invitee_name, :invitee_email, :message
end
