class ReadyLaunch

  attr_accessor :versions, :existing_sshkeys, :marketplace_item

  ONE              =  'one'.freeze
  DOCKER           =  'docker'.freeze
  BAREMETAL        =  'baremetal'.freeze

  def initialize(params, marketplace_item)
    @marketplace_item = marketplace_item

    ensure_version_is_flattened

    find_sshkeys(params) if should_pull_sshkey?
  end

  def type
    "torpedo"
  end

  #flag abused words ?
  def generate_random_name
    random_name = /\w+/.gen.downcase
  end

  def name
    @marketplace_item.flavor
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

  def envvars
    Oj.dump(@marketplace_item.envs)
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

  def should_pull_sshkey?
    true
  end

  def find_sshkeys(params)
    @existing_sshkeys ||= Api::Sshkeys.new.list(params).ssh_keys
  end
end
