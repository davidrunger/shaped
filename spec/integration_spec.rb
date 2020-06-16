# frozen_string_literal: true

RSpec.describe 'everything working together' do
  using Shaped::Refinements::Array
  using Shaped::Refinements::Hash

  describe 'when composing Hash matchers inside of an Array matcher' do
    subject(:has_shape?) { test_array.has_shape?(shaped_array) }

    let(:shaped_array) { Shaped::Array([Shaped::Hash(email: String)]) }

    context 'when the test array matches the pattern' do
      let(:test_array) do
        [
          { email: 'a@b.com' },
          { email: 'd@e.fom' },
        ]
      end

      it 'indicates that the test array matches the shape' do
        expect(has_shape?).to eq(true)
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
        expect(has_shape?).to eq(false)
      end

      it 'accurately indicates the first point of failure in the shape matching' do
        expect(shaped_array.match_failure_reason(test_array).to_s).to eq(
          'Object at `2.email` is expected to be a String but was a Float',
        )
      end
    end
  end

  describe 'when composing Array matchers inside of a Hash matcher' do
    subject(:has_shape?) { test_hash.has_shape?(shaped_hash) }

    let(:shaped_hash) do
      Shaped::Hash(
        array_of_numerics: Shaped::Array([Numeric]),
        array_of_strings: Shaped::Array([String]),
      )
    end

    context 'when the test hash matches the pattern' do
      let(:test_hash) do
        {
          array_of_numerics: [512, Rational(2, 5), 8.8],
          array_of_strings: %w[neat happy cool awesome],
        }
      end

      it 'indicates that the test hash matches the shape' do
        expect(has_shape?).to eq(true)
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
        expect(has_shape?).to eq(false)
      end

      it 'accurately indicates the first point of failure in the shape matching' do
        expect(shaped_hash.match_failure_reason(test_hash).to_s).to eq(
          'Object at `array_of_strings.0` is expected to be a String but was a Integer',
        )
      end
    end
  end

  describe 'when deeply composing Array and Hash matchers' do
    subject(:has_shape?) { test_array.has_shape?(shaped_array) }

    let(:shaped_array) do
      Shaped::Array([
        Shaped::Hash(
          name: String,
          emails: Shaped::Hash(
            personal: Shaped::Array([String]),
            work: Shaped::Array([String]),
          ),
          favorite_numbers: Shaped::Array([Numeric]),
        ),
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
        expect(has_shape?).to eq(true)
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
        expect(has_shape?).to eq(false)
      end

      it 'accurately indicates the first point of failure in the shape matching' do
        expect(shaped_array.match_failure_reason(test_array).to_s).to eq(
          'Object at `2.emails.work` is expected to be a Array shaped like [String] ' \
          'but was a NilClass',
        )
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
        expect(has_shape?).to eq(false)
      end

      it 'accurately indicates the first point of failure in the shape matching' do
        expect(shaped_array.match_failure_reason(test_array).to_s).to eq(
          'Object at `2.emails` is expected to be a Hash shaped like ' \
          '{ :personal => Array shaped like [String], :work => Array shaped like [String] } ' \
          'but was a Array',
        )
      end
    end
  end
end
