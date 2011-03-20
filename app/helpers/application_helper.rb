# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def markdown(str)
    BlueCloth.new(str).to_html
  end
end
