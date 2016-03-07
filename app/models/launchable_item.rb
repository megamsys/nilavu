require_dependency 'sshkeys_finder'

class LaunchableItem

  attr_accessor :versions, :sshfinder, :marketplace_item

  def initialize(params, marketplace_item)
    @marketplace_item = marketplace_item

    ensure_version_is_flattened

    find_sshkeys(params)
  end

  def self.reload_cached_item!(params)
    HoneyPot.cached_marketplace_by_item(params)
  end

  def type
    Nilavu.default_categories.select { |i| i == @marketplace_item.cattype.downcase }.first
  end

  #flag abused words ?
  def generate_random_name
    random_name = /\w+/.gen.downcase
  end

  def name
    @marketplace_item.flavor
  end

  def cattype
    @marketplace_item.cattype
  end

  def logo
    @marketplace_item.image
  end

  def selected_version
    @versions.first if versions
  end

  def description
    if plan = find_plan_for(selected_version)
      return plan[1]
    end
  end

  def envvars_json
    Oj.dump(@marketplace_item.envs)
  end

  def envs
    @marketplace_item.envs
  end

  def has_docker?
    name.include? Api::Assemblies::DOCKERCONTAINER
  end

  # from a bunch of plans, we match the plan for a version
  # eg: debian jessie 7, 8
  def find_plan_for(version)
    @marketplace_item.plans.select { |v, d| v == version }.reduce { :merge }
  end


  private

  def ensure_version_is_flattened
    @versions = @marketplace_item.plans.map { |v, d| v }.sort
  end

  def find_sshkeys(params)
    @sshfinder ||= SSHKeysFinder.new(params)
  end

end
