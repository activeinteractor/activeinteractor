# frozen_string_literal: true

module ActiveInteractor
  module Type
    class Boolean < Base
      TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE', 'on', 'ON', 'yes', 'YES'].freeze
      FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE', 'off', 'OFF', 'no', 'NO'].freeze

      def self.valid?(value)
        (TRUE_VALUES + FALSE_VALUES).include?(value)
      end
    end
  end
end
