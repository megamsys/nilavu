module CloudIdentitiesHelper

 def account_name
    @name = current_user.organization.name.gsub(/[^0-9A-Za-z]/, '')
    @name = @name.gsub(" ", "")
    if @name.length > 10
    	@account_name = @name.slice(0,10)
	@account_name = @account_name.downcase
    else
    	@account_name = @name
	@account_name = @account_name.downcase
    end
 end

end
