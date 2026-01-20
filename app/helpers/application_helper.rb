module ApplicationHelper
  # Status badge helper
  def status_badge(status)
    colors = {
      "active" => "bg-green-100 text-green-800",
      "completed" => "bg-blue-100 text-blue-800",
      "paused" => "bg-yellow-100 text-yellow-800"
    }

    content_tag :span, status.humanize, class: "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{colors[status.to_s]}"
  end

  # Role badge helper
  def role_badge(role)
    colors = {
      "user" => "bg-gray-100 text-gray-800",
      "admin" => "bg-purple-100 text-purple-800"
    }

    content_tag :span, role.humanize, class: "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{colors[role.to_s]}"
  end

  # Completion badge helper
  def completion_badge(completed)
    if completed
      content_tag :span, "Completed", class: "inline-flex items-center rounded-full bg-green-100 px-2.5 py-0.5 text-xs font-medium text-green-800"
    else
      content_tag :span, "Pending", class: "inline-flex items-center rounded-full bg-gray-100 px-2.5 py-0.5 text-xs font-medium text-gray-800"
    end
  end

  # Progress bar helper
  def progress_bar(percentage, options = {})
    color = options[:color] || "bg-indigo-600"
    height = options[:height] || "h-2"

    content_tag :div, class: "overflow-hidden rounded-full bg-gray-200 #{height}" do
      content_tag :div, "", class: "#{height} #{color} transition-all duration-300", style: "width: #{[ percentage, 100 ].min}%"
    end
  end

  # Date formatting helpers
  def format_date(date)
    return "N/A" unless date
    date.strftime("%B %d, %Y")
  end

  def format_short_date(date)
    return "N/A" unless date
    date.strftime("%b %d, %Y")
  end

  def format_date_time(datetime)
    return "N/A" unless datetime
    datetime.strftime("%B %d, %Y at %I:%M %p")
  end

  def relative_time(time)
    return "N/A" unless time
    time_ago_in_words(time) + " ago"
  end

  # Streak badge helper
  def streak_badge(streak)
    if streak > 0
      content_tag :span, class: "inline-flex items-center text-orange-500 font-medium" do
        "🔥 #{streak} day#{streak > 1 ? 's' : ''}"
      end
    else
      content_tag :span, "No streak", class: "text-gray-400 text-sm"
    end
  end

  # Streak display helper (simple text)
  def streak_display(streak)
    if streak > 0
      "🔥 #{streak} day streak"
    else
      "No streak"
    end
  end

  # Category badge with color
  def category_badge(category)
    content_tag :span, class: "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium",
                style: "background-color: #{category.color}20; color: #{category.color};" do
      category.name
    end
  end

  # Pagination helper for Pagy
  def pagy_nav(pagy)
    return "" unless pagy.pages > 1

    links = []

    if pagy.prev
      links << link_to("Previous", url_for(page: pagy.prev), class: "relative inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50")
    end

    (1..pagy.pages).each do |page|
      if page == pagy.page
        links << content_tag(:span, page, class: "relative inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white")
      else
        links << link_to(page, url_for(page: page), class: "relative inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50")
      end
    end

    if pagy.next
      links << link_to("Next", url_for(page: pagy.next), class: "relative inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50")
    end

    content_tag :nav, class: "flex items-center justify-center gap-2 mt-6" do
      safe_join(links)
    end
  end
end
