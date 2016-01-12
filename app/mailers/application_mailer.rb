##
## Copyright [2013-2016] [Megam Systems]
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
require 'net/smtp' if Ind.notification.use =="smtp"
require 'mailgunner' if Ind.notification.use =="mailgun"
class ApplicationMailer < ActionMailer::Base
	default from: Ind.notification.smtp.email
	attr_reader :delivery_status
	attr_reader :account

	class MegamNotifiError < StandardError; end

	# a common method that gets called by all the mailers.
	def wrap_mail(tmp_params, &_block)
		if Ind.notification.enable
			begin
				@account = tmp_params[:account]
				@delivery_status = mail(to: @account.email, subject: tmp_params[:subject]).delivery_status_report?
				Rails.logger.debug "> #{account.email}] => #{tmp_params[:subject]} delivered. "
			rescue Exception => sme
				raise MegamNotifiError, sme.message
			end
		end
		yield self if block_given?
	end
end
