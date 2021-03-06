module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "chucktwit"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  # Return the logo
  def logo
	return image_tag("logo.png", :alt => "Sample App", :class => "round")
  end
  
end
