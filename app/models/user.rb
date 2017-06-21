require 'digest/sha1'
class User < ActiveRecord::Base

  has_many :particpants, :dependent => :destroy
  has_many :communities, :dependent => :destroy
  
  ##has_secure_password  doesn't work, couldn't find gem although install and in GemFile
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  name_alpha_regex = /\A[ a-zA-Z'-]+\z/
  alpha_numeric_regex = /\A[0-9 a-zA-Z:;.,!?'-]+\z/
  alpha_numeric_regex_msg = "must be alphanumeric characters with typical writing punctuation."
  alpha_numeric_regex_username = /\A[0-9 a-zA-Z\-\_]+\z/
  alias_attribute :echomarket_participation, :user_type

  attr_accessor :password, :password_confirmation, :instructions, :remember_token, :community_member
  attr_accessor :user_password_changed, :delete_user
  before_save   :encrypt_password, :password_match, :create_remember_token
  before_create :make_reset_code
  
  validates  :user_alias, :echomarket_participation, :username,:password, :password_confirmation, :email, :presence => true
  validates_uniqueness_of :username,:if => :username, :case_sensitive => true, :message =>  " already exists."
  validates_uniqueness_of :user_alias,:if => :user_alias, :case_sensitive => false, :message => " already exists"
  validates_uniqueness_of :email,:if => :email, :case_sensitive => false, :message =>  " already exists"
  validates_length_of :password, :if => :password, :in => 8..16, :message => "must be between 8 and 16 characters"
  validates_length_of :username, :if => :username, :in => 8..40, :message => "must be between 8 and 40 characters"
  validates_length_of :user_alias, :if => :user_alias, :in => 8..40, :message => "must be between 8 and 40 characters"
  validates_confirmation_of :password ,:if => :password, :message => "and re-entered password must match."
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  #  validates_format_of :username, :with => alpha_numeric_regex_username, :message => "must contain only alpha-numeric characters with either a dash or an underscore"
  
   
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.reset_code = nil
    if save(:validate => false)
      return true
    else 
      return false
    end
  end

  def active?
    # the existence of an activation code means they have not activated yet
    reset_code.nil?
  end

  # Authenticates a user by their username and unencrypted password. Returns the user or nil.
  def self.authenticate(username, password)
    logger.debug "Here at self.authenticate(u,p)"
    #u = find :first, :conditions => ['username = ? and activated_at IS NOT NULL', username]  What to keep activation separate from verifying userName
	
	#begin
    #u = find_by_username(username)
    u = find_by(username:username, is_active: 1)
	  	#rescue
	 # u = false
	#end

	
    # need to get the salt
	if u
    u && u.authenticated?(password) ? u : nil
	else
	  nil
	end
  end
  
  # Authenticates a user by their username and unencrypted password. Returns the user or nil.
  def self.activated?
    #u = find :first, :conditions => ['username = ? and activated_at IS NOT NULL', username]
	u = find :first, :conditions => ['username = ?', username]
    # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    logger.debug "crypted_password == encrypt(password)"
	logger.debug crypted_password == encrypt(password)
	crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering user between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token = encrypt("#{email}--#{remember_token_expires_at}")
    save(:validate => false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token = nil
    save(:validate => false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    #u = find_by_uername() :first, :conditions => ['username = ? and activated_at IS NOT NULL', username]
	#u = find.where(['username = ? and activated_at IS NOT NULL', username])
	logger.debug "username asdasdasasdsd"
	logger.debug username
	uu = find :first, :conditions => ['username = ? and activated_at IS NOT NULL', username]
	logger.debug "uu.activated_at.nil"
	logger.debug uu.activated_at.nil?
	uu.activated_at.nil? 
	
	#.where('activated_at IS NOT NULL')
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token = nil
    save(:validate => false)
  end

  #reset methods
  def create_reset_code(which)
    @reset = true
    self.attributes = {:reset_code => Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )}
    if which == 'password'
      @reset_password = true
    else
      @get_username = true
    end
    save(:validate => false)
  end

  def recently_reset?
    @reset
  end

  def recently_password_reset?
    @reset_password
  end

  def recently_username_get?
    @get_username
  end
  
  def delete_reset_code
    self.attributes = {:reset_code => nil}
    save(:validate => false)
  end
  
  private
    def create_remember_token
       self.remember_token = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )  
	  ##  think was throwing error: SecureRandom.urlsafe_base64
    end

  protected
  # before filter
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{username}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def password_match
    self.password == self.password_confirmation
	
	
  end
  
  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def make_reset_code
    self.reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
  
    def get_random
    length = 40
    characters = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
    @id = SecureRandom.random_bytes(length).each_char.map do |char|
      characters[(char.ord % characters.length)]
    end.join
    @id
  end

end