module OneappsHelper

  def change_runtime(deps, runtime)
    project_name = File.basename(deps).split(".").first
    if /<projectname>/.match(runtime)
      runtime["unicorn_<projectname>"] = "unicorn_" + project_name
    end
    runtime
  end
end
