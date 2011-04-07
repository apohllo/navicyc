class SearchController < ApplicationController
  ACCEPTED_SOURCES = %w{symbol api ckan sparql}

  def cyc_symbol_show
    @symbol = CycSymbol.new(params[:name])
    render :action => "symbol/show"
  end

  # XXX
  # The proper solution:
  # - each source of elements should have its own controller, with
  # actions. The controller should be set in the JS code. ???
  def complete
    if ACCEPTED_SOURCES.include?(params[:source])
      redirect_to params.merge({:controller => params.delete(:source),
                               :action => "complete"})
    end
  end

  def show
    if ACCEPTED_SOURCES.include?(params[:source])
      redirect_to params.merge({:controller => params.delete(:source),
                               :action => "show"})
    end
  end

  def tree
    if ACCEPTED_SOURCES.include?(params[:source])
      redirect_to params.merge({:controller => params.delete(:source),
                               :action => "tree"})
    end
  end
end
