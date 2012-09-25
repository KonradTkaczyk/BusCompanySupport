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

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == params[:sort] ? "current #{params[:direction]}" : nil
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
end

