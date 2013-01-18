module CloudIdentitiesHelper

 def account_name
    @name = current_user.organization.name.gsub(/[^0-9A-Za-z]/, '')
    @name = @name.gsub(" ", "")
    if @name.length > 10
    	@account_name = @name.slice(0,10)
    else
    	@account_name = @name
    end
 end

end
