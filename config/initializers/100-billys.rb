## Register all the 3rd party billers if enabled
if SiteSetting.allow_billys do
  Nilavu.billys.each do |billy|
    billy.register
  end
end
