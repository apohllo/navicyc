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
    if @all_genls == nil
      @all_genls = []
    end
    if @max_specs == nil
      @max_specs = []
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
end
