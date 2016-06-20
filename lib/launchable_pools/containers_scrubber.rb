class ContainersScrubber < Scrubber

    def name
        "containers"
    end

    def scrubbed(auth_hash)
      #  session_info = parse_hash(auth_hash)
      #  google_hash = session_info[:google]

      #  result = Auth::Result.new
      #  result.email = session_info[:email]
      #  result.email_valid = session_info[:email_valid]
      #  result.first_name = google_hash[:first_name]

      #  result.extra_data = google_hash
      #  result
    end

    def after_scrubbed(user, auth)
      #  data = auth[:extra_data]
    end

    def register_honeypot(data)
        @data = data
    end

    protected

    def parse_hash(hash)
      #  extra = hash[:extra][:raw_info]

      #  h = {}

      #  h[:email] = hash[:info][:email]
      #  h[:name] = hash[:info][:name]
      #  h[:email_valid] = hash[:extra][:raw_info][:email_verified]

      #  h[:google] = {
      #      google_user_id: hash[:uid] || extra[:sub],
      #      email: extra[:email],
      #      first_name: extra[:given_name],
      #      last_name: extra[:family_name],
      #      gender: extra[:gender],
      #      name: extra[:name],
      #      link: extra[:hd],
      #      profile_link: extra[:profile],
      #      picture: extra[:picture]
      #  }

      #  h
    end
end
