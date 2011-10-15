module ApplicationHelper
  # Return a title on a per-page basis.
  def title
    base_title = "Bus Company Support"
    if @title.nil?
      base_title
    else
      base_title + " | " + @title
    end
  end

  def logo
    return logo = image_tag("logo.png", :alt => "Logo", :class => "round")
  end
end

