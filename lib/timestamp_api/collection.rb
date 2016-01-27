module TimestampAPI
  class Collection < Array
    def where(conditions)
      raise TimestampAPI::InvalidWhereContitions unless conditions.is_a? Hash
      conditions.each_with_object(self.dup) do |condition, acc|
        acc.select! { |i| i.send(condition.first.to_sym) == condition.last }
      end
    end
  end
end
