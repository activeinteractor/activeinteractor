# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Context::AttributeSet do
  let(:owner) { instance_double(ActiveInteractor::Context::Base) }

  describe '#initialize' do
    subject(:attribute_set) { described_class.new(owner, attribute) }

    let(:attribute) { instance_double(ActiveInteractor::Context::Attribute, name: :test) }

    it 'initializes with given attributes' do
      expect(attribute_set.attribute_names).to include(:test)
    end
  end

  describe '#add' do
    subject(:add) { attribute_set.add(*attribute_args) }

    let(:attribute_set) { described_class.new(owner) }
    let(:attribute_args) do
      [
        :test,
        String,
        'A test attribute'
      ]
    end

    it 'adds an attribute' do
      add
      expect(attribute_set.attribute_names).to include(:test)
    end
  end

  describe '#attribute_names' do
    subject(:attribute_names) { attribute_set.attribute_names }

    let(:attribute_set) { described_class.new(owner, attribute) }
    let(:attribute) { instance_double(ActiveInteractor::Context::Attribute, name: :test) }

    it 'returns attribute names' do
      expect(attribute_names).to include(:test)
    end
  end

  describe '#attributes' do
    subject(:attributes) { attribute_set.attributes }

    let(:attribute_set) { described_class.new(owner, attribute) }
    let(:attribute) { instance_double(ActiveInteractor::Context::Attribute, name: :test) }

    it 'returns attributes' do
      expect(attributes).to include(attribute)
    end
  end

  describe '#find' do
    subject(:find) { attribute_set.find(attribute_name) }

    let(:attribute_set) { described_class.new(owner, attribute) }
    let(:attribute_name) { :test }
    let(:attribute) { instance_double(ActiveInteractor::Context::Attribute, name: attribute_name) }

    it 'finds an attribute' do
      expect(find).to eq(attribute)
    end
  end

  describe '#merge' do
    subject(:merge) { attribute_set.merge(attributes) }

    let(:attribute_set) { described_class.new(owner) }
    let(:attributes) { [attribute] }
    let(:attribute) { instance_double(ActiveInteractor::Context::Attribute, name: :test) }

    it 'merges attributes' do
      merge
      expect(attribute_set.attribute_names).to include(:test)
    end
  end
end
