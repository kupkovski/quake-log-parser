# frozen_string_literal: true

# Class responsible to handle information about each kill
class Kill
  attr_reader :killer, :victim

  def initialize(killer:, victim:)
    @killer = killer
    @victim = victim
  end
end
