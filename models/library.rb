class Library < ActiveRecord::Base
  has_many :books
  has_many :pages, :through => :books
end
