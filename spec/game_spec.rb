require 'spec_helper'
require_relative '../src/parser'

RSpec.describe Game do
  subject { described_class.new(number: 0) }

  describe '#name' do
    it 'returns the name in the format game_{number + 1}' do
      expect(subject.name).to eq 'game_1'
    end
  end

  describe '#parse_kill' do
    it 'creates killer and victim from the content' do
      killer_name = 'Psycho'
      victim_name = 'Easy'

      expect do
        result = subject.parse_kill(killer_name, victim_name)
      end.to change { subject.kills.size }.from(0).to(1)
      expect(subject.kills.first.killer.name).to eq 'Psycho'
      expect(subject.kills.first.victim.name).to eq 'Easy'
    end
  end

  describe '#add_kill' do
    it 'adds a player to the killer list' do
      expect(subject.kills).to be_empty
      player = Player.new(name: 'Psycho')
      victim = Player.new(name: 'Easy')
      subject.add_kill(killer: player, victim:)

      expect(subject.kills).to_not be_empty
    end
  end

  describe '#report' do
    context 'with blank data' do
      it 'returns blank hash' do
        expected = {"game_1"=>{"kills"=>{}, "players"=>[], "total_kills"=>0}}
        expect(subject.kills).to be_empty
        expect(subject.report).to eq expected
      end
    end

    context 'with data' do
      it 'returns blank hash' do
        expected = {"game_1"=>{"kills"=>{"Psycho"=>1}, "players"=>["Easy", "Psycho"], "total_kills"=>1}}
        killer = Player.new(name: 'Psycho')
        victim = Player.new(name: 'Easy')

        subject.add_kill(killer: killer, victim: victim)

        expect(subject.report).to eq expected
      end
    end

    context 'when killer is world' do
      it 'returns blank hash' do
        expected = {"game_1"=>{"kills"=>{"Easy" => -1}, "players"=>["Easy"], "total_kills"=>1}}
        killer = Player.new(name: '<world>')
        victim = Player.new(name: 'Easy')

        subject.add_kill(killer: killer, victim: victim)


        expect(subject.report).to eq expected
      end
    end

    context 'with more than one kill' do
      it 'returns blank hash' do
        expected = {
          "game_1" => {
              "kills"=>{"Easy"=>1, "John Doe"=>1, "Psycho"=>1},
              "players"=>["Easy", "John Doe", "Psycho"], "total_kills"=>3
            },
        }

        killer = Player.new(name: 'Psycho')
        victim = Player.new(name: 'Easy')

        subject.add_kill(killer: killer, victim: victim)

        killer = Player.new(name: 'John Doe')
        victim = Player.new(name: 'Easy')

        subject.add_kill(killer: killer, victim: victim)

        killer = Player.new(name: 'Easy')
        victim = Player.new(name: 'Psycho')

        subject.add_kill(killer: killer, victim: victim)

        expect(subject.report).to eq expected
      end
    end

    context 'with more than one kill including <world>' do
      it 'returns blank hash' do
        expected = {
          "game_1" => {
            "kills"=>{"Easy"=>0, "Psycho"=>0},
            "players"=>["Easy", "Psycho"],
            "total_kills"=>4
          }
        }

        killer = Player.new(name: 'Psycho')
        victim = Player.new(name: 'Easy')

        subject.add_kill(killer: killer, victim: victim)

        killer = Player.new(name: '<world>')
        victim = Player.new(name: 'Psycho')

        subject.add_kill(killer: killer, victim: victim)

        killer = Player.new(name: 'Easy')
        victim = Player.new(name: 'Psycho')

        subject.add_kill(killer: killer, victim: victim)

        killer = Player.new(name: '<world>')
        victim = Player.new(name: 'Easy')

        subject.add_kill(killer: killer, victim: victim)

        expect(subject.report).to eq expected
      end
    end
  end
end
