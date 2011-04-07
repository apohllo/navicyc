class Sparql
  RDFS_LABEL_QUERY = "select ?subject where {?subject rdfs:label \"%s\"@en}"
  SKOS_LABEL_QUERY = "select ?subject where {?subject skos:prefLabel \"%s\"@en}"
  SUBJECT_PREDICATES = "select distinct ?predicate where {<%s> ?predicate ?o}"
  OBJECT_PREDICATES = "select distinct ?predicate where {?s ?predicate <%s>}"
  SUBJECT_PREDICATES_COUNT =
    "select count distinct ?predicate where {<%s> ?predicate ?o}"
  OBJECT_PREDICATES_COUNT =
    "select count distinct ?predicate where {?s ?predicate  <%s>}"
  SUBJECT_PREDICATE_ASSERTIONS = "select ?other where {<%s> <%s> ?other}"
  OBJECT_PREDICATE_ASSERTIONS = "select ?other where {?other <%s> <%s>}"
  SUBJECT_ASSERTIONS = "select ?predicate, ?other where {<%s> ?predicate ?other}"
  OBJECT_ASSERTIONS = "select ?predicate, ?other where {?other ?predicate <%s>}"
  SUBJECT_PREDICATE_ASSERTIONS_COUNT = "select count(?other) where {<%s> <%s> ?other}"
  OBJECT_PREDICATE_ASSERTIONS_COUNT = "select count(?other) where {?other <%s> <%s>}"

  attr_reader :client

  def initialize(endpoint)
    @client = SPARQL::Client.new(endpoint)
  end

  def search(label)
    result = client.query(RDFS_LABEL_QUERY % label).to_a
    result += client.query(SKOS_LABEL_QUERY % label).to_a
    result.map{|s| s.subject.to_s}.uniq.sort
  end

  def predicates(id,index)
    query = (index == 1 ?  SUBJECT_PREDICATES : OBJECT_PREDICATES)
    client.query(query % id).map{|s| s.predicate.to_s}
  end

  def predicates_count(id,index)
    query = (index == 1 ? SUBJECT_PREDICATES_COUNT : OBJECT_PREDICATES_COUNT)
    client.query(query % id).first[:"callret-0"].to_i
  end

  def assertions(id,index,predicate=nil)
    if predicate
      query =
        if index == 1
          SUBJECT_PREDICATE_ASSERTIONS % [id, predicate]
        else
          OBJECT_PREDICATE_ASSERTIONS % [predicate, id]
        end
      others = client.query(query).map{|s| s.other.to_s}.sort
      [[index,[[predicate,others]]]]
    else
      query = (index == 1 ? SUBJECT_ASSERTIONS : OBJECT_ASSERTIONS)
      predicates = {}
      client.query(query % id).each do |solution|
        predicates[solution.predicate] ||= []
        predicates[solution.predicate] << solution.other.to_s
      end
      predicates.each{|k,v| v.sort!}
      [[index,predicates.to_a]]
    end
  end

  def assertions_count(id,index,predicate)
    query =
      if index == 1
        SUBJECT_PREDICATE_ASSERTIONS_COUNT % [id, predicate]
      else
        OBJECT_PREDICATE_ASSERTIONS_COUNT % [predicate, id]
      end
    client.query(query).first[:"callret-0"].to_i
  end

end
