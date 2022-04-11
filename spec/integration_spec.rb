# frozen_string_literal: true

RSpec.describe 'everything working together' do # rubocop:disable RSpec/DescribeClass
  describe 'when composing Hash matchers inside of an Array matcher' do
    subject(:matched_by?) { array_shape.matched_by?(test_array) }

    let(:array_shape) { Shaped::Shape([{ email: String }]) }

    context 'when the test array matches the pattern' do
      let(:test_array) do
        [
          { email: 'a@b.com' },
          { email: 'd@e.fom' },
        ]
      end

      it 'indicates that the test array matches the shape' do
        expect(matched_by?).to eq(true)
      end
    end

    context 'when the test array does not match the pattern' do
      let(:test_array) do
        [
          { email: 'a@b.com' },
          { email: 'c@d.fom' },
          { email: 42.0 },
        ]
      end

      it 'indicates that the test array does not match the shape' do
        expect(matched_by?).to eq(false)
      end
    end
  end

  describe 'when composing Array matchers inside of a Hash matcher' do
    subject(:matched_by?) { hash_shape.matched_by?(test_hash) }

    let(:hash_shape) do
      Shaped::Shape(array_of_numerics: [Numeric], array_of_strings: [String])
    end

    context 'when the test hash matches the pattern' do
      let(:test_hash) do
        {
          array_of_numerics: [512, Rational(2, 5), 8.8],
          array_of_strings: %w[neat happy cool awesome],
        }
      end

      it 'indicates that the test hash matches the shape' do
        expect(matched_by?).to eq(true)
      end
    end

    context 'when the test hash does not match the pattern' do
      let(:test_hash) do
        {
          array_of_numerics: [7.0, Rational(1, 9), 3],
          array_of_strings: [2, 4, 8, 16],
        }
      end

      it 'indicates that the test hash does not match the shape' do
        expect(matched_by?).to eq(false)
      end
    end
  end

  describe 'when deeply composing Array and Hash matchers' do
    subject(:matched_by?) { array_shape.matched_by?(test_array) }

    let(:array_shape) do
      Shaped::Shape([
        {
          name: String,
          emails: {
            personal: [String],
            work: [String],
          },
          favorite_numbers: [Numeric],
        },
      ])
    end

    let(:test_array) do
      [
        {
          name: 'Thomas Jefferson',
          emails: {
            personal: ['tom@gmail.com', 'tom@yahoo.com'],
            work: ['thomas.jefferson@google.com'],
          },
          favorite_numbers: [2, 32],
        },
        {
          name: 'John Locke',
          emails: {
            personal: ['jlocke@protonmail.com'],
            work: ['locke@google.com', 'john.locke@fanniemae.gov'],
          },
          favorite_numbers: [1_000_000],
        },
      ]
    end

    context 'when the test array matches the pattern' do
      it 'indicates that the test array matches the shape' do
        expect(matched_by?).to eq(true)
      end
    end

    context 'when the test array does not match the pattern because a hash key is missing' do
      let(:test_array) do
        super() + [
          {
            name: 'London Grammar',
            emails: {
              personal: ['london@protonmail.com'],
              # work emails are missing!
            },
            favorite_numbers: [99.9],
          },
        ]
      end

      it 'indicates that the test array does not match the shape' do
        expect(matched_by?).to eq(false)
      end
    end

    context 'when the test array does not match the pattern because a hash has the wrong shape' do
      let(:test_array) do
        super() + [
          {
            name: 'London Grammar',
            # :emails is supposed to be a hash, not an array!
            emails: ['london@protonmail.com', 'london.grammar@hired.com'],
            favorite_numbers: [99.9],
          },
        ]
      end

      it 'indicates that the test array does not match the shape' do
        expect(matched_by?).to eq(false)
      end
    end
  end
end
