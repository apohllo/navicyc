
section = 0
out = File.open("section-#{section}.html","w")
File.open("subl.html") do |file|
  file.each do |line|
    if line =~ /<h2>/
      out.close
      section += 1
      out = File.open("section-#{section}.html","w")
    end
    out.print line
  end
end
out.close
