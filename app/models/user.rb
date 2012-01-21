class User < ActiveRecord::Base
  serialize :facebook_data
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable
         
        
  has_many :literatures
        
  GENDERS =  [ "", "male", "female"]  
  
  validates_inclusion_of :gender, :in => GENDERS, :allow_blank => true
  validates_uniqueness_of :facebook_token, :allow_nil => true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :gender, :email, :biography, :password, :password_confirmation, :remember_me
  attr_protected :as => :admin
  attr_accessor :new_from_facebook, :just_linked_to_facebook # used to inform the UI that we just created or linked a user
  
  def linked_to_facebook?
    facebook_token ? true : false
  end
  
  
  def facebook_name
    return nil unless linked_to_facebook?
    facebook_data.try(:[], :name)
  rescue TypeError # facebook_data is an array or a string?
    "Profile ##{facebook_token} (Name unkown)"
  end
  
  def facebook_profile
    return nil unless linked_to_facebook?
    facebook_data.try(:[], :link) || "http://www.facebook.com/#{facebook_token}"
  rescue TypeError # facebook_data is an array or a string?
    "https://facebook.com/#{facebook_token}"
  end
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info.to_hash
    data.symbolize_keys!
    puts data.inspect
    
    user = (
      User.find_by_facebook_token(data[:id]) || 
      User.find_by_email(data[:email]) || 
      User.new_for_facebook
    )
    user.update_facebook_data!(data)
    user
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.update_facebook_data(session["devise.facebook_data"])
      end
    end
  end
  
  def self.new_for_facebook
    password = Devise.friendly_token[0,20]
    u = User.new(:password => password, :password_confirmation => password)
    u.never_set_password = true
    u.new_from_facebook = true
    u
  end
  
  # This method fills in data from facebook that isn't already filled in.
  def update_facebook_data!(data)
    self.just_linked_to_facebook = true unless linked_to_facebook?
    self.facebook_token     = data[:id]
    # Not worth the time to abstract this because I might need to do more complex mappping in the future. 
    self.email              = data[:email]    if email.blank?
    self.name               = data[:name]     if name.blank?
    self.gender             = data[:gender]   if gender.blank?
    self.timezone           = data[:timezone] if timezone.blank?
    self.biography          = data[:bio]      if biography.blank?
    self.facebook_data      = data if changed?
    self.save
  end
end
