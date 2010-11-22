class SymbolController < ApplicationController
  def show
    @symbol = CycSymbol.new(params[:name])
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
    #cyc.debug = true
    @symbol = CycSymbol.new(params[:id])
    case params[:type]
    when "general"
      redirect_to :action => "show", :name => params[:id] and return
    when "arg"
      index = params[:index]
      render :json => (@symbol.gaf_index(index).map do |relation,count|
        {:text => index_title(relation,count), :type => "relation",
          :index => index, :relation => relation.to_cyc(true)}
      end)
    when "relation"
      index = params[:index]
      relation = params[:relation]
      render :json => (@symbol.gaf_index(index,relation).map do |mt,count|
        {:text => index_title(mt,count), :type => "relation",
          :index => index, :relation => relation.to_cyc(true), 
          :mt => mt.to_cyc(true), :leaf => true}
      end)
    when "extent"
      render :json => (@symbol.extent_index.map do |mt,count|
        {:text => index_title(mt,count), :type => "extent_in_mt",
          :mt => mt.to_cyc(true), :leaf => true}
      end)
    else
      indices = @symbol.gaf_index
      tree = [ {:text => "General info", :type => "general", :leaf => true} ] +
        indices.map{|i,count| {:text => "Arg #{i} : #{count}",
        :type => "arg", :index => i}}
      if @symbol.relation?
        tree.concat([{:text => "Predicate Extent", :type => "extent"}])
      end
      render :json => tree
    end
  end

  def assertions
    @symbol = CycSymbol.new(params[:id])
    mt = params[:mt]
    mt = nil if mt.empty?
    relation = params[:relation]
    relation = nil if relation.empty?
    case params[:type]
    when "general"
      redirect_to :action => "show", :name => params[:id]
      return
    when "extent","extent_in_mt"
      @assertions = @symbol.extent_tree(mt)
    else
      index = params[:index].to_i
      @assertions = @symbol.assertions_tree(index,relation,mt)
    end
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

  protected
  def index_title(index,count)
    index = index.to_cyc(true).to_s.gsub(/['#\$]/,"")
    if count && count.to_i > 1
      "#{index} : #{count}"
    else
      index
    end
  end
end
