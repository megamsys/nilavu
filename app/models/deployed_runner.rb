require 'deployed'

class DeployedRunner

  def self.perform_run(params)
    @type = params[:type]
    @params = params
    assembly_item = find_by(params)
    if assembly_item
      return  Deployed.new(assembly_item)
    end

    raise Nilavu::NotFound
  end

  private

  def self.find_by(params)
    @id = params[:id]

    return Nilavu::InvalidParameters unless @id

    run_assembly_fold_by_type
  end

  def self.run_assembly_fold_by_type
    got_assembly = run_assembly
    return Nilavu::NotFound unless got_assembly

    got_assembly.baked.first
  end

  def self.run_assembly
    Api::Assembly.new.show(@params)
  end

end
