require 'rubygems' unless Object.const_defined?(:Gem)
require 'syntax/convertors/html'
module ApplicationHelper
  
  # From technoweenie
  # Converts the text for a given language, wrapping it in a <pre> with the language as the class name.
  def convert_syntax(text, lang = :ruby)
    @converters ||= {}
    @converters[lang.to_sym] ||= Syntax::Convertors::HTML.for_syntax(lang.to_s)
    html = CGI::unescapeHTML(text)
    html = @converters[lang.to_sym].convert(html, false).to_a
    html.delete_at(0) if html.size > 0 and html[0].chomp.empty?
    
    %Q{<div class="code"><ol class="#{lang} code">#{html.collect { |line| "<li>#{line.rstrip}</li>" }.join}</ol></div>}
  end

  # From technoweenie
  def syntax(html, language = :ruby)
    begin
      text = convert_syntax(html, language.downcase) 
      text.gsub!(/<!--(.*?)-->[\n]?/m, "")
      return sanitize(text)
    rescue => e
      logger.warn "Exception in syntax() helper: #{e}"
      logger.warn "syntax() was passed language: #{language}"
      logger.warn "syntax() was passed html: #{html}"
    end
  end
end
