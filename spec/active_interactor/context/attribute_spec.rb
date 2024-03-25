# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveInteractor::Context::Attribute do
  describe '#initialize' do
    subject(:attribute) { described_class.new(*attribute_args) }

    let(:attribute_args) do
      [
        :test,
        String,
        'A test attribute'
      ]
    end

    it 'sets the name' do
      expect(attribute.name).to eq(:test)
    end

    it 'sets the type' do
      expect(attribute.type).to eq(String)
    end

    it 'sets the description' do
      expect(attribute.description).to eq('A test attribute')
    end

    it 'sets default for required' do
      expect(attribute.required?).to be(false)
    end

    it 'sets default for default_value' do
      expect(attribute.default_value).to be_nil
    end

    context 'when description is passed as an option' do
      let(:attribute_args) do
        [
          :test,
          String,
          { description: 'A test attribute' }
        ]
      end

      it 'sets the description' do
        expect(attribute.description).to eq('A test attribute')
      end
    end

    context 'when required is passed as an option' do
      let(:attribute_args) do
        [
          :test,
          String,
          { required: true }
        ]
      end

      it 'sets required' do
        expect(attribute.required?).to be(true)
      end
    end

    context 'when default is passed as an option' do
      let(:attribute_args) do
        [
          :test,
          String,
          { default: 'default' }
        ]
      end

      it 'sets default_value' do
        expect(attribute.default_value).to eq('default')
      end
    end
  end

  describe '#assign_value' do
    subject(:assign_value) { attribute.assign_value(value) }

    let(:attribute) do
      described_class.new(:test, String, 'A test attribute')
    end

    let(:value) { 'test' }

    it { expect { assign_value }.to change(attribute, :value).from(nil).to('test') }
  end

  describe '#default_value' do
    subject(:default_value) { attribute.default_value }

    let(:attribute) do
      described_class.new(:test, String, 'A test attribute')
    end

    it { is_expected.to be_nil }

    context 'when default is set' do
      let(:attribute) do
        described_class.new(:test, String, { default: 'default' })
      end

      it { is_expected.to eq('default') }
    end
  end

  describe '#required?' do
    subject(:required?) { attribute.required? }

    let(:attribute) do
      described_class.new(:test, String, 'A test attribute')
    end

    it { is_expected.to be(false) }

    context 'when required is set' do
      let(:attribute) do
        described_class.new(:test, String, { required: true })
      end

      it { is_expected.to be(true) }
    end
  end

  describe '#type' do
    subject(:type) { attribute.type }

    let(:attribute) do
      described_class.new(:test, String, 'A test attribute')
    end

    it { is_expected.to eq(String) }
  end

  describe '#validate!' do
    subject(:validate!) { attribute.validate! }

    let(:attribute) do
      described_class.new(:test, String, 'A test attribute')
    end

    it { expect { validate! }.not_to change(attribute, :error_messages) }

    context 'when required and value is nil' do
      let(:attribute) do
        described_class.new(:test, String, { required: true })
      end

      it { expect { validate! }.to change(attribute, :error_messages).from([]).to(%i[blank]) }
    end

    context 'when type is wrong' do
      let(:attribute) do
        described_class.new(:test, String)
      end

      before do
        attribute.assign_value(1)
      end

      it { expect { validate! }.to change(attribute, :error_messages).from([]).to(%i[invalid]) }
    end
  end

  describe '#value' do
    subject(:value) { attribute.value }

    let(:attribute) do
      described_class.new(:test, String, 'A test attribute')
    end

    it { is_expected.to be_nil }

    context 'when value is assigned' do
      before do
        attribute.assign_value('test')
      end

      it { is_expected.to eq('test') }
    end

    context 'when default is set' do
      let(:attribute) do
        described_class.new(:test, String, { default: 'default' })
      end

      it { is_expected.to eq('default') }
    end

    context 'when default is set and overwritten by user_provided_value' do
      let(:attribute) do
        described_class.new(:test, String, { default: 'default' })
      end

      before do
        attribute.assign_value('test')
      end

      it { is_expected.to eq('test') }
    end
  end
end
