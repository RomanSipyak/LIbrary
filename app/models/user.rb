class User < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :bookings, dependent: :nullify
  has_many :estimates, dependent: :destroy
  has_many :books, through: :estimates

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}

  include Filterable
  scope :by_debtor, ->(by_debtor) {where(arel_table[:debtor].eq(by_debtor))}

end