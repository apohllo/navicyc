class SymbolController < ApplicationController
  def show_denotation
    @name = params[:name]
    denotaion = cyc.denotation_mapper params[:name]
    if denotaion != nil
      @symbol = CycSymbol.new((cyc.denotation_mapper params[:name])[0])
    end
    render :action => "show"
  end

  def tree
    #cyc.debug = false
    @symbol = CycSymbol.new(params[:id])
    case params[:level]
    when "general"
      redirect_to :action => "show", :name => params[:id] and return
    when "arg"
      index = params[:index]
      render :json => (@symbol.gaf_index(index).map do |relation,count|
        {:text => index_title(relation,count), :level => "relation",
          :index => index, :relation => relation.to_cyc(true), :source => "symbol"}
      end)
    when "relation"
      index = params[:index]
      relation = params[:relation]
      render :json => (@symbol.gaf_index(index,relation).map do |mt,count|
        {:text => index_title(mt,count), :level => "relation",
          :index => index, :relation => relation,
          :mt => mt.to_cyc(true), :leaf => true, :source => "symbol"}
      end)
    when "extent"
      render :json => (@symbol.extent_index.map do |mt,count|
        {:text => index_title(mt,count), :level => "extent_in_mt",
          :mt => mt.to_cyc(true), :leaf => true}
      end)
    else
      indices = @symbol.gaf_index
      tree = [ {:text => "General info", :level => "general", :leaf => true,
        :source => "symbol"} ] + indices.map{|i,count| {:text => "Arg #{i} : #{count}",
        :level => "arg", :index => i, :source => "symbol"}}
      if @symbol.relation?
        tree.concat([{:text => "Predicate Extent", :level => "extent"}])
      end
      render :json => tree
    end
  end

  def show
    @symbol = CycSymbol.new(params[:id])
    mt = params[:mt]
    mt = nil if mt.blank?
    relation = params[:relation]
    relation = nil if relation.blank?
    case params[:level]
    when "general"
      redirect_to :action => "show", :name => params[:id]
      return
    when "extent","extent_in_mt"
      @assertions = @symbol.extent_tree(mt)
    when nil
      @symbol = CycSymbol.new(params[:name])
      render :action => "description"
    else
      index = params[:index].to_i
      @assertions = @symbol.assertions_tree(index,relation,mt)
    end
  end

  def complete
    symbols = cyc.constant_complete(params[:query])
    symbols = symbols.map do |symbol|
      {:name => symbol, :source => "symbol", :id => symbol}
    end
    render :json => {:success => true, :data => symbols}
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
