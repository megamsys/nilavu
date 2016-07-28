class SnapshotsFinder

  attr_accessor :foundsnapshots

  def initialize(params)
      find_snapshots(params) if should_pull_snapshots?
  end

  def has_snapshots?
    return snapshots_strip && snapshots_strip.length > 0
  end

  def snapshots_strip
    @foundsnapshots.map {|snap| snap[:name] }
  end

  private


  def should_pull_snapshots?
    true
  end

  def find_snapshots(params)
    @foundsnapshots ||= load_snapshots(params)
  end

  def load_snapshots(params)
    Api::Snapshots.new.perlist(params).snapshots_per
  end
end
