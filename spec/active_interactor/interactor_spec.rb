# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Interactor do
  it 'is expected to have ::Base' do
    expect(described_class::Base).to be_a Class
  end

  it 'is expected to have ::Callbacks' do
    expect(described_class::Callbacks).to be_a Module
  end

  it 'is expected to have ::ContextMethods' do
    expect(described_class::ContextMethods).to be_a Module
  end

  it 'is expected to have ::InteractionMethods' do
    expect(described_class::InteractionMethods).to be_a Module
  end

  it 'is expected to have ::OptionMethods' do
    expect(described_class::OptionMethods).to be_a Module
  end

  it 'is expected to have ::Options' do
    expect(described_class::Options).to be_a Class
  end
end
