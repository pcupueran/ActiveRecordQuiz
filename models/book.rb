class Book < ActiveRecord::Base
  belongs_to :library
  has_many :pages
  has_many :author_books
  has_many :authors, :through => :author_books
  has_one :cover
end
