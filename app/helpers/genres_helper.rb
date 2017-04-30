module GenresHelper
  def change_a_field(id)
    capture_haml do
      if id =~ /\A[^aeiou]/
        haml_concat  link_to "Change a #{id.gsub(/_/, ' ')}", "#", class: "hide_field", id: "#{id}"
      else
        haml_concat  link_to "Change an #{id.gsub(/_/, ' ')}", "#", class: "hide_field", id: "#{id}"
      end
    end
  end
end
