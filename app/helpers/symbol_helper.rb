module SymbolHelper
  def format_comment(comment)
    if comment
      comment.gsub(/\\"/,'"').gsub(/#\$[\w|-]+/) do |symbol|
        link_to symbol[2..-1],"#"
      end
    else
      ""
    end
  end

  def format_all_genls(generalize_arr)
    return_string = ''
    generalize_processor = lambda { |curr_generalize_arr|
      curr_generalize_arr.each do |generalize|
        if generalize.is_a? Array
          return_string += '<div class="symbolscollection">'
          generalize_processor.call(generalize)
          return_string += '</div>'
        else
          return_string += "<a href=\"#\">#{generalize}</a> "
        end
      end
    }
    generalize_processor.call(generalize_arr)
    return_string
  end
end
