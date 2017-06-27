module AuthorsHelper
  def author_fullname(*names)
    names.join(" ")
  end
end
