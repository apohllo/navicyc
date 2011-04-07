require 'base64'

class SparqlController < ApplicationController
  helper_method :url_extract_name

  def complete
    result = endpoint.search(params[:query]).map do |url|
      {:name => url_extract_name(url), :source => "sparql",
        :id => Base64.urlsafe_encode64(url)}
    end
    render :json => {:success => true, :data => result}
  end

  def show
    id = Base64.urlsafe_decode64(params[:id])
    case params[:level]
    when "arg"
      index = params[:index].to_i
      @assertions = endpoint.assertions(id,index)
    when "relation"
      index = params[:index].to_i
      relation = params[:relation]
      @assertions = endpoint.assertions(id,index,relation)
    else
      render :text => id
    end
  end

  def tree
    id = Base64.urlsafe_decode64(params[:id])
    case params[:level]
    when "general"
      render :text => id
    when "arg"
      index = params[:index].to_i
      render :json => endpoint.predicates(id,index).map{|p|
        {:text => "#{url_extract_name(p)} : #{endpoint.assertions_count(id,index,p)}",
          :index => index, :relation => p, :source => "sparql", :leaf => true,
            :level => "relation"}}
    else
      indices = [1,2].map{|i| [i,endpoint.predicates_count(id,i)]}
      tree = [ {:text => "General info", :level => "general", :source => "sparql",
        :leaf => true}] +
        indices.map{|i,count| {:text => "Arg #{i} : #{count}",
          :source => "sparql", :level => "arg", :index => i}}
      render :json => tree
    end
  end

  protected
  def endpoint
    sparql[:dbpedia] ||= Sparql.new("http://dbpedia.org/sparql")
    #sparql[:dbpedia] ||= SPARQL::Client.new("http://localhost:8080/sparql")
    #sparql[:umbel] ||= SPARQL::Client.new("http://localhost:8080/sparql")
    #sparql[:umbel] = Sparql.new("http://localhost:8080/sparql")
  end

  NAMESPACES = {
    "umbel.org" => "umbel",
    "skos" => "skos",
    "foaf" => "foaf",
    "dbpedia.org/ontology" => "db-ontology",
    "dbpedia.org/resource" => "dbpedia",
    "dbpedia.org/property" => "db-property",
    "rdf-schema" => "rdfs",
    "owl#" => "owl",
    "rdf-syntax" => "rdf",
    "opencyc" => "opencyc",
    "sw.cyc.com" => "cyc",
    "WordNet" => "wn",
    "SUMO" => "sumo"
  }

  def url_extract_name(url)
    namespace = NAMESPACES.find{|k,v| url =~ /#{k}/}
    name = url[url.rindex("/")+1..-1]
    if name =~ /#/
      name = name[name.rindex("#")+1..-1]
    end
    namespace.nil? ? name : "#{namespace[1]}:#{name}"
  end
end
