# frozen_string_literal: true

module ActiveInteractor
  module Type
    module HasTypes
      extend ActiveSupport::Concern

      Boolean = ActiveInteractor::Type::Boolean

      module ClassMethods
        def any
          :any
        end

        def list(type)
          List.new(type)
        end
        alias array list

        def union(*types)
          Union.new(*types)
        end

        def untyped
          :untyped
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end
