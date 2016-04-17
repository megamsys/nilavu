class StylesheetsController < ApplicationController

  skip_before_filter :preload_json,
  :redirect_to_login_if_required,
  :check_xhr, only: [:show]

  def show

    no_cookies

    target,digest = params[:name].split(/_([a-f0-9]{40})/)
    
    cache_time = request.env["HTTP_IF_MODIFIED_SINCE"]
    cache_time = Time.rfc2822(cache_time) rescue nil if cache_time

    # Security note, safe due to route constraint
    underscore_digest = digest ? "_" + digest : ""
    location = "#{Rails.root}/#{NilavuStylesheets::CACHE_PATH}/#{target}#{underscore_digest}.css"

    if location
      handle_missing_cache(location, target, digest)
    else
      raise Nilavu::NotFound
    end

    send_file(location, disposition: :inline)
  end

  protected

  def handle_missing_cache(location, name, digest)
    existing = File.read(location) rescue nil
    if existing && digest
      StylesheetCache.add(name, digest, existing)
    end
  end

end
