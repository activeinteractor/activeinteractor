# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Context do
  it 'is expected to have ::Attribute' do
    expect(described_class::Attribute).to be_a Class
  end

  it 'is expected to have ::AttributeAssignment' do
    expect(described_class::AttributeAssignment).to be_a Module
  end

  it 'is expected to have ::AttributeRegistration' do
    expect(described_class::AttributeRegistration).to be_a Module
  end

  it 'is expected to have ::AttributeSet' do
    expect(described_class::AttributeSet).to be_a Class
  end

  it 'is expected to have ::AttributeValidation' do
    expect(described_class::AttributeValidation).to be_a Module
  end

  it 'is expected to have ::Base' do
    expect(described_class::Base).to be_a Class
  end

  it 'is expected to have ::Input' do
    expect(described_class::Input).to be_a Class
  end

  it 'is expected to have ::Output' do
    expect(described_class::Output).to be_a Class
  end

  it 'is expected to have ::Result' do
    expect(described_class::Result).to be_a Class
  end

  it 'is expected to have ::Runtime' do
    expect(described_class::Runtime).to be_a Class
  end
end
