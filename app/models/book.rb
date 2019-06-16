class Book < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  belongs_to :author, counter_cache: :books_count
  belongs_to :category, counter_cache: :books_count
  belongs_to :language, counter_cache: :books_count
  has_many :units, dependent: :destroy
  has_many :estimates, dependent: :destroy
  has_many :users, through: :estimates


  validates :title, presence: true
  validates :year, presence: true
  validates :description, presence: true
  validates :year, numericality: {only_integer: true,
                                  greater_than: 1000,
                                  less_than: Time.current.year + 1}

  include Filterable

  scope :by_title, ->(by_title) {where(arel_table[:title].matches("%#{by_title}%"))}
  scope :by_language_ids, ->(by_language_ids) {where(arel_table[:language_id].in(by_language_ids))}
  scope :by_authors_ids, ->(by_authors_ids) {where(arel_table[:author_id].in(by_authors_ids))}
  scope :by_year, ->(by_year) {where(arel_table[:year].eq(by_year))}
  scope :by_history, ->(by_history) {where(arel_table[:in_history].eq(by_history))}
  scope :by_category_ids, ->(by_category_ids) do
    joins(:category).where(categories: {id: by_category_ids})
  end
  scope :by_category_title, ->(category_title) do
    joins(:category).where(categories: {title: category_title})
  end
  scope :by_author_name, ->(author_name) do
    joins(:author).where(authors: {name: author_name})
  end
  scope :by_title_or_name_for_author, ->(filtre_atribut) do
    author = Author.arel_table
    book = Book.arel_table
    joins(:author).where((author[:name].matches("%#{filtre_atribut}%")).or(book[:title].matches("%#{filtre_atribut}%")))
  end
end
