# -*- encoding : utf-8 -*-
module Refinements
  module HashRefinements
    refine Hash do
      # This is convenience method to sort hashes into an
      # array of tuples by descending value.
      def sort_by_value_desc
        sort_by(&:last).reverse
      end
    end
  end
end
