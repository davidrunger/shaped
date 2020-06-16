# frozen_string_literal: true

RSpec.describe(Shaped) do
  it 'has a version number' do
    expect(Shaped::VERSION).not_to eq(nil)
  end

  describe '::Array method' do
    it 'returns an instance of Shaped::Array' do
      expect(Shaped::Array([Numeric])).to be_a(Shaped::Array)
    end
  end
end
