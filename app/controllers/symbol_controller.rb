class SymbolController < ApplicationController
  def show
    @symbol = CycSymbol.new(params[:name].to_sym)
  end

  def show_denotation
    @name = params[:name]
    denotaion = cyc.denotation_mapper params[:name]
    if denotaion != nil
      @symbol = CycSymbol.new((cyc.denotation_mapper params[:name])[0])
    end
    render :action => "show"
  end

  def assertion_tree
    @symbol = CycSymbol.new(params[:id].to_sym)
    case params[:type]
    when "general"
      redirect_to :action => "show", :name => params[:id]
    when "arg"
      index = params[:index].to_i
      relations = @symbol.key_gaf_arg_index(index)
      render :json => relations.sort_by{|r| r.to_s}.
        map{|r| {:text => r, :type => "relation", :index => index, :relation => r}}
    when "relation"
      index = params[:index].to_i
      relation = params[:relation]
      mts = @symbol.key_gaf_arg_index(index,relation.to_sym)
      render :json => mts.sort_by{|m| m.to_s}.
        map{|mt| {:text => mt, :type => "microtheory", :index => index, 
          :relation => relation, :mt => mt, :leaf => true, :cls => "folder"}}
    else
      indices = @symbol.key_gaf_arg_index
      render :json => [
        {:text => "General info", :type => "general", :leaf => true}
      ] + indices.sort.map{|i| {:text => "Arg #{i}", :type => "arg", :index => i}}
    end
  end

  def assertions
    @symbol = CycSymbol.new(params[:id].to_sym)
    index = params[:index].to_i
    relation = params[:relation]
    relation = nil if relation.empty?
    mt = params[:mt]
    mt = nil if mt.empty?
    @assertions = @symbol.assertions_tree(index,relation,mt)
  end

  def complete
    completes = cyc.constant_complete params[:query]

    if completes
      completes_map = completes.collect { |complete|
        {:name => complete}
      }
    else
      completes_map = []
    end

    render :json => {:success => true,
                     :data => completes_map
    }
  end
end
