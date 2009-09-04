# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def textilize(text, options = {})
    Textilizer.new(text, options).to_html unless text.blank?
  end
end
