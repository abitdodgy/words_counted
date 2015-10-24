# -*- encoding : utf-8 -*-
module Refinements
  module HashRefinements
    refine Hash do
      def sort_by_value_desc
        sort_by(&:last).reverse
      end
    end
  end
end
