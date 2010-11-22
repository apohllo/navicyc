require 'strscan'
PATH = ARGV[0]
language = Language.find_by_name("SubL Research")
if language.nil?
  language = Language.create(:name => "SubL Research",
                :description => "SubL documentation for ResearchCyc",
                :url => "http://research.cyc.com")
  ("A".."Z").each{|l| Category.create(:name => l, :language_id => language)}
end

GLOBAL_RE = /<td.*top>([^<]*)<.*\/globals\/[^>]*>([^<]*)</
METHOD_RE = /<table.*top>(.*)<a .*\/methods\/[^>]*>([^<]*)<.*><code>/

File.open(PATH + "module-index.html") do |file|
  file.each.with_index do |line,index|
    if matched = line.match(/<a href="(modules\/[^"]*)">([^<]*)/)
      path = matched[1]
      module_name = matched[2]
      puts "Module: #{module_name}"
      super_category = Category.find_by_name(module_name[0].upcase)
      category = Category.create(:name => module_name, :language_id => language.id,
                                :parent_id => super_category.id)
      File.open(PATH + "/" + path) do |sub_file|
        state = nil
        comment = ""
        function = nil
        scanner = StringScanner.new(sub_file.readlines.join(""))
        until scanner.eos?
          case state
          when nil
            case
            when (text = scanner.scan(/<pre>/))
              state = :pre_open
              comment = ""
            when (text = scanner.scan(GLOBAL_RE))
              matched = text.match(GLOBAL_RE)
              type = matched[1]
              name = matched[2]
              puts "Global: #{type} #{name}"
              function = Function.create(:name => name, :kind => type, :category_id => category.id,
                                         :language_id => language.id)
            when (text = scanner.scan(METHOD_RE))
              matched = text.match(METHOD_RE)
              name = matched[2]
              matched = matched[1].match(/<small>(.*)<\/small>/)
              type = matched && matched[1] || "function"
              puts "Function: #{type} #{name}"
              state = :code_open
              comment = ""
              function = Function.create(:name => name, :kind => type, :category_id => category.id,
                                         :language_id => language.id)
            when (text = scanner.scan(/.|\n/))
              #print text
            end
          when :pre_open
            case
            when scanner.scan(/<\/pre>/)
              state = nil
              puts ">>>>#{comment}"
              function.update_attribute(:documentation,comment) unless function.nil?
            when text = scanner.scan(/.|\n/)
              comment << text
            end
          when :code_open
            case
            when scanner.scan(/<\/code>/)
              state = nil
              puts "  " + comment
              function.update_attribute(:arguments,comment) unless function.nil?
            when text = scanner.scan(/.|\n/)
              comment << text
            end
          end
        end #until
        next
      end
    end
    break if index > 10
  end
end
