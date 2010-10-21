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


  protected
  def cyc
    CYC
  end
end
