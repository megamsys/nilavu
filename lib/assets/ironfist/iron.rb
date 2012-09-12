require 'ruby-progressbar'
require './ironfist_client'
require './ironfist_output'

class IronTest
  def run
    # @pb =  ProgressBar.create(:title => "Ironfist client....", :starting_at => 0, :total => 100)
    ir = IronfistClient.new
    tempparms = {:agent => "CloudIdentityAgent", :command => "listRealms", :message => "URL=http://nomansland.com REALM_NAME=temporealm"}
    # @pb.progress += 15
    ir.pub_and_wait(Ironfist::Init.instance.connection, tempparms,0) do |resp|
      puts "result #{resp}"
    end
  # @pb.progress += 85
     puts "done."

  end

end

iront = IronTest.new
iront.run
