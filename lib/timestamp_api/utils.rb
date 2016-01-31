module TimestampAPI
  module Utils
    def camelize(symbol)
      symbol.to_s.split('_').each_with_index.map{ |chunk, idx| idx == 0 ? chunk : chunk.capitalize }.join.gsub(/^\w/, &:downcase)
    end

    def camelize_keys(hash)
      hash.each_with_object({}) { |pair, acc| acc[camelize(pair[0])] = pair[1] }
    end
  end
end
