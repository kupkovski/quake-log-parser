require 'spec_helper'
require_relative '../src/parser'

RSpec.describe Parser do
  subject { described_class.new(quake_log_path: quake_log_path) }

  describe '#parse' do
    context 'with nil quake log path' do
      let(:quake_log_path) { nil }

      it 'raises invalid file path error' do
        expect { subject.parse }.to raise_error(ArgumentError, 'quake_log_path should not be empty')
      end
    end

    context 'with empty quake log path' do
      let(:quake_log_path) { '' }

      it 'raises invalid file path error' do
        expect { subject.parse }.to raise_error(ArgumentError, 'quake_log_path should not be empty')
      end
    end

    context 'with invalid quake log path' do
      let(:quake_log_path) { '../invalid.dunno' }

      it 'raises invalid file path error' do
        expect { subject.parse }.to raise_error(Errno::ENOENT)
      end
    end

    context 'with valid quake log path' do
      context 'but file is empty' do
        let(:quake_log_path) { __dir__ + '/fixtures/empty_quake_log.log' }

        it 'returns empty hash' do
          expect(subject.parse).to eq({})
        end
      end

      context 'containing one game' do
        let(:quake_log_path) { __dir__ + '/fixtures/single_game.log' }
        expected = {1=>{"kills"=>{"Isgalamido"=>0}, "players"=>["Isgalamido", "Mocinha"]}}

        it 'returns scores for this game' do
          expect(subject.parse).to eq expected
        end
      end
    end
  end
end
