class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # has_secure_password

  after_commit :add_default_username, on: %i[create update]
=begin
  after_commit :add_default_avatar, on: %i[create update]
=end

  has_one_attached :avatar

  validates :username, presence: true, unless: :new_record?
=begin
  validates :avatar, presence: true, unless: -> { avatar.attached? }
=end

  key_binary = ["ad6eb5ee2e3fdb111705375170e61bc494bc896c5291ad41ea852e8adb627322"].pack('H*')

  attr_encrypted :name, key: key_binary
  attr_encrypted :email, key: key_binary
  attr_encrypted :phone_number, key: key_binary

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments
  has_many :likes, dependent: :destroy
  has_many :stories

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  #validates :phone_number, presence: true, uniqueness: false, format: { with: /\A\d{10,15}\z/ }

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  private

  def add_default_username
    self.username ||= "User#{self.id}"
    # No need to call save here if this is a before_save callback
  end

=begin
  def add_default_avatar
    unless avatar.attached?
      avatar.attach(
        io: File.open(Rails.root.join('app', 'uploads', 'default_image.png')),
        filename: 'default_image.png',
        content_type: 'image/png'
      )
    end
  end
=end

end
