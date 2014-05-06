jQuery(document).ready(function() { 
// === Popovers === //
    var placement_right = 'right';
    var placement_bottom = 'bottom';
    var placement_left ='left';
    var trigger = 'hover';
    var html = true;
		
   	
	$('#popover_clouds').popover({
	       placement: placement_bottom,
	       content: '<span class="content-small">choose this option to enter settings for the cloud of your choice</span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_cloud_provisioner').popover({
	       placement: placement_bottom,
	       content: '<span class="content-small">Cloud provisioner allows you to configure your own chef repository. Chef is a systems and cloud infrastructure automation framework that makes it easy to deploy servers and applications to any physical, virtual, or cloud location, no matter the size of the infrastructure. <br/>For more information, see <a href="http://docs.opscode.com/" target="_blank">Chef</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_cloud_name').popover({
	       placement: placement_bottom,
	       content: '<span class="content-small">Enter a name to save your cloud. This name can be used to launch an app or service.</span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_aws_group').popover({
	       placement: placement_right,
	       content: '<span class="content-small">A security group is for use with instances either in the EC2-Classic platform or in a specific VPC. <br/><span class="label label-info">For eg. megam, default</span> <br/>For more information, see <a href="http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html" target="_blank">Amazon EC2 Security Groups</a> </span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_aws_image').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Describes one or more of the images (AMIs, AKIs, and ARIs) available to you. Images available to you include public images, private images that you own, and private images owned by other AWS accounts but for which you have explicit launch permissions. <br/><span class="label label-info">For eg. ami-a0074df2</span> <br/>For more information, see <a href="http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/ApiReference-cmd-DescribeImages.html" target="_blank">Amazon EC2 Images</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_aws_flavor').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Amazon EC2 instance types are composed of varying combinations of CPU, memory, storage, and networking capacity and give you the flexibility to choose the appropriate mix of resources for your applications.<br/><span class="label label-info">For eg. t1.micro, m3.xlarge</span> <br/>For more information, see <a href="http://aws.amazon.com/ec2/instance-types/instance-details/" target="_blank">Amazon EC2 Instance sizes</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_aws_region').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Amazon Web Services products allow you to select a regional endpoint to make your requests. An endpoint is a URL that is the entry point for a web service.<br/><span class="label label-info">For eg. ap-southeast-1</span> <br/>For more information, see <a href="http://docs.aws.amazon.com/general/latest/gr/rande.html#ec2_region" target="_blank">Amazon EC2 Regions</a> </span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_sshkey').popover({
	       placement: placement_left,
	       content: '<span class="content-small">To log in to your instance, you must create a key pair, specify the name of the key pair when you launch the instance, and provide the private key when you connect to the instance.</span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_sshuser').popover({
	       placement: placement_left,
	       content: '<span class="content-small">The SSH user name.</span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_aws_privatekey').popover({
	       placement: placement_left,
	       content: '<span class="content-small">The SSH private key file used for authentication. Key-based authentication is recommended. <br/><span class="label label-info">For eg. megam_ec2.pem</span> <br/>For more information, see <a href="http://docs.aws.amazon.com/AWSSecurityCredentials/1.0/AboutAWSCredentials.html" target="_blank">Amazon EC2 SSH Private keys</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_aws_publickey').popover({
	       placement: placement_left,
	       content: '<span class="content-small">Imports the public key from an RSA key pair that you created with a third-party tool. Compare this with ec2-create-keypair, in which AWS creates the key pair and gives the keys to you (AWS keeps a copy of the public key). <br/><span class="label label-info">For eg. megam_ec2.pem</span> <br/>For more information, see <a href="http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/ApiReference-cmd-ImportKeyPair.html" target="_blank">Amazon EC2 SSH Public keys</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_aws_accesskey').popover({
	       placement: placement_left,
	       content: '<span class="content-small"> The access key identifier used with Amazon EC2. <br/><span class="label label-info">For eg. AkQ486786JKGHHJKJ</span> <br/>For more information, see <a href="http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html" target="_blank">Amazon EC2 Access keys</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_aws_secretkey').popover({
	       placement: placement_left,
	       content: '<span class="content-small"> The secret access key for the API endpoint used with Amazon EC2. <br/><span class="label label-info">For eg. AkQ486786JKGHHJKJ</span> <br/>For more information, see <a href="http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html" target="_blank">Amazon EC2 Secret keys</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	
	$('#popover_hp_group').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Access to your instances is controlled by security groups which are a collection of rules about which sources, protocols, and ports a server can receive traffic from.  <br/><span class="label label-info">For eg. megam, default</span> <br/>For more information, see <a href="https://community.hpcloud.com/article/managing-your-security-groups" target="_blank">hpcloud Groups</a> </span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_hp_image').popover({
	       placement: placement_right,
	       content: '<span class="content-small">An image file refers to a virtual disk image file that HP Compute service can load up to create a virtual machine. <br/><span class="label label-info">For eg. 75893, 325846</span> <br/>For more information, see <a href="http://docs.hpcloud.com/cli/unix/compute/#ImageCommands-jumplink-span" target="_blank">hpcloud Images</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_hp_flavor').popover({
	       placement: placement_right,
	       content: '<span class="content-small">hpcloud instance types are composed of varying combinations of CPU, memory, storage, and networking capacity and give you the flexibility to choose the appropriate mix of resources for your applications.<br/><span class="label label-info">For eg. 100, 103</span> <br/>For more information, see <a href="http://docs.hpcloud.com/cli/unix/compute/#FlavorCommands-jumplink-span" target="_blank">hpcloud Instance sizes</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_hp_tenantid').popover({
	       placement: placement_right,
	       content: '<span class="content-small">A tenant has access to a collection of resources uniquely associated with the tenant. <br/><span class="label label-info">For eg. 109843566778</span><br/>For more information, see <a href="http://docs.hpcloud.com/api/compute/#2.4Tenants" target="_blank">hpcloud Instance sizes</a>   </span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_hp_zone').popover({
	       placement: placement_right,
	       content: '<span class="content-small">In order to access HP Cloud Compute, the user must specify the endpoint for one of the HP Cloud Availability Zones (AZs). Availability Zones provide separate fault domains for HP Cloud.<br/><span class="label label-info">For eg. az1, az2</span><br/>For more information, see <a href="http://docs.hpcloud.com/api/compute/#3.2RegionsandAvailabilityZones" target="_blank">hpcloud Zones</a> </span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_hp_sshkey').popover({
	       placement: placement_left,
	       content: '<span class="content-small">To log in to your instance, you must create a key pair, specify the name of the key pair when you launch the instance, and provide the private key when you connect to the instance.<br/><span class="label label-info">For eg. megam_hp</span> <br/>For more information, see <a href="https://community.hpcloud.com/article/managing-your-key-pairs" target="_blank">hpcloud SSH keys</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_hp_sshuser').popover({
	       placement: placement_left,
	       content: '<span class="content-small">The SSH user name.</span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_hp_privatekey').popover({
	       placement: placement_left,
	       content: '<span class="content-small">The SSH private key file used for authentication. Key-based authentication is recommended. <br/><span class="label label-info">For eg. megam_hp.pem</span> <br/>For more information, see <a href="https://community.hpcloud.com/article/managing-your-key-pairs" target="_blank">hpcloud SSH Private keys</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_hp_publickey').popover({
	       placement: placement_left,
	       content: '<span class="content-small">Imports the public key from an RSA key pair that you created with a third-party tool.  <br/><span class="label label-info">For eg. id_rsa.pub</span> <br/>For more information, see <a href="https://community.hpcloud.com/article/managing-your-key-pairs" target="_blank">hpcloud SSH Public keys</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_hp_accesskey').popover({
	       placement: placement_left,
	       content: '<span class="content-small"> The access key identifier used with hpcloud. <br/><span class="label label-info">For eg. AkQ486786JKGHHJKJ</span> <br/>For more information, see <a href="https://community.hpcloud.com/article/managing-your-key-pairs" target="_blank">hpcloud Access keys</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_hp_secretkey').popover({
	       placement: placement_left,
	       content: '<span class="content-small"> The secret access key for your hpcloud instance. <br/><span class="label label-info">For eg. AkQ486786JKGHHJKJ</span> <br/>For more information, see <a href="https://community.hpcloud.com/article/managing-your-key-pairs" target="_blank">hpcloud Secret keys</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	
	$('#popover_google_projectname').popover({
	       placement: placement_right,
	       content: '<span class="content-small">In order to interact with Google Compute Engine resources, you must provide identifying project information for every request. A project can be identified two ways: using a project ID, or a project number. A project ID is the customized name you chose when you created the project, or when you activated an API that required you to create a project ID. <br/><span class="label label-info">For eg. turnkey-guild-435</span> <br/>For more information, see <a href="https://developers.google.com/compute/docs/overview#projectids" target="_blank">Google Compute Engine projects</a> </span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_google_group').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Google Compute Engine network in which the instance is running. </span>',
	       trigger: 'hover',
	       html: html   
	    });
	    
	$('#popover_google_image').popover({
	       placement: placement_right,
	       content: '<span class="content-small"> An image resource contains an operating system and root file system necessary for starting your instance. Google maintains and provides images that are ready-to-use or you can customize an image and use that as your image of choice for creating instances. <br/><span class="label label-info">For eg. debian-7-wheezy-v20131120</span> <br/>For more information, see <a href="https://developers.google.com/compute/docs/images" target="_blank">Google Compute Engine Images</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_google_flavor').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Google Compute Engine instance types are composed of varying combinations of CPU, memory, storage, and networking capacity and give you the flexibility to choose the appropriate mix of resources for your applications.<br/><span class="label label-info">For eg. n1-standard-1</span> <br/>For more information, see <a href="https://developers.google.com/compute/pricing" target="_blank">Google Comput Engine Instance sizes</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_google_zone').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Google Compute Engine allows you to choose the region and zone where certain resources live, giving you control over where your data is stored and used. Resources that are specific to a zone or a region can only be used by other resources in the same zone or region.<br/><span class="label label-info">For eg. europe-west1-a</span> <br/>For more information, see <a href="https://developers.google.com/compute/docs/zones" target="_blank">Google Compute Engine Zones</a> </span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	
	$('#popover_google_sshuser').popover({
	       placement: placement_right,
	       content: '<span class="content-small">The SSH user name.</span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	
	$('#popover_google_publickey').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Imports the public key from an RSA key pair that you created with a third-party tool. <br/><span class="label label-info">For eg. id_rsa.pub</span> <br/>For more information, see <a href="https://developers.google.com/compute/docs/console" target="_blank">Google Compute Engine SSH Public keys</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_google_clientid').popover({
	       placement: placement_right,
	       content: '<span class="content-small"> The client id for Google Compute Engine projects  <br/><span class="label label-info">For eg. 953918801303-dnh7p9gosos1f9dfbtbd545vkmpbp4nq.apps.googleusercontent.com</span> <br/>For more information, see <a href="https://developers.google.com/compute/docs/api/how-tos/authorization" target="_blank">Google Compute Engine clientID</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_google_secretkey').popover({
	       placement: placement_right,
	       content: '<span class="content-small"> The secret access key for the API endpoint used with . <br/><span class="label label-info">For eg. AkQ486786JKGHHJKJ</span> <br/>For more information, see <a href="https://developers.google.com/compute/docs/api/how-tos/authorization" target="_blank">Google Compute Engine Secret keys</a></span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	//popovers for services .
	$('#popover_servicemodel_onlyforyou').popover({
	       placement: placement_right,
	       content: '<span class="content-small"> This stands up a selected service only for you on the cloud of your choice. </span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_servicemodel_managed').popover({
	       placement: placement_right,
	       content: '<span class="content-small"> The stands up a selected service in the shared megam managed environment. </span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_dashboard_cloud').popover({
	       placement: placement_bottom,
	       content: '<span class="content-small"> Indicates the cloud on which the app/service is stood up. To view the cloud settings, Choose Settings > Cloud from your left sidebar.</span>',
	       trigger: 'hover', 
	       html: html   
	    });
	
	$('#popover_dashboard_monitor').popover({
	       placement: placement_right,
	       content: '<span class="content-small"> Choose this option to monitor this cloud app/service. </span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_sshkey_new').popover({
	       placement: placement_bottom,
	       content: '<span class="content-small">Choose this option to generate a new SSH key pair, using RSA algorithm and 1024 bit.</span>',
	       trigger: 'hover', 
	       html: html   
	    });
	
	$('#popover_sshkey_import').popover({
	       placement: placement_bottom,
	       content: '<span class="content-small"> Choose this option to import your own key pair. </span>',
	       trigger: 'hover',
	       html: html   
	    });
	
	$('#popover_datacenter').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Already existed Datacenter_name in which your server has to be launced.</span>',
	       trigger: 'hover',
	       html: html   
	    });
	    
	$('#popover_image').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Already existed image_name by which your server has to be launced.</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_snapshot').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Already existed snapshot_name by which your server has to be launced.</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_pb_image_password').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Password of image or snapshot which you specified above.</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_pb_hdd').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Size of your server\'s HDD Storage.</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_pb_ram').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Server\'s RAM(Memmory) size(In the multiple of 256).</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_pb_cpus').popover({
	       placement: placement_right,
	       content: '<span class="content-small">No. of cores(cpus) needed for your server.</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_pb_ram').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Server\'s RAM(Memmory) size(In the multiple of 256).</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_pb_useremail').popover({
	       placement: placement_left,
	       content: '<span class="content-small">Profitbricks user email to access your account.</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_pb_password').popover({
	       placement: placement_left,
	       content: '<span class="content-small">Profitbricks user password to access your account.</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_gogrid_flavor').popover({
	       placement: placement_right,
	       content: '<span class="content-small">Storage size for your new server.</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_gogrid_api_key').popover({
	       placement: placement_left,
	       content: '<span class="content-small">gogrid cloud\'s api key to access your account.</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_gogrid_shared_secret').popover({
	       placement: placement_left,
	       content: '<span class="content-small">gogrid cloud\'s shared_secret key to access your account.</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_opennebula_template').popover({
	       placement: placement_left,
	       content: '<span class="content-small">Virtual Resources template_name.</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_opennubula_endpoint').popover({
	       placement: placement_left,
	       content: '<span class="content-small">Opennebula Endpoint. Eg: http://my_nebula.com:2633/RPC2</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_opennebula_username').popover({
	       placement: placement_left,
	       content: '<span class="content-small">Your opennebula Username.</span>',
	       trigger: 'hover',
	       html: html   
	});
	
	$('#popover_opennebula_password').popover({
	       placement: placement_left,
	       content: '<span class="content-small">Your opennebula user_password.</span>',
	       trigger: 'hover',
	       html: html   
	});
});




