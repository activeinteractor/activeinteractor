# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor do
  it 'is expected to have ::Context' do
    expect(described_class::Context).to be_a Module
  end

  it 'is expected to have ::Error' do
    expect(described_class::Error).to be_a Class
  end

  it 'is expected to have ::Interactor' do
    expect(described_class::Interactor).to be_a Module
  end

  it 'is expected to have ::Result' do
    expect(described_class::Result).to be_a Module
  end

  it 'is expected to have ::Type' do
    expect(described_class::Type).to be_a Module
  end
end
