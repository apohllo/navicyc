class SearchController < ApplicationController
  ACCEPTED_TYPES = %w{symbol api ckan dbpedia}

  def cyc_symbol_show
    @symbol = CycSymbol.new(params[:name])
    render :action => "symbol/show"
  end

  def dbpedia_complete
    sparql[:dbpedia] ||= SPARQL::Client.new("http://dbpedia.org/sparql")
    result = sparql[:dbpedia].
      query("select ?subject where {?subject rdfs:label \"#{params[:query]}\"}")
    result = result.map do |solution|
      url = solution.subject.to_s
      {:name => url[url.rindex("/")+1..-1], :type => "dbpedia", :id => url}
    end
    render :json => {:success => true, :data => result}
  end

  # XXX
  # The proper solution:
  # - each type of elements should have its own controller, with
  # actions. The controller should be set in the JS code. ???
  def complete
    if ACCEPTED_TYPES.include?(params[:type])
      redirect_to params.merge({:controller => params.delete(:type),
                               :action => "complete"})
    end
  end

  def show
    if ACCEPTED_TYPES.include?(params[:type])
      redirect_to params.merge({:controller => params.delete(:type),
                               :action => "show"})
    end
  end
end
