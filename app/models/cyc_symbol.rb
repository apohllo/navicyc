class CycSymbol
  def initialize(symbol)
    @symbol = symbol
  end

  def method_missing(name,*rest)
    cyc.send(name,@symbol,*rest)
  end

  def to_s
    @symbol.to_s
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
    tree[mt] = self.gather_gaf_arg_index_nart(index,relation.to_sym,mt.to_sym)
  end

  def mt_indices(index,relation)
    self.key_gaf_arg_index(index,relation.to_sym)
  end

  def relation_indices(index)
    self.key_gaf_arg_index(index)
  end

  def index_indices
    self.key_gaf_arg_index
  end

  def cyc
    CYC
  end
end
