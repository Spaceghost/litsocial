class User < ActiveRecord::Base
  has_paper_trail only: [:name, :tagline, :biography, :email, :banned, :banned_reason, :admin]
  attr_accessible :name, :tagline, :biography, :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :tagline, :biography, :email, :banned, :banned_reason, as: :admin

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :admins, where{ admin == true }
  scope :members, where{ (banned_at == nil) & (admin == false) }
  scope :banned, where{ banned_at != nil }

  has_many :series
  has_many :stories
  has_many :news_posts
  has_many :pages
  has_many :forum_posts
  has_many :messages, foreign_key: 'to_id'
  has_many :sent_messages, class_name: 'Message', foreign_key: 'from_id'

  NAME_REGEX = /([a-z][a-z0-9_]{2,12}[a-z0-9])/

  validates :name, uniqueness: true, format:{with: /\A#{NAME_REGEX}\Z/, on: :create}

  # Setup accessible (or protected) attributes for your model


  def self.valid_name?(name)
    name =~ /\A#{NAME_REGEX}\Z/
  end

  def banned?
    banned_at ? true : false
  end

  def banned
    banned?
  end

  def banned=(bool)
    if bool.to_i == 0
      self.banned_at = nil
    elsif !banned?
      self.banned_at = DateTime.now
    end
  end

  def ban!
    update_column :banned_at, DateTime.now
  end

  def to_s
    name
  end
end
