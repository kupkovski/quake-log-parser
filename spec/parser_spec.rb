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
          expect(subject.parse).to eq []
        end
      end

      context 'containing one simple game' do
        let(:quake_log_path) { __dir__ + '/fixtures/simple_game.log' }
        expected = [{"game_1"=>{"kills"=>{"Isgalamido"=>0}, "players"=>["Isgalamido", "Mocinha"], "total_kills"=>2}}]

        it 'returns scores for this game' do
          expect(subject.parse).to eq expected
        end
      end

      context 'containing one more complex game' do
        let(:quake_log_path) { __dir__ + '/fixtures/more_complex_game.log' }
        expected = [{"game_1"=>{"kills"=>{"Isgalamido"=>0, "Mocinha"=>0}, "players"=>["Isgalamido", "Mocinha"], "total_kills"=>4}}]

        it 'returns scores for this game' do
          expect(subject.parse).to eq expected
        end
      end

      context 'containing two games' do
        let(:quake_log_path) { __dir__ + '/fixtures/two_games.log' }
        expected = [
          {
            "game_1"=>{"total_kills"=>2, "players"=>["Isgalamido", "Mocinha"], "kills"=>{"Isgalamido"=>0}}
          },
          {
            "game_2"=>{"total_kills"=>4, "players"=>["Isgalamido", "Mocinha"], "kills"=>{"Isgalamido"=>0, "Mocinha"=>0}}
          }
        ]

        it 'returns scores for this game' do
          expect(subject.parse).to eq expected
        end
      end
    end
  end
end
