require 'helper'

class AboutActiveRecord < Test::Unit::TestCase

  context "Given a Library and some books" do
    setup do
      @library = Library.new(:name => "New York Public Library")

      # Add some books
      @war_peace = Book.new(:title => "War & Peace", :isbn => "9780690011081", 
        :genre => "Historical fiction")
      @doctor_zhivago = Book.new(:title => "Doctor Zhivago", 
        :isbn => "9780394607863", :genre => "Historial romance")
      @life_fate = Book.new(:title => "Life and Fate", :isbn => "9780060913847",
        :genre => "Historical fiction")
      @library.books << @war_peace
      @library.books << @doctor_zhivago
      @library.books << @life_fate

      @library.save!
      @library.reload
      @war_peace.reload
      @doctor_zhivago.reload
    end

    context "the library" do
      should "have many books" do
        assert_equal true, @library.respond_to?(:books)
        assert_equal 3, @library.books.length
        assert_equal Book, @library.books.first.class
        assert_equal false, @library.respond_to?(:book_id)
        assert_equal false, @library.respond_to?(:library_id)
        assert_equal @library, @library.books.first.library
      end

      should "know how many books are Historical fiction" do
        results = @library.books.where(:genre => "Historical fiction")
        assert_equal 2, results.length
        assert_equal Book, results.first.class
      end
    end

    context "War and Peace" do
      should "have many pages" do
      end
    end
  end

end