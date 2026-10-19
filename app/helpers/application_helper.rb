module ApplicationHelper
  def markdown(text)
    Commonmarker.to_html(text).html_safe
  end
end
