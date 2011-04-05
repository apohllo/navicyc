class CycSymbol
  def initialize(symbol)
    @symbol = symbol
    if @symbol.is_a?(String)
      if @symbol[0] == "'"
        @symbol = @symbol.tr("'","")
      elsif @symbol[0] !~ /[#(]/
        @symbol = '#$' + @symbol
      end
      @symbol = cyc_parser.parse(@symbol)
    end
  end

  def comment
    cyc.with_any_mt{|cyc| cyc.comment @symbol}
  end

  def method_missing(name,*rest)
    super if name == :to_ary
    cyc.send(name,@symbol,*rest)
  end

  def to_s
    @symbol.to_s
  end

  def to_cyc(raw=false)
    @symbol.to_cyc(raw)
  end

  def gaf_index(index=nil,relation=nil)
    result =
      if index.nil?
        indices = self.key_gaf_arg_index
        indices.zip(indices.map do |index|
          self.num_gaf_arg_index(index.to_i)
        end)
      else
        index = index.to_i
        if relation.nil?
          relations = self.key_gaf_arg_index(index)
          relations.zip(relations.map do |relation|
            self.num_gaf_arg_index(index,CycSymbol.new(relation)) rescue 0
          end)
        else
          relation = CycSymbol.new(relation)
          mts = self.key_gaf_arg_index(index,relation)
          mts.zip(mts.map do |mt|
            self.num_gaf_arg_index(index,relation,CycSymbol.new(mt))
          end)
        end
      end
    result.sort_by{|e1,e2| e1.to_s}
  end

  def extent_index
    mts = self.key_predicate_extent_index
    result =
      mts.zip(mts.map do |mt|
        self.num_predicate_extent_index(mt)
      end)
    result.sort_by{|e1,e2| e1.to_s}
  end

  def generalizations
    if collection?
      self.min_genls
    elsif relation?
      self.min_genl_predicates
    elsif microtheory?
      self.pred_values_in_any_mt(:genlMt,1,2)
    else
      []
    end
  end

  def specializations
    if collection?
      self.max_specs
    elsif relation?
      self.max_spec_predicates
    elsif microtheory?
      self.pred_values_in_any_mt(:genlMt,2,1)
    else
      []
    end
  end

  def kind
    if relation?
      :relation
    elsif collection?
      :collection
    elsif microtheory?
      :microtheory
    elsif individual?
      :individual
    end
  end

  def arguments
    indices = self.pred_values_in_any_mt(:argIsa, 1, 2) || []
    arguments = self.pred_values_in_any_mt(:argIsa, 1, 3) || []
    arguments.zip(indices).sort_by{|a,i| i}
  end

  def relation?
    cyc.isa?(@symbol,:Relation)
  end

  def collection?
    cyc.isa?(@symbol,:Collection)
  end

  def instance?
    cyc.isa?(@symbol,:Instance)
  end

  def microtheory?
    cyc.isa?(@symbol,:Microtheory)
  end

  def assertions_tree(index,relation,mt)
    result = {}
    if index
      index_tree(index,result,relation,mt)
    else
      index_indices.each do |index|
        index_tree(index,result)
      end
    end
    result
  end

  def extent_tree(mt)
    result = {}
    index_tree = result[0] = {}
    relation_tree = index_tree[self] = {}
    if mt
      relation_extent_tree(mt,relation_tree)
    else
      self.key_predicate_extent_index.each do |mt|
        relation_extent_tree(mt,relation_tree)
      end
    end
    result
  end



  protected
  def index_tree(index,tree,relation=nil,mt=nil)
    subtree = tree[index] = {}
    if relation
      relation_tree(index,relation,subtree,mt)
    else
      relation_indices(index).each do |relation|
        relation_tree(index,relation,subtree)
      end
    end
  end

  def relation_tree(index,relation,tree,mt=nil)
    subtree = tree[relation] = {}
    if mt
      mt_tree(index,relation,mt,subtree)
    else
      mt_indices(index,relation).each do |mt|
        mt_tree(index,relation,mt,subtree)
      end
    end
  end

  def mt_tree(index,relation,mt,tree)
    tree[CycSymbol.new(mt)] = self.
      gather_gaf_arg_index(index, CycSymbol.new(relation), CycSymbol.new(mt))
  end

  def relation_extent_tree(mt,tree)
    tree[mt] = self.gather_predicate_extent_index(CycSymbol.new(mt))
  end

  def mt_indices(index,relation)
    self.key_gaf_arg_index(index,CycSymbol.new(relation))
  end

  def relation_indices(index)
    self.key_gaf_arg_index(index)
  end

  def index_indices
    self.key_gaf_arg_index
  end

  def cyc_parser
    CYC_PARSER
  end

  def cyc
    CYC
  end
end
