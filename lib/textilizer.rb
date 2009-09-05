class Textilizer
  include ActionView::Helpers::TextHelper, ActionView::Helpers::TagHelper
  
  def initialize(text, options = {})
    @filter_markup = options[:filter_markup] || false
    @allow_code = options[:allow_code] || false
    @text = text
  end
  
  def to_html
    auto_link(RedCloth.new(formatted_text, restrictions).to_html)
  end
  
  private
  def formatted_text
    @allow_code ? @text.gsub(/^@@@ ?(\w*)\r?\n(.+?)\r?\n@@@\r?$/m) do |match|
      lang = $1.empty? ? nil : $1
      "\n<notextile>" + CodeRay.scan($2, lang).div(:css => :class) + "</notextile>"
    end : @text
  end
  
  def restrictions
    @filter_markup ? [ :filter_html, :filter_classes, :filter_ids, :filter_styles ] : []
  end
end
