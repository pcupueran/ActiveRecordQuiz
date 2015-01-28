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
        assert_equal ___, Library.count
        assert_equal ___, Book.count
        assert_equal ___, Page.count
        assert_equal ___, Cover.count
        assert_equal ___, AuthorBook.count
        assert_equal ___, Author.count
      end
    end

    describe "the library" do
      it "should have many books" do
        assert_equal ___, @library.respond_to?(:books)
        assert_equal ___, @library.books.length
        assert_equal ___, @library.books.first.class
        assert_equal ___, @library.respond_to?(:book_id)
        assert_equal ___, @library.respond_to?(:library_id)
        assert_equal ___, @library.books.first.library
      end

      it "should know how many books are Historical fiction" do
        results = @library.books.where(:genre => "Historical fiction")
        assert_equal ___, results.length
        assert_equal ___, results.first.class
        assert_equal ___, results
      end

      it "should know how many books have at least 7 pages" do
        results = @library.books.includes(:pages).where('pages.number >= 7')
        assert_equal ___, results.length
        assert_equal ___, results.first.class
        assert_equal ___, results
      end
    end

    describe "Leo Tolstoy" do
      it "should have written many pages" do
        assert_equal ___, @leo.respond_to?(:pages)
        assert_equal ___, @leo.pages.length
        assert_equal ___, @leo.pages.first.class
      end

      it "should be searchable by name" do
        assert_equal ___, Author.find_by_name("Leo Tolstoy").class
        assert_equal ___, Author.find_by_name("Leo Tolstoy")
        assert_equal ___, Author.where(:name => "Leo Tolstoy").class
        assert_equal ___, Author.where(:name => "Leo Tolstoy").first
        assert_equal ___, Author.first
      end
    end

    describe "War and Peace" do
      it "should have one cover" do
        assert_equal ___, @war_peace.respond_to?(:covers)
        assert_equal ___, @war_peace.respond_to?(:cover)
        assert_equal ___, @war_peace.cover.class
        assert_equal ___, @war_peace.cover.book
        assert_equal ___, @war_peace.respond_to?(:book_id)
        assert_equal ___, @war_peace.respond_to?(:cover_id)
        assert_equal ___, @war_peace.cover.respond_to?(:book_id)
        assert_equal ___, @war_peace.cover.respond_to?(:cover_id)
      end

      it "should have many pages" do
        assert_equal ___, @war_peace.respond_to?(:pages)
        assert_equal ___, @war_peace.pages.length
        assert_equal ___, @war_peace.pages.first.class
        assert_equal ___, @war_peace.pages.first.number
        assert_equal ___, @war_peace.pages.first.book
        assert_equal ___, @war_peace.respond_to?(:page_id)
        assert_equal ___, @war_peace.pages.first.respond_to?(:book_id)
        assert_equal ___, @war_peace.pages.first.respond_to?(:page_id)
      end

      it "should have many authors" do
        assert_equal ___, @war_peace.respond_to?(:authors)
        assert_equal ___, @war_peace.respond_to?(:author_books)
        assert_equal ___, @war_peace.authors.class
        assert_equal ___, @war_peace.authors.length
        assert_equal ___, @war_peace.authors.first.name
        assert_equal ___, @war_peace.respond_to?(:author_id)
        assert_equal ___, @war_peace.respond_to?(:author_book_id)
        assert_equal ___, @war_peace.authors.first.respond_to?(:book_id)
        assert_equal ___, @war_peace.author_books.first.respond_to?(:book_id)
        assert_equal ___, @war_peace.author_books.first.respond_to?(:author_id)
        assert_equal ___, @war_peace.author_books.to_sql.chomp.gsub("\"", "'").squeeze(" ")
        assert_equal ___, @war_peace.authors.to_sql.chomp.gsub("\"", "'").squeeze(" ")
      end

      it "should be searchable by name" do
        assert_equal ___, Book.where(:title => "War & Peace").class
        assert_equal ___, Book.where(:title => "War & Peace").to_sql.chomp.gsub("\"", "'").squeeze(" ")
      end
    end

  end

end