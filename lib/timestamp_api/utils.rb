module TimestampAPI
  module Utils
    def camelize(symbol)
      symbol.to_s.split('_').each_with_index.map{ |chunk, idx| idx == 0 ? chunk : chunk.capitalize }.join
    end
  end
end
