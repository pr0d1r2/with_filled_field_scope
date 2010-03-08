require 'rubygems'
require 'active_record'
require 'searchlogic'

module ActiveRecord
  module WithFilledFieldScope
    module Base

      FIELD_TYPES_SUPPORTING_ONLY_NOT_NULL = [:date, :decimal, :boolean]

      def has_with_filled_field_scope(model = self)
        alias_scope :with_filled_field, lambda { |field|
          if field_support_not_blank?(field, model)
            send("#{field.to_s}_not_blank")
          else
            send("#{field.to_s}_not_null")
          end
        }
      end

      def field_support_not_blank?(field, model = self)
        !FIELD_TYPES_SUPPORTING_ONLY_NOT_NULL.include?(field_column_type(field))
      end

      def field_column_type(field, model = self)
        model.columns_hash[field.to_s].type
      end

    end
  end
end

ActiveRecord::Base.extend(ActiveRecord::WithFilledFieldScope::Base)

