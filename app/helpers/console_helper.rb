module ConsoleHelper
  def format_answer(answer)
    escape_once(answer.to_s).gsub(/#\$[\w|-]+,?/) do |symbol|
      "#&#36;" + link_to_symbol(symbol[2..-1])
    end
  end
end
