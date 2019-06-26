module ApplicationHelper

  # Returns the full title on per page basis
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    return "#{page_title} | #{base_title}" unless page_title.empty?
    base_title
  end
end
