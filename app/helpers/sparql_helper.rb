module SparqlHelper
  def link_to_resource(resource)
    if resource =~ /^http:/
      link_to url_extract_name(resource), resource
    else
      resource
    end
  end
end
