module SymbolHelper
  def format_assertion(assertion,symbol)
    "(#{format_all_genls(assertion.formula)})"
  end

  def format_comment(comment)
    if comment
      comment.to_s.gsub(/#\$[\w|-]+,?/) do |symbol|
        link_to symbol[2..-1].sub(/,$/,""),"#", :class => "symbol"
      end
    else
      ""
    end
  end

  def format_all_genls(generalize_arr)
    generalize_arr ||= []
    return_string = ''
    generalize_processor = lambda { |curr_generalize_arr|
      curr_generalize_arr.each do |generalize|
        if generalize.is_a? Array
          return_string += '<div class="symbolscollection">'
          generalize_processor.call(generalize)
          return_string += '</div>'
        else
          if generalize.is_a?(Symbol)
            return_string += link_to("#{generalize} ", "#", :class => "symbol")
          else
            return_string += format_comment(generalize)
          end
        end
      end
    }
    generalize_processor.call(generalize_arr)
    return_string
  end

  def format_caption(symbol)
    ": #{@symbol.kind}"
  end

  def argument_title(index)
    aux =
      if index == "1"
        "(domain) "
      elsif index == "2"
        "(range) "
      end

    "#{index} argument #{aux}type "
  end

end
