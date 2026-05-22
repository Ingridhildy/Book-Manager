module BooksHelper
  def status_badge(book)
    css_class = case book.status
                when "want_to_read" then "badge bg-secondary"
                when "reading"      then "badge bg-warning text-dark"
                when "read"         then "badge bg-success"
                else "badge bg-light text-dark"
                end
    label = { "want_to_read" => "Хочу прочитати", "reading" => "Читаю", "read" => "Прочитано" }[book.status] || book.status
    content_tag(:span, label, class: css_class)
  end
end
