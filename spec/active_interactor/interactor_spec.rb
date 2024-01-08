# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Interactor do
  it 'is expected to have ::Base' do
    expect(described_class::Base).to be_a Class
  end

  it 'is expected to have ::Options' do
    expect(described_class::Options).to be_a Class
  end
end
