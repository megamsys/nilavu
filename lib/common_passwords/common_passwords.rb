# CommonPasswords will check a given password against a list of the most commonly used passwords.
# The list comes from https://github.com/danielmiessler/SecLists/tree/master/Passwords
# specifically the list of 10 million passwords, top 100k, filtered by length
#
# The list is stored in Redis at a key that is shared by all sites in a multisite config.
#
# If the password file is changed, you need to add a migration that deletes the list from redis
# so it gets re-populated:
#
#   $redis.without_namespace.del CommonPasswords::LIST_KEY

class CommonPasswords

    PASSWORD_FILE = File.join(Rails.root, 'lib', 'common_passwords', '10-char-common-passwords.txt')
    LIST_KEY = 'nilavu-common-passwords'

    @mutex = Mutex.new

    def self.common_password?(password)
        return false unless password.present?
        password_list.include?(password)
    end

    private

    class CachePasswordList
        def include?(password)
            CommonPasswords.loaded[CommonPasswords::LIST_KEY].include?(password)
        end
    end

    def self.password_list
        @mutex.synchronize do
            load_passwords
        end
        CachePasswordList.new
    end

    # here we should have loaded it, as we wait
    def self.loaded
        load_passwords
    end

    def self.load_passwords
        Rails.cache.fetch(LIST_KEY, race_condition_ttl: 20) do
            passwords = File.readlines(PASSWORD_FILE)
            loaded ||= {}
            passwords.map!(&:chomp).each do |pwd|
                loaded[LIST_KEY] << pwd
            end
            loaded
        end
    rescue Errno::ENOENT
       Rails.logger.error "Common passwords file #{PASSWORD_FILE} is not found! Common password checking is skipped."
    end
end
