##
## Copyright [2013-2016] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIE  S OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##

class CephUser
  include GWUser

  attr_accessor :id
  attr_accessor :email
  attr_accessor :access_key_id
  attr_accessor :secret_access_key
  attr_accessor :name
  attr_accessor :created_at
  attr_accessor :errors

  alias :access_key= :access_key_id=
  alias :secret_key= :secret_access_key=

  def self.new_from_params(params)
    user = CephUser.new
    params.symbolize_keys!
    user.email = params[:user_id]

    user.name = params[:name]
    user.access_key_id = params[:access_key]
    user.secret_access_key = params[:secret_key]
    user.created_at = params[:created_at]
    user
  end

  def self.suggest_name(email)
    return "" if email.blank?
    email[/\A[^@]+/].tr(".", " ").titleize
  end

  def find_by_email
    if to_hash[:email].include?('@')
      find
    end
  end

  def save
    if saved = GWUser.save(@email, CephUser.suggest_name(email))
      puts "-------------------------------------------"
      puts saved
      if saved.is_a? String
        return false
     end
      saved.each { |k, v| send("#{k}=", v) }
      saved
    end
  end

  def email_available?
    GWUser.exists?(@email)
  rescue Nilavu::NotFound => e
    false
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

  def to_hash
    {:email => @email,
      :access_key_id => @access_key_id,
      :secret_access_key => @secret_access_key,
      :name => CephUser.suggest_name(@email),
      :created_at => @created_at
    }
  end

  private


  def find
    if email_available?
      return CephUser.new_from_params(GWUser.find_by_email(@email))
    end
  end

  def visit_record_for(date)
    #events.last_seen_at(visited_at: date)
  end
end
