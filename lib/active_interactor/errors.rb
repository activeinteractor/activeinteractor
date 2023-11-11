# frozen_string_literal: true

module ActiveInteractor
  # Raised on interactor failure
  #
  # @!attribute [r] result
  #  @return [ActiveInteractor::Result] the result of the interactor that failed
  class Error < StandardError
    attr_reader :result

    def initialize(result, message = nil)
      @result = result
      super(message)
    end
  end
end
