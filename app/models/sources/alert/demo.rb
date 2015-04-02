##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
module Sources
    module Alert
        class Demo < Sources::Alert::Base

            WARNING_MESSAGES = ["Disk is 50% full!",
                "Responce time is 30% lower than yesterday",
                "Usage ratio increased by 50%",
                "CPU workload 48%",
                "Database responce time is above the maximal"]

            ERROR_MESSAGES = ["Process XXX is not responding!",
                "Can't write to the disk!",
                "Web page is down!",
                "Jenkins build failed!",
                "Data writing aborted!"]

            def available?
                true 
            end

            def get(options = {})

                rand_value = rand(0..3)
                which_message = rand(0..4)
                
                label = case rand_value
                when 0
                    "System status OK"
                when 1
                    WARNING_MESSAGES[which_message]
                when 2
                    ERROR_MESSAGES[which_message]
                else
                    "Unknown System Status!"
                end

                Rails.logger.debug("The value is #{rand_value} and the label is #{label}")

                {:value => rand_value ,:label =>"DemoClient: RandomClient<br/>DemoCheck: RandomCheck<br/>DemoMessage: #{label}<br/><br/>"*5 }
            end

        end
    end
end