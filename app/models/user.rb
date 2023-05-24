class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :name, presence: true, length: { maximum: 20, allow_blank: true }
  validates :email, uniqueness: true, presence: true
  validates :password, presence: true, confirmation: true, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
end
