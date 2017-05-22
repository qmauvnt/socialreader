module NBayes

  class Vocab
    attr_accessor :tokens

    def initialize(options = {})
      @tokens = Hash.new
    end

    def delete(token)
      tokens.delete(token)
    end

    def each(&block)
      tokens.keys.each(&block)
    end

    def size
        tokens.count
    end

    def seen_token(token)
      tokens[token] = 1
    end
  end

  class Data
    attr_accessor :data
    def initialize(options = {})
      @data = Hash.new
      #@data = {
      #  "category1": {
      #    "tokens": Hash.new(0),
      #    "total_tokens": 0,
      #    "examples": 0
      #  },
      # ...
      #}
    end

    def categories
      data.keys
    end

    def cat_data(category)
      unless data[category].is_a? Hash
        data[category] = new_category
      end
      data[category]
    end

    def each(&block)
      data.keys.each(&block)
    end

    # Increment the number of training examples for this category
    def increment_examples(category)
      cat_data(category)[:examples] += 1
    end

    def example_count(category)
      cat_data(category)[:examples]
    end

    def token_count(category)
      cat_data(category)[:total_tokens]
    end

    # Total number of training examples
    def total_examples
      sum = 0
      self.each {|category| sum += example_count(category) }
      sum
    end

    # Add this token to this category
    def add_token_to_category(category, token)
      cat_data(category)[:tokens][token] += 1
      cat_data(category)[:total_tokens] += 1
    end

    # How many times does this token appear in this category?
    def count_of_token_in_category(category, token)
      cat_data(category)[:tokens][token]
    end

    # Return the total number of tokens we've seen across all categories
    def token_count_across_categories(token)
      data.keys.inject(0){|sum, cat| sum + @data[cat][:tokens][token] }
    end

    def new_category
      {
        # holds freq counts
        :tokens => Hash.new(0),
        #
        :total_tokens => 0,
        :examples => 0
      }
    end
  end

  class Base

    attr_accessor :vocab, :data

    def initialize(options={})
      @vocab = Vocab.new()
      @data = Data.new
    end

    def train(tokens, category)
      data.increment_examples(category)
      tokens.each do |token|
        vocab.seen_token(token)
        data.add_token_to_category(category, token)
      end
    end

    def classify(tokens)
      probs = {}
      probs = calculate_probabilities(tokens)
      probs.extend(NBayes::Result)
      probs
    end

    def category_stats
      data.category_stats
    end

    # Calculates the actual probability of a class given the tokens
    def calculate_probabilities(tokens)
      # P(class|words) = P(w1,...,wn|class) * P(class) / P(w1,...,wn)
      #                = argmax P(w1,...,wn|class) * P(class)
      #
      # P(wi|class) = (count(wi, class) + k)/(count(w,class) + kV)
      prob_numerator = {}
      v_size = vocab.size

      cat_prob = Math.log(1 / data.categories.count.to_f)
      total_example_count = data.total_examples.to_f

      data.each do |category|
        cat_prob = Math.log(data.example_count(category) / total_example_count)
        log_probs = 0
        denominator = (data.token_count(category) + v_size).to_f
        tokens.each do |token|
          numerator = data.count_of_token_in_category(category, token) + 1
          log_probs += Math.log( numerator / denominator )
        end
        prob_numerator[category] = log_probs + cat_prob
      end
      normalize(prob_numerator)
    end

    def normalize(prob_numerator)
      # calculate the denominator, which normalizes this into a probability; it's just the sum of all numerators from above
      normalizer = 0
      prob_numerator.each {|cat, numerator| normalizer += numerator }
      # One more caveat:
      # We're using log probabilities, so the numbers are negative and the smallest negative number is actually the largest prob.
      # To convert, we need to maintain the relative distance between all of the probabilities:
      # - divide log prob by normalizer: this keeps ratios the same, but reverses the ordering
      # - re-normalize based off new counts
      # - final calculation
      # Ex: -1,-1,-2  =>  -4/-1, -4/-1, -4/-2
      #   - renormalize and calculate => 4/10, 4/10, 2/10
      temp = {}
      renormalizer = 0
      prob_numerator.each do |cat, numerator|
        temp[cat] = normalizer / numerator.to_f
        renormalizer += temp[cat]
      end
      # calculate final probs
      final_probs = {}
      temp.each do |cat, value|
        final_probs[cat] = value / renormalizer.to_f
      end
      final_probs
    end
  end

  module Result
    # Return the key having the largest value
    def max_class
      keys.max{ |a,b| self[a] <=> self[b] }
    end
  end

end


