# The module that will generically implement billings for
# Blesta, WHMCS, default (if we do it), any others based 
#
#
# Define WHMCS URL & AutoAuth Key
# $whmcsurl = "http://demo.whmcs.com/dologin.php";
# $autoauthkey = "abcXYZ123";

# $timestamp = time(); # Get current timestamp
# $email = "demo@whmcs.com"; # Clients Email Address to Login
# $goto = "clientarea.php?action=products";

# $hash = sha1($email.$timestamp.$autoauthkey); # Generate Hash

# Generate AutoAuth URL & Redirect
# $url = $whmcsurl."?email=$email&timestamp=$timestamp&hash=$hash&goto=".urlencode($goto);
# header("Location: $url");
# exit;
