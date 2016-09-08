class User

    attr_accessor :id
    attr_accessor :email
    attr_accessor :password
    attr_accessor :api_key
    attr_accessor :team
    attr_accessor :first_name
    attr_accessor :last_name
    attr_accessor :authority
    attr_accessor :password_reset_key
    attr_accessor :password_reset_sent_at
    attr_accessor :created_at
    attr_accessor :phone
    ### new
    attr_accessor :email_verified
    attr_accessor :phone_verified
    attr_accessor :staged
    attr_accessor :active
    attr_accessor :approved
    attr_accessor :approved_by_id
    attr_accessor :approved_at
    attr_accessor :suspended
    attr_accessor :suspended_at
    attr_accessor :suspended_till
    attr_accessor :blocked
    attr_accessor :last_posted_at
    attr_accessor :last_emailed_at
    attr_accessor :previous_visit_at
    attr_accessor :first_seen_at
    attr_accessor :registration_ip_address

    attr_accessor :errors

    ADMIN = 'admin'.freeze

    def self.max_password_length
        200
    end

    def self.new_from_params(params)
        user = User.new
        params.symbolize_keys!
        params.each { |k, v| user.send("#{k}=", v) }
        user
    end


   ### TO-DO: Move the stuff specific to api_key to ApiKey model
    def find_by_apikey
        user = Api::Accounts.new.where(parms_using_apikey)

        if user
            return User.new_from_params(user.expanded)
        end
    end

    def find_by_email
        ensure_password_is_hashed
        if to_hash[:email].include?('@')
            find_by_password
        end
    end


    def save
        ensure_password_is_hashed
        Api::Accounts.new.save(to_hash)
    end

    def update
        Api::Accounts.new.update(update_hash)
    end

    def reset
        Api::Accounts.new.reset(to_hash)
    end

    def repassword
        Api::Accounts.new.repassword(update_hash)
    end

    def email_available?
        find_by_email
    rescue Nilavu::NotFound => e
        false
    end

    def password=(password)
        unless password.blank?
            @raw_password = password
        end
    end

    # Indicate that this is NOT a passwordless account for the purposes of validation
    def password_required!
        @password_required = true
    end

    def password_required?
        !!@password_required
    end

    def has_password?
        password_hash.present?
    end

    def confirm_password?(password)
        return false unless password && @raw_password
        password == password_hash(@raw_password)
    end

    def email_confirmed?
        true
    end

    def ensure_password_is_hashed
        if @raw_password
            self.password = hash_password(@raw_password)
        end
    end

    def hash_password(password, salt="")
        raise "password is too long" if password.size > User.max_password_length
        Base64.strict_encode64(password)
    end

    def password_hash(password)
        Base64.strict_decode64(password)
    end

    def admin?
        if authority
            return authority.include?("admin")
        end
        false
    end

    def staff?
        admin? && Rails.env.development?
    end

    # Approve this user
    def approve(approved_by, send_mail=true)
        self.approved = true

        if approved_by.is_a?(Fixnum)
            self.approved_by_id = approved_by
        else
            self.approved_by = approved_by
        end

        self.approved_at = Time.now

        save
    end

    def activate
        self.active = true
        save
    end

    def deactivate
        self.active = false
        save
    end

    def suspended?
        suspended_till && suspended_till > DateTime.now
    end

    ## Looks like we need a table to store user_history to record
    ##    def suspend_record
    ##        UserHistory.for(self, :suspend_user).order('id DESC').first
    ##    end
    ##
    ##    def suspend_reason
    ##        suspend_record.try(:details) if suspended?
    ##    end
    ##

    def update_ip_address!(new_ip_address)
        unless @registration_ip_address == new_ip_address || new_ip_address.blank?
            @registration_ip_address =  new_ip_address
            update
        end
    end

    def update_last_seen!(now=Time.zone.now)
        now_date = now.to_date
        update_previous_visit(now)
        update(:last_seen_at, now)
        update(:first_seen_at, now) unless self.first_seen_at
    end

    def new_user?
    created_at >= 24.hours.ago && !staff?
  end

    def seen_before?
        last_seen_at.present?
    end

    def org_id
        team.id if team
    end

    def to_hash
        {email: @email,
            api_key: @api_key,
            password: @raw_password,
            password_reset_key: @password_reset_key,
            password_reset_sent_at: @password_reset_sent_at,
            first_name:@first_name,
            last_name: @last_name,
            phone: @phone,
            created_at: @created_at,
            phone_verified: @phone_verified,
            email_verified: @email_verified,
            staged: @staged,
            active: @active,
            authority: @authority,
            approved: @approved,
            approved_by_id: @approved_by_id,
            approved_at: @approved_at,
            suspended: @suspended,
            suspended_at: @suspended_at,
            suspended_till: @suspended_till,
            blocked: @blocked,
            last_posted_at: @last_posted_at,
            last_emailed_at: @last_emailed_at,
            previous_visit_at: @previous_visit_at,
            first_seen_at: @first_seen_at,
            registration_ip_address: @registration_ip_address
        }
    end

    def update_hash
        {:email => @email,
            :api_key => @api_key,
            :password => @raw_password,
            :password_reset_key => @password_reset_key,
            :password_reset_sent_at => @password_reset_sent_at,
            :first_name => @first_name,
            :last_name => @last_name,
            :phone => @phone,
            :created_at =>@created_at,
            phone_verified: @phone_verified,
            email_verified: @email_verified,
            authority: @authority,
            staged: @staged,
            active: @active,
            approved: @approved,
            approved_by_id: @approved_by_id,
            approved_at: @approved_at,
            suspended: @suspended,
            suspended_at: @suspended_at,
            suspended_till: @suspended_till,
            blocked: @blocked,
            last_posted_at: @last_posted_at,
            last_emailed_at: @last_emailed_at,
            previous_visit_at: @previous_visit_at,
            first_seen_at: @first_seen_at,
            registration_ip_address: @registration_ip_address
        }
    end

    private

    def parms_using_password
        {:email =>@email, :password => @raw_password }
    end
    def parms_using_apikey
        {:email =>@email, :api_key => @api_key}
    end

    def find_by_password
        user = Api::Accounts.new.where(parms_using_password)
        if user
            return User.new_from_params(user.expanded)
        end
    end

    def previous_visit_at_update_required?(timestamp)
        seen_before? && (last_seen_at < (timestamp - SiteSetting.previous_visit_timeout_hours.hours))
    end

    def update_previous_visit(timestamp)
        if previous_visit_at_update_required?(timestamp)
            update(:previous_visit_at, last_seen_at)
        end
    end
end
