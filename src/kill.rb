class Kill
  attr_reader :killer, :victim

  def initialize(killer:, victim:)
    @killer = killer
    @victim = victim
  end
end
