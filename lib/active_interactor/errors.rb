# frozen_string_literal: true

module ActiveInteractor
  class Error < StandardError
    attr_reader :result

    def initialize(result, message = nil)
      @result = result
      super(message)
    end
  end
end
