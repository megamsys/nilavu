class PrepackagedScrubber < Scrubber

    ONECLICK = "oneclick".freeze


    def name
        "prepackaged"
    end

    def scrubbed(auth_token)
      #  result = Auth::Result.new

      #  data = auth_token[:info]

      #  result.token = auth_token['credentials']['token']

      #  result.first_name = screen_name = data["nickname"]
      #  result.email = email = data["email"]

      #  github_user_id = auth_token["uid"]

      #  result.extra_data = {
      #      github_user_id: github_user_id,
      #      github_screen_name: screen_name,
      #  }

      #  result.email_valid = !!data["email_verified"]
      #  result
    end

    #upon account creation, do something
    def after_scrubbed(result)
    end


    def register_honeypot(data)
        @data = data
    end
end
