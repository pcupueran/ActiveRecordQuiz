require_relative 'helper'

class AboutActiveRecord < MiniTest::Test

  describe "Given a Library and some books, " do
    before do
      @library = Library.new(:name => "New York Public Library")

      # Add some books
      @war_peace = Book.new(:title => "War & Peace", :isbn => "9780690011081",
        :genre => "Historical fiction", :cover => Cover.new)
      # Obviously, there are more than this...
      10.times do |i|
        @war_peace.pages << Page.new(:number => i + 1)
      end
      @leo = Author.new(:name => "Leo Tolstoy")
      @war_peace.author_books << AuthorBook.new(:author => @leo)

      @doctor_zhivago = Book.new(:title => "Doctor Zhivago", :cover => Cover.new,
        :isbn => "9780394607863", :genre => "Historial romance")
      7.times do |i|
        @doctor_zhivago.pages << Page.new(:number => i + 1)
      end
      @boris = Author.new(:name => "Boris Pasternaks")
      @doctor_zhivago.author_books << AuthorBook.new(:author => @boris)

      @life_fate = Book.new(:title => "Life and Fate", :isbn => "9780060913847",
        :genre => "Historical fiction", :cover => Cover.new)
      3.times do |i|
        @life_fate.pages << Page.new(:number => i + 1)
      end
      @vasily = Author.new(:name => "Vasily Grossman")
      @life_fate.author_books << AuthorBook.new(:author => @vasily)

      @library.books << @war_peace
      @library.books << @doctor_zhivago
      @library.books << @life_fate

      @library.save!

      @library.reload
      @war_peace.reload
      @leo.reload
    end

    describe "in total" do
      it "should have the right number of models" do
        assert_equal 1, Library.count
        assert_equal 3, Book.count
        assert_equal 20, Page.count
        assert_equal 3, Cover.count
        assert_equal 3, AuthorBook.count
        assert_equal 3, Author.count
      end
    end

    describe "the library" do
      it "should have many books" do
        assert_equal true, @library.respond_to?(:books)
        assert_equal 3, @library.books.length
        assert_equal Book, @library.books.first.class
        assert_equal false, @library.respond_to?(:book_id)
        assert_equal false, @library.respond_to?(:library_id)
        assert_equal @library, @library.books.first.library
      end

      it "should know how many books are Historical fiction" do
        results = @library.books.where(:genre => "Historical fiction")
        assert_equal 2, results.length
        assert_equal Book, results.first.class
        assert_equal Book::ActiveRecord_AssociationRelation, results.class
      end

      it "should know how many books have at least 7 pages" do
        results = @library.books.joins(:pages).where('pages.number >= 7').uniq
        assert_equal 2, results.length
        assert_equal Book, results.first.class
        assert_equal Book::ActiveRecord_AssociationRelation, results.class
      end

    end

    describe "Leo Tolstoy" do
      it "should have written many pages" do
        assert_equal true, @leo.respond_to?(:pages)
        assert_equal 10, @leo.pages.length
        assert_equal Page, @leo.pages.first.class
      end

      it "should be searchable by name" do
        assert_equal Author, Author.find_by_name("Leo Tolstoy").class
        assert_equal @leo, Author.find_by_name("Leo Tolstoy")
        assert_equal Author::ActiveRecord_Relation, Author.where(:name => "Leo Tolstoy").class
        assert_equal @leo, Author.where(:name => "Leo Tolstoy").first
        assert_equal @leo, Author.first
      end
    end

    describe "War and Peace" do
      it "should have one cover" do
        assert_equal false, @war_peace.respond_to?(:covers)
        assert_equal true, @war_peace.respond_to?(:cover)
        assert_equal Cover, @war_peace.cover.class
        assert_equal @war_peace, @war_peace.cover.book
        assert_equal false, @war_peace.respond_to?(:book_id)
        assert_equal false, @war_peace.respond_to?(:cover_id)
        assert_equal true, @war_peace.cover.respond_to?(:book_id)
        assert_equal false, @war_peace.cover.respond_to?(:cover_id)
      end

      it "should have many pages" do
        assert_equal true, @war_peace.respond_to?(:pages)
        assert_equal 10, @war_peace.pages.length
        assert_equal Page, @war_peace.pages.first.class
        assert_equal 1, @war_peace.pages.first.number
        assert_equal @war_peace, @war_peace.pages.first.book
        assert_equal false, @war_peace.respond_to?(:page_id)
        assert_equal true, @war_peace.pages.first.respond_to?(:book_id)
        assert_equal false, @war_peace.pages.first.respond_to?(:page_id)
      end

      it "should have many authors" do
        assert_equal true, @war_peace.respond_to?(:authors)
        assert_equal true, @war_peace.respond_to?(:author_books)
        assert_equal Author::ActiveRecord_Associations_CollectionProxy, @war_peace.authors.class
        assert_equal 1, @war_peace.authors.length
        assert_equal "Leo Tolstoy", @war_peace.authors.first.name
        assert_equal false, @war_peace.respond_to?(:author_id)
        assert_equal false, @war_peace.respond_to?(:author_book_id)
        assert_equal false, @war_peace.authors.first.respond_to?(:book_id)
        assert_equal true, @war_peace.author_books.first.respond_to?(:book_id)
        assert_equal true, @war_peace.author_books.first.respond_to?(:author_id)
        assert_equal "SELECT 'author_books'.* FROM 'author_books' WHERE 'author_books'.'book_id' = 1", @war_peace.author_books.to_sql.chomp.gsub("\"", "'").squeeze(" ")
        assert_equal "SELECT 'authors'.* FROM 'authors' INNER JOIN 'author_books' ON 'authors'.'id' = 'author_books'.'author_id' WHERE 'author_books'.'book_id' = 1", @war_peace.authors.to_sql.chomp.gsub("\"", "'").squeeze(" ")
      end

      it "should be searchable by name" do
        assert_equal Book, Book.find_by(:title => "War & Peace").class
        assert_equal Book::ActiveRecord_Relation, Book.where(:title => "War & Peace").class
        assert_equal "SELECT 'books'.* FROM 'books' WHERE 'books'.'title' = 'War & Peace'", Book.where(:title => "War & Peace").to_sql.chomp.gsub("\"", "'").squeeze(" ")
      end
    end

  end

end
