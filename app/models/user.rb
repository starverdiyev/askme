require "openssl"

class User < ApplicationRecord
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new

  has_many :questions

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true

  attr_accessor :password

  validates :password, presence: true, on: :create
  validates :password, confirmation: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, length: { maximum: 40 }
  validates :username, format: { with: /\A\w+\z/}

  before_save :encrypt_password
  before_validation :downcase_for_login

  def self.authenticate(email, password)
    user = find_by(email: email&.downcase)

    return unless user.present?

    password_hash =
      User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )

    return unless user.password_hash == password_hash

    user
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack("H*")[0]
  end

  def downcase_for_login
    username&.downcase!
    email&.downcase!
  end

  def encrypt_password
    if password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )
    end
  end
end
