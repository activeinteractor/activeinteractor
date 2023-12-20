# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Error do
  describe '.new' do
    subject(:error) { described_class.new(result, message) }

    let(:message) { SecureRandom.hex }
    let(:result) { ActiveInteractor::Result.success }

    it 'is expected to set #message' do
      expect(error.message).to eq message
    end

    it 'is expected to set #result' do
      expect(error.result).to eq result
    end
  end
end
