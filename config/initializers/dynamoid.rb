  Dynamoid.configure do |config|
    #config.adapter = 'local' # This adapter allows offline development without connecting to the DynamoDB servers. Data is *NOT* persisted.
     config.adapter = 'aws_sdk' # This adapter establishes a connection to the DynamoDB servers using Amazon's own AWS gem.
     config.access_key = 'AKIAJQYJB7IUCXKWIF4A' # If connecting to DynamoDB, your access key is required.
     config.secret_key = '5CThMfu6BL9iSniO2EnwbPh1sZs9MLBzq+efobSo' # So is your secret key. 
    config.namespace = "dev" # To namespace tables created by Dynamoid from other tables you might have.
    config.warn_on_scan = true # Output a warning to the logger when you perform a scan rather than a query on a table.
    config.partitioning = false # Spread writes randomly across the database. See "partitioning" below for more.
    config.partition_size = 0  # Determine the key space size that writes are randomly spread across.
    config.read_capacity = 10 # Read capacity for your tables
    config.write_capacity = 10 # Write capacity for your tables
    config.endpoint = 'dynamodb.ap-southeast-1.amazonaws.com' # Set the regional endpoint
  end

