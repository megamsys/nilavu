<?php include('includes/header.php') ?>

<div class="container main-cover">
  <div class="row">
    <div class="col-xs-12 col-sm-4 col-md-3 col-lg-3 col-xl-3 c_bg_white cover">
      <div class="row">
        <div class="page-sidebar navbar-collapse collapse"> 
          <!-- BEGIN SIDEBAR MENU -->
          <?php include('includes/menu.php') ?>
          <!-- END SIDEBAR MENU --> 
        </div>
      </div>
    </div>
    <div class="rt-box col-xs-12 col-sm-8 col-md-9 col-lg-9 col-xl-9">
      <div class="row c_pading-b15 settings_top">
        <div class="margin_15">
          <div class="col-xs-12 col-sm-6 col-md-7">
            <h3> Billing </h3>
          </div>
        </div>
      </div>
      
     <div>
      <div class="row c_pading-b15">
        <div class="portlet-body-head">
          <div class="col-xs-9 col-sm-9 col-md-9 col-lg-9 col-xl-9"><i class="fa fa-list-alt"></i>Your Funds</div>
        </div>
      </div>
      <div class="bottom-divider  settings_top"></div>
      <div class="row c_pading-b15">
        <div class="col-md-4 help_center_left">
          
             <div class="balance">
             	<h2>Current balance:</h2>
             	<span class="green">$15.00</span>
				
             	<h2>Current usage:</h2>
             	<span class="blue">$10.00</span><br>
				<span>/month</span>
			<!-- Question mark here and when hovered/clicked it should show the following tooltip: "Your current balance is deducted hourly based on your current usage."
            -->
             </div>
        </div>
        <div class="col-md-8 help_center_left_right usg">
		<div class="center title">Usage Estimator:</div>
		<div class="center sub-title">Resources</div>
          <div style="text-align: center;" class="table-condensed">
            <table class="table usg_table">
              <thead>
                <tr>
                  <th style="width: 30%;text-align:center;">Quotas</th>
                  <th style="width: 30%;text-align:center;">Type</th>
                  <th style="width: 40%;text-align:center;">Cost</th>
                </tr>
              </thead>
              <tbody>
                <tr><!--Any span.blue text is supposed to be editable by the user. with the numbers (eg. 1024) -> it turns into a textbox that only accepts numbers. If MB/SSD is clicked then you will be able to see 'MB/GB/TB' for MB & SSD/HDD for SSD in a dropdown. Once the user enters the new number then the Usage estimator is updated. Also with CORES - the way it works is it's bundled with RAM. This is to avoid heavy CPU abuse. It's a preset of something like 1 vCPU per 2048MB ram, anything under 2048 gets 1vCPU.  -->
                  <td><span class="blue">1024 MB</span></td>
                  <td>RAM</td>
                  <td class="left-b">$7.00/mo</td>
                </tr>
                <tr>
                  <td>1</td>
                  <td>CORE/S</td>
                  <td class="left-b">included</td>
                </tr>
                <tr>
                  <td><span class="blue">10</span> <span class="blue">GB</span></td>
                  <td><span class="blue">SSD</span></td>
                  <td class="left-b">$2.50/mo</td>
                </tr>
                <tr>
                  <td><span class="blue">200</span> <span class="blue">GB</span></td>
                  <td>BANDWIDTH</td>
				  <td class="left-b">included</td>
                </tr>
                <tr>
                  <td class="bottom-b"><span class="blue">1</span></td>
                  <td class="bottom-b">IPv4</td>
				  <td class="left-b bottom-b">included</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
		<div class="row">
			<div class="col-md-8 col-md-offset-4">
				<div class="col-md-4 col-md-offset-1">
					<div class="hour">
						$0.136/hour
					</div>
				</div>
				<div class="col-md-2">
					<div class="mod">
						<img src="assets/img/dot.png"> - click to modify
					</div>
				</div>
				<div class="col-md-4">
					<div class="hour">
						$10.00/month
					</div>
				</div>
			</div>
		</div>
      </div>
      <div class="bottom-divider  settings_top"></div>
      </div>
      
      <div class="row">
        <div class="margin_30 ">
          <div class=" card-details ">

             <div class="row "> 
            <div class="col-md-6  pay_via"> 
            <h2><i class="fa fa-credit-card"></i>Proceed to payment</h2>
            <div class="bottom-divider  settings_top"></div>
<!--            One click login into WHMCS page: 'add funds'.
-->
            <div class="center-btn">
            	<button type="button" class="btn btn-primary btn-payment">CLICK TO ADD FUNDS</button>
            </div>
             </div>
             <div class="col-md-5 col-md-offset-1 help_center_left_right">
          <h2><i class="fa fa-plus-circle"></i>HELP CENTER</h2>
                      <div class="bottom-divider  settings_top"></div>

          <p>If you need assistance while placing
            order, contact one of our below 
            Project Manager  by phone or email.</p>
          <h3><i class="fa fa-phone-square"></i> +91-9745544422 / <a href="mailto:help@megam.io"> <i class="fa fa-envelope-o"></i> help@megam.io</a></h3>
        </div>
              </div>
              
            <div class="bottom-divider  settings_top"></div>
            <div class="col-md-12 row">
              <h2><i class="fa fa-history"></i> Billing History :</h2>
            </div>
<!--HERE Let's use the new Logs we are using for Torpedo. With two forms of alerts: 'Usage' &  'Credit'. Whenever a user adds credit, it should be logged here. And for every service the ueser has there is a log of 'Usage'. The usage will store things such as 'Torpedo ID', 'Torpedo IP', 'Name', 'Cost per hour', 'Running for' x (hours/days/months), State (active or 'complete' which is what a deleted vm becomes). 'Total Cost'. When aligning the data, active VM's must always prioritize over 'Completed' VM's in the log. That means, whenever a VM becomes complete - it goes under the active VM's.-->
            <div class="bottom-divider  settings_top"></div>
            <div class="col-md-12 row">
              <div class="table-responsive" id="bill_history">
                <table class="table">
                  <thead>
                    <tr>
                      <th>Type</th>
                      <th>Name</th>
                      <th>Price</th>
                      <th>Status</th>
                      <th>TimeSTAMP</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Bit Coin</td>
                      <td>nano.megam.io</td>
                      <td>5$</td>
                      <td>Success</td>
                      <td>May 16, 20:19 PM</td>
                    </tr>
                    <tr>
                      <td>Pay Pal</td>
                      <td>nano.megam.io</td>
                      <td>5$</td>
                      <td>Success</td>
                      <td>May 16, 20:19 PM</td>
                    </tr>
                    <tr>
                      <td>Pay Pal</td>
                      <td>nano.megam.io</td>
                      <td>5$</td>
                      <td>Success</td>
                      <td>May 16, 20:19 PM</td>
                    </tr>
                    <tr>
                      <td>Bit Coin</td>
                      <td>nano.megam.io</td>
                      <td>5$</td>
                      <td>Success</td>
                      <td>May 16, 20:19 PM</td>
                    </tr>
                    <tr>
                      <td>Bit Coin</td>
                      <td>nano.megam.io</td>
                      <td>5$</td>
                      <td>Success</td>
                      <td>May 16, 20:19 PM</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
            
      </div>
			
<!--			Let's also place a monthly usage graph here, which displays the users previous months usages only when they have been an active subscriber for a minimum of 30 days. So it will show each months usage for upto a whole year. Once that occurs, then a new graph is placed on top for 'yearly' usage which logs that years spending. -->
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</div>
<?php include('includes/footer.php') ?>
