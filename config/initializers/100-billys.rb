if SiteSetting.allow_billings do
  Nilavu.billys.each do |billy|
    billy.register
  end
end
