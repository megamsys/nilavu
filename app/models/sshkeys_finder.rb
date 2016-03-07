class SSHKeysFinder

  attr_accessor :foundkeys

  def initialize(params)
      find_sshkeys(params) if should_pull_sshkey?
  end

  def has_sshkeys?
    return sshkeys_strip && sshkeys_strip.length > 0
  end

  def sshkeys_strip
    @foundkeys.map {|ssh| ssh[:name] }
  end

  private


  def should_pull_sshkey?
    true
  end

  def find_sshkeys(params)
    @foundkeys ||= load_sshkeys(params)
  end

  def load_sshkeys(params)
    Api::Sshkeys.new.list(params)
  end
end
