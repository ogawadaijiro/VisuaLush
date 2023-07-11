class Post < ApplicationRecord
  attr_accessor :tag_names
  require 'aws-sdk-rekognition'


  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :tag_posts, dependent: :destroy
  has_many :tags, through: :tag_posts

  validates :image, presence: true

  def liked?(user)
    likes.where(user_id: user.id).exists?
  end

  def save_tags(tags)
    tags.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      self.tags << tag
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    []
  end

  def self.ransackable_associations(auth_object = nil)
    ['user', 'tags']
  end
end
