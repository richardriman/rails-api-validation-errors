require 'spec_helper'

describe 'Default validation errors' do

  before :each do
    ActiveModel::Errors.disable_extended_errors
  end

  it 'returns normal translated errors when directly validating a model' do
    person = Person.new

    expect(person).to_not be_valid

    messages = person.errors.messages
    expect(messages).to have_key(:name)
    expect(messages[:name]).to include("can't be blank")
  end

end
