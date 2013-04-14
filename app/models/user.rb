
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :surname,
                  :birthday, :gender, :address, :city, :postalcode

  has_many :tickets
  has_many :buses

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  postal_regex = /\d\d-\d\d\d/

  validates :name,      :presence   => true,
                        :length     => { :maximum => 50 }

  validates :email,     :presence   => true,
                        :format     => { :with => email_regex },
                        :uniqueness => { :case_sensitive => false }

  validates :password,  :presence   => true,
                        :confirmation => true,
                        :length      => {:within => 6..40}

  validates :surname,   :presence   => true,
                        :length     => { :maximum => 50 }

  validates :postalcode,:length     => { :is => 6 },
                        :format     => { :with => postal_regex, :message => "should be in format xx-xxx, where x is digit"}

  before_save :encrypt_password

  # Return true if the user`s password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of submitted_password.
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def self.users_gender_stats
    stats = Array.new
    stats.push(Array.new(['Females',User.where(:gender => false).count]))
    stats.push(Array.new(['Males',User.where(:gender => true).count]))
    return stats
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end




# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#  surname            :string(255)
#  birthday           :date
#  gender             :boolean
#  address            :string(255)
#  city               :string(255)
#  postalcode         :string(255)
#  driver             :boolean         default(FALSE)
#

