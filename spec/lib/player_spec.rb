require 'spec_helper'
require_relative '../../lib/parser'

RSpec.describe Player do
  subject { described_class.new(name: name) }

  describe '#world?' do
    context 'for a player with a name different from <world>' do
      let(:name) { 'world' }

      it 'returns false' do
        expect(subject.world?).to be false
      end
    end

    context 'for a player with a nil name' do
      let(:name) { nil }

      it 'returns false' do
        expect(subject.world?).to be false
      end
    end

    context 'for a player with a name equals <world>' do
      let(:name) { '<world>' }
      it 'returns true' do
        expect(subject.world?).to be true
      end
    end
  end
end
