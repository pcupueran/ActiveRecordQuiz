class Author < ActiveRecord::Base
  has_many :author_books
  has_many :books, :through => :author_books
  has_many :pages, :through => :books
end
