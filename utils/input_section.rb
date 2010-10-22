#require 'config/environment'

#sections = (2..8)
sections = (0..85)
language = Language.find_by_name(ARGV[1])
category = nil
super_category = nil
function = nil
link = nil
sections.each do |section|
  libs = 0
  functions = 0
  docs = 0
  File.open(ARGV[0] + "section-#{section}.html") do |file|
    file.each do |line|
      case line
      when /www\.supelec\.fr./
        link = line.chomp
        unless link =~ /<\/a>/
          link += "CLtL</a>"
        end
        #puts link
      when /<h(1|2|3)>([^<]*)<\/h(1|2|3)>/
        function.save! unless function.nil?
        function = nil
        header_level = $1
        cat_name = $2.sub(/^[0-9.]+( :)?/,"").strip
        # supercategory
        if header_level == "1"
          super_category = Category.create(:name => cat_name, :language_id => language.id)
          category = nil
        else
          if super_category.nil?
            category = Category.create(:name => cat_name, :language_id => language.id)
          else
            category = Category.create(:name => cat_name, :language_id => language.id,
                                       :parent_id => super_category.id)
          end
        end
        libs += 1
      when /(SYM|FN)-DEF.*\/a>(\w+) (<tt>)?(<b>)?([^<]+)(<\/b>)?( : ([^<]*))?(<\/tt>)?/
        function.save! unless function.nil?
        if category || super_category
          function = Function.new(:name => $5,
            :category_id => (category || super_category).id, :language_id => language.id,
            :arguments => $8)
          function.kind = $2
          function.documentation = ""
          function.documentation += link unless link.nil?
        end
        #puts "FUNCTION: #{$2} #{link} #{$5} #{$8}"
        functions += 1
      else
        line = line.gsub(/<[^>]*>/,"").strip
        if not line.empty? and not function.nil?
          function.documentation += " #{line} "
          docs += 1
        end
      end
    end
  end
  #puts "#{section}: #{libs} #{functions} #{docs} #{sprintf("%.5s",docs/functions.to_f)}"
end
Category.find(:all).each{|c| c.destroy if c.children.empty? && c.functions.empty?}
