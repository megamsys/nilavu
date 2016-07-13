require 'docker_registry'

class DockerHub

    DOCKER = "docker".freeze
    MICROSERVICE = "MICROSERVICE".freeze

    def self.limit
      5
    end

    def self.search(term)
        results = []

        registry = DockerRegistry::Registry.new("https://registry.hub.docker.com")

        return results unless registry

        results = registry.search(term)

        fill_hubitems(results)
    end

    private

    def self.fill_hubitems(results)
        results = results.length > limit ? results.take(5) : results

        results.map do |hubi|
            fill_hubitem(hubi)
        end
    end

    def self.fill_hubitem(hubi)
        md =  hubi.metadata
        {
            id:   "",
            name: hubi.name,
            provider: official_or_others(md[:is_official], hubi.name),
            category: MICROSERVICE,
            cattype: MICROSERVICE,
            logo: ensure_logo_is_filled(md),
            versions: ensure_versioned(md),
            options: [{key: :is_official, value: md[:is_official]}, {key: :is_trusted, value: md[:is_trusted]}, {key: :star_count, value: md[:star_count]}],
            envs: []
        }
    end

    def self.ensure_logo_is_filled(md)
        return 'dockercontainer.png' if md[:is_official]
    end

    def self.ensure_versioned(md)
        []
    end

    def self.official_or_others(official, name)
      return DOCKER if official

      return name.split('/')[0] if name.include?('/')

      name
    end

    # take a while to load
    #def self.ensure_we_tagged(hubi)
    #
    #   return hubi.tags
    #end
end
