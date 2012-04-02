class BookChapter < ActiveRecord::Base
  unloadable # <= That's the ticket!
  belongs_to :book

  validates_presence_of :book, :wiki_page_title
  validates_length_of :wiki_page_title, :maximum => 255

  acts_as_event :title => :wiki_page_title,
                :url => Proc.new {|o| {:controller => 'book_chapters', :action => 'show', :id => o.id, :wiki_page_title => o.wiki_page_title}}

  acts_as_activity_provider :type => 'books',
                            :permission => :view_books,
                            :find_options => {:select => "#{BookChapter.table_name}.*",
                                              :joins => "LEFT JOIN #{Book.table_name} ON #{Book.table_name}.id = #{BookChapter.table_name}.book_id " +
                                                        "LEFT JOIN #{Project.table_name} ON #{Book.table_name}.project_id = #{Project.table_name}.id"}

  def project
    book.project
  end

  def visible?(user=User.current)
    book.book_chapters_visible?(user)
  end

  def deletable?(user=User.current)
    book.book_chapters_deletable?(user)
  end
  
  def wiki_page
    print "\n++++ Buscamos la pagina wiki\n"
    if project.wiki && !wiki_page_title.blank?
      print "\n++++ Buscamos la pagina wiki 2\n"+wiki_page_title
      title = book.prefix.blank? ? wiki_page_title : book.prefix + wiki_page_title
      @wiki_page ||= project.wiki.find_page(title)
    end
    print "\n++++ Buscamos la pagina wiki 3\n"+@wiki_page.to_s+"\n"
    @wiki_page
  end
end
