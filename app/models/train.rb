class Train
  include NBayes
  include Mongoid::Document
  include Mongoid::Timestamps

  after_create :countData,:trainModel,:testModel
  before_update :classifytoMongo

  a=Array.new(5,0)
  a.map!{|a| a=Array.new(5,0)}

  default_scope -> { order_by(:created_at => 'desc') }
  field :classified, type: Boolean, default: false
  field :precision, type: Hash, default: Hash.new()
  field :recall, type: Hash, default: Hash.new()
  field :fmeasure, type: Hash, default: Hash.new()
  field :accuracy, type: Float
  field :train_data, type: Hash, default: Hash.new()
  field :test_data, type: Hash, default: Hash.new()
  field :matrix, type: Array, default:a
  field :data, type: Hash, default: Hash.new()
  field :vocab, type: Hash, default: Hash.new()

  def classifytoMongo
    if self.classified_change==[false,true]
      trainModel
      Review.crawled.each do |doc|
        classify_doc=doc.title+" "+doc.review+doc.tag.join(" ")
        tokens= classify_doc.review.split(/\s+/)
        result=@nbayes.classify(tokens)
        doc["type"]=result.max_class
      end
    end
  end

  def countData
    Review::CATEGORIES.each do |cat|
      self.train_data[cat]=TrainReview.by_category(cat).count
      self.train_data['total']=TrainReview.count
      self.test_data[cat]=TestReview.by_category(cat).count
      self.test_data['total']=TestReview.count
    end
  end

  def trainModel
    @nbayes=NBayes::Base.new
    TrainReview.all.each do |doc|
      review=Review.find(doc[:id])
      train_doc=review.title+" "+review.review+review.tag.join(" ")
      @nbayes.train(train_doc.split(/\s+/),doc[:category])
    end
  end

  def testModel
    a=Array.new(5,0)
    a.map!{|a| a=Array.new(5,0)}
    sum=TestReview.count
    TestReview.all.each do |doc|
      review=Review.find(doc[:id])
      test_doc=review.title+" "+review.review+review.tag.join(" ")
      tokens=test_doc.split(/\s+/)
      result=@nbayes.classify(tokens)
      x=getValue result.max_class
      y=getValue doc[:category]
      a[x][y]+=1
    end
    Review::CATEGORIES.each do |cat|
      self.precision[cat]=get_precision(cat,a).round(2)
      self.recall[cat]=get_recall(cat,a).round(2)
      self.fmeasure[cat]=get_fmeasure(cat,a).round(2)
    end
    self.accuracy=get_accuracy(a,sum).round(2)
    Review::CATEGORIES.each do |cat1|
      Review::CATEGORIES.each do|cat2|
        self.matrix=a
      end
    end
    self.save
  end

  def getValue category
    case category
    when "camera"
      return 1
    when "design"
      return 2
    when "perform"
      return 4
    when "general"
      return 0
    when "misc"
      return 3
    end
  end

  def rowsum a,row
    sum=0
    0.upto(4){|i| sum+=a[row][i]}
    return sum.to_f
  end

  def colsum a,col
    sum=0
    0.upto(4){|i| sum+=a[i][col]}
    return sum.to_f
  end

  #precision and recall functions and fmeasure
  def get_precision category,a
    x=getValue category
    y=getValue category
    return a[x][y]/colsum(a,y).to_f
  end

  def get_recall category,a
    x=getValue category
    y=getValue category
    return a[x][y]/rowsum(a,x).to_f
  end

  def get_fmeasure category,a
    p=get_precision(category,a)
    r=get_recall(category,a)
    return 2*p*r/(p+r)
  end

  #accuracy
  def get_accuracy a,sum
    tp=0
    0.upto(4){|i| tp+=a[i][i]}
    return tp/sum.to_f*100
  end
end
