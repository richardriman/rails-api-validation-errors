require 'spec_helper'

describe ActiveModel::Errors do

  before :each do
    ActiveModel::Errors.disable_extended_errors
  end

  after :each do
    ActiveModel::Errors.disable_extended_errors
  end

  it { expect(ActiveModel::Errors).to respond_to :enable_extended_errors }
  it { expect(ActiveModel::Errors).to respond_to :disable_extended_errors }

  it 'original messages per default' do
    option = ActiveModel::Errors.class_variable_get('@@extended_errors')
    expect(option).to be_false
  end

  describe '.enable_extended_translations' do
    it 'sets errors to extended mode' do
      ActiveModel::Errors.enable_extended_errors
      option = ActiveModel::Errors.class_variable_get('@@extended_errors')
      expect(option).to be_true
    end
  end

  describe '.disable_extended_translations' do
    it 'sets errors to original mode' do
      ActiveModel::Errors.disable_extended_errors
      option = ActiveModel::Errors.class_variable_get('@@extended_errors')
      expect(option).to be_false
    end
  end

  describe '#generate_message' do

    let(:errors) { ActiveModel::Errors.new({}) }

    context "when extended error are turned off" do
      it 'uses the original method' do
        ActiveModel::Errors.disable_extended_errors
        stub(errors)._generate_message

        errors.generate_message(:attribute)

        expect(errors).to have_received._generate_message(:attribute, :invalid, {})
      end
    end

    context "when translations are turned on" do
      before :each do
        ActiveModel::Errors.enable_extended_errors
      end

      it 'uses the original method too' do
        stub(errors)._generate_message

        errors.generate_message(:attribute)

        expect(errors).to have_received._generate_message(:attribute, :invalid, {})
      end

      it 'returns a hash with type, message and meta keys' do
        stub(errors)._generate_message
        error_hash = errors.generate_message(:attribute)

        expect(error_hash).to be_instance_of(Hash)
        expect(error_hash).to have_key(:type)
        expect(error_hash).to have_key(:message)
        expect(error_hash).to have_key(:meta)
      end

      it 'returns the untranslated message as type' do
        stub(errors)._generate_message

        error_hash = errors.generate_message(:attribute, :custom_error)

        expect(error_hash[:type]).to eq(:custom_error)
      end

      it 'returns passed options as meta' do
        stub(errors)._generate_message

        error_hash = errors.generate_message(:attribute, :invalid, count: 2)

        expect(error_hash[:meta]).to have_key(:count)
        expect(error_hash[:meta][:count]).to eq(2)
      end
    end
  end

end
