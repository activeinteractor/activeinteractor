# frozen_string_literal: true

module ActiveInteractor
  # Raised when an interactor fails
  #
  # @!attribute [r] result
  #  @return [ActiveInteractor::Result] An instance of {ActiveInteractor::Result} for the
  #    {ActiveInteractor::Interactor::Base interactor} that failed
  class Error < StandardError
    attr_reader :result

    # Create a new instance of {ActiveInteractor::Error}
    #
    # @param result [ActiveInteractor::Result] An instance of {ActiveInteractor::Result} for the
    #   {ActiveInteractor::Interactor::Base interactor} that failed
    # @param message [String] The error message
    #
    # @private
    # @return [ActiveInteractor::Error]
    def initialize(result, message = nil)
      @result = result
      super(message)
    end
  end
end
