<?php include('includes/header.php') ?>
<!DOCTYPE html>
<html>
<head>
    <title></title>
</head>
<body>
<section id="collection" class="collection">
    <div class="container pushdown">
        <div class="row c_pading-b15 settings_top">
            <div class="margin_15">
                <div class="col-xs-12 col-md-8 col-md-offset-2">
                    <div class="welcome-text">
                        <h3>Welcome to our Cloud Platform</h3><small>Before you
                        get started, we need some additional information to
                        setup your account!</small>
                    </div>
                </div>
            </div>
        </div>
        <div class="row c_pading-b15 settings_top">
            <div class="col-xs-12 col-md-8 col-md-offset-2">
                <div class="otp-pin-box">
                    <div class="row">
                        <div class="col-md-3">
                            <span class="lh40">Enter OTP Pin:</span>
                        </div>
                        <div class="col-md-5">
                            <div class="input-group">
                                <input class="form-control fix-to-btn" type=
                                "text"> <span class=
                                "input-group-btn lh40"><button class=
                                "btn btn-secondary fix-to-btn validate-btn"
                                style="" type="button"><span class=
                                "input-group-btn">verify</span></button></span>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <p class="verification-text">We just sent a
                            verification text to +61 422 101 421 <a>Resend?</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
    <div class="row">
            <div class="col-xs-12 col-md-8 col-md-offset-2">
                <form role="form">
                <div class="form-group">
                <label for="Address">Address:</label>
                <input type="Address" class="form-control" id="Address">
                </div>
                <div class="form-group">
                <label for="Address2">Address 2:</label>
                <input type="Address2" class="form-control" id="Address2">
                </div>
                <div class="form-group">
                <label for="City">City:</label>
                <input type="City" class="form-control" id="City">
                </div>
                <div class="form-group">
                <label for="State">State:</label>
                <input type="State" class="form-control" id="State">
                </div>
                <div class="form-group">
                <label for="zip">ZIP code:</label>
                <input type="State" class="form-control" id="State">
                </div>
                <div class="form-group">
                <label for="Company">Company (optional):</label>
                <input type="Company" class="form-control" id="Company">
                </div>
                <form class="form-horizontal">
                    <div class="form-group">
                        <label>Select Country</label><br>
                        <div class="flagstrap" data-input-name="country"></div>
                    </div>
                </form>
                </div>
                <div class="col-md-8 col-md-offset-2">
                    <button class="btn btn-primary btn-lg btn-block" type="submit">Proceed <span class="glyphicon glyphicon-chevron-right pull-right" style="padding-right: 10px;"></span></button>
                </div>
                </form>
            </div>
        </div>
    </div>
</section>
    <section class="hiddenorder big-padding col-xs-12" id="services" style=
    " margin-bottom: 50px;">
        <div class="container">
            <h1 class="section-title">Select your account <span class=
            "main-color">model</span></h1><br>
            <div class="text-center">
                <div class="btn-group">
                    <button class="btn btn-default toggle-tabs" type=
                    "button">On-Demand Hourly</button> <button class=
                    "btn btn-default toggle-tabs active" type=
                    "button">Quota Based Monthly</button>
                </div>
            </div>
            <div class="tab-content">
                <div class="row tab-pane" id="ondemand">
                    <div class="col-xs-12 col-md-4 col-custom-1200">
                        <div class="custom-1200-plan" id="explore_plans">
                            <div id="explore_bar">
                                <div class="explore_bar_type_dev" id=
                                "explore_bar_type">
                                    <div class=
                                    "explorestx_browsebar_brand_logo_stxcl" id=
                                    "explorestx_browsebar_brand_logo">
                                        <h2>DET:Compute</h2>
                                    </div>
                                </div>
                                <div style="clear:both;"></div>
                                <div id="explorestx_specs">
                                    <ul>
                                        <li>Scalable
                                            <div class=
                                            "explorestx_specs_blank">
                                                <div class=
                                                "explorestx_specs_fill_workload_cl"
                                                id=
                                                "explorestx_specs_fill_workload">
                                                </div>
                                            </div>
                                        </li>
                                        <li>Performance
                                            <div class=
                                            "explorestx_specs_blank">
                                                <div class=
                                                "explorestx_specs_fill_performance_cl"
                                                id=
                                                "explorestx_specs_fill_performance">
                                                </div>
                                            </div>
                                        </li>
                                        <li>Capacity
                                            <div class=
                                            "explorestx_specs_blank">
                                                <div class=
                                                "explorestx_specs_fill_capacity_cl"
                                                id=
                                                "explorestx_specs_fill_capacity">
                                                </div>
                                            </div>
                                        </li>
                                        <li>Reliability
                                            <div class=
                                            "explorestx_specs_blank">
                                                <div class=
                                                "explorestx_specs_fill_reliability_cl"
                                                id=
                                                "explorestx_specs_fill_reliability">
                                                </div>
                                            </div>
                                        </li>
                                        <li>Cost
                                            <div class=
                                            "explorestx_specs_blank">
                                                <div class=
                                                "explorestx_specs_fill_cost_cl"
                                                id=
                                                "explorestx_specs_fill_cost">
                                                </div>
                                            </div>
                                        </li>
                                    </ul>
                                    <div style="clear:both;"></div>
                                </div>
                                <div id="explorestx_specs_2">
                                    <div class="explorestx_specs_2_list_cl" id=
                                    "explorestx_specs_2_list">
                                        <ul>
                                            <li>Drive Type:<span>SATA
                                            7.2K</span></li>
                                            <li>Network
                                            Port:<span>100Mbit/s</span></li>
                                        </ul>
                                        <div style="clear:both;"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class=
                        "grid clearfix sub-features custom-1200-grid" id=
                        "grid">
                            <a href="#" data-path-hover="m 0,0 0,47.7775 c 24.580441,3.12569 55.897012,-8.199417 90,-8.199417 34.10299,0 65.41956,11.325107 90,8.199417 L 180,0 z">
                            <figure>
                                <img src="img/feature-icon.png">
                                <svg viewBox="0 0 180 320" preserveAspectRatio="none"><path d="m 0,0 0,171.14385 c 24.580441,15.47138 55.897012,24.75772 90,24.75772 34.10299,0 65.41956,-9.28634 90,-24.75772 L 180,0 0,0 z"/></svg>
                                <figcaption>
                                    <h2>Feature list</h2>
                                    <p>Compare all types of computing services
                                    to match your needs!</p>
                                   <button>View</button>
                                </figcaption>
                            </figure>
                            </a>

                              </div>
                         </div>
                    <div class=
                    "price-box col-xs-12 col-md-12 col-md-offset-1 col-lg-8">
                        <form class="form-horizontal form-pricing" role="form">
                            <div class="price-slider">
                                <h4 class="great">Plan</h4>
                                <div class="col-sm-12">
                                    <div id="slider"></div>
                                    <div id="radios">
                                        <input checked id="option1" name=
                                        "options" type="radio" value="test">
                                        <label for="option1">X-01</label>
                                        <input id="option2" name="options"
                                        type="radio"> <label for=
                                        "option2">X-02</label> <input id=
                                        "option3" name="options" type="radio">
                                        <label for="option3">X-03</label>
                                        <input id="option4" name="options"
                                        type="radio"> <label for=
                                        "option4">M-01</label> <input id=
                                        "option5" name="options" type="radio">
                                        <label for="option5">M-02</label>
                                        <input id="option6" name="options"
                                        type="radio"> <label for=
                                        "option6">M-04</label> <input id=
                                        "option7" name="options" type="radio">
                                        <label for="option7">L-01</label>
                                        <input id="option8" name="options"
                                        type="radio"> <label for=
                                        "option8">L-02</label>
                                    </div>
                                </div>
                            </div>
                            <div class="price-slider">
                                <h4 class="great">Summary</h4>
                                <div class="col-sm-12">
                                    <div id="slider2"></div>
                                </div>
                            </div>
                            <div class="price-form">
                                <div class="form-group">
                                    <label class="col-sm-6 control-label" for=
                                    "amount">Amount (USD):</label> <span class=
                                    "help-text">Monthly Cost</span>
                                    <div class="col-sm-6">
                                        <input class="form-control" id="amount"
                                        type="hidden">
                                        <p class="price lead" id=
                                        "amount-label1">$1</p><span class=
                                        "price">.00</span>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <!--
              <label for="duration" class="col-sm-6 control-label">Resources: </label>
              <span class="help-text">Display RESOURCES</span>
-->
                                    <div class="box-resources">
                                        <div class="left-resources">
                                            <strong>RAM</strong> 256MB
                                            <span></span>
                                        </div>
                                        <div class="middle-resources">
                                            <strong>STORAGE (HDD)</strong> 5GB
                                            <span></span>
                                        </div>
                                        <div class="right-resources">
                                            <strong>CPU Cores</strong> 1
                                        </div>
                                        <div class="left-resources">
                                            <strong>BANDWIDTH</strong> 500GB
                                            <span></span>
                                        </div>
                                        <div class="middle-resources">
                                            <strong>VM Limit</strong> 1
                                            <span></span>
                                        </div>
                                        <div class="right-resources">
                                            <strong>IPv4 Limit</strong> 1
                                        </div>
                                    </div>
                                </div>
                                <hr class="style">
                            </div>
                            <div class="form-group">
                                <div class="col-sm-12">
                                    <button class=
                                    "btn btn-primary btn-lg btn-block" type=
                                    "submit">Proceed<span class=
                                    "glyphicon glyphicon-chevron-right pull-right"
                                    style=
                                    "padding-right: 10px;"></span></button>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-12">
                                    <img class="img-responsive payment" src=
                                    "img/payment.png">
                                    <div class="alert">
                                        <button class="close" data-dismiss=
                                        "alert" type="button">×</button>
                                        Payments under <strong>$5.00</strong>
                                        will include the chosen payment
                                        processor fees.<br>
                                        <p>These vary from 30 to 40 cents on
                                        average</p>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="row tab-pane active" id="quota">
                    <div class="col-xs-12 col-md-4 col-custom-1200">
                        <div class="custom-1200-plan" id="explore_plans">
                            <div id="explore_bar">
                                <div class="explore_bar_type_dev" id=
                                "explore_bar_type">
                                    <div class=
                                    "explorestx_browsebar_brand_logo_stxcl" id=
                                    "explorestx_browsebar_brand_logo">
                                        <h2>Plans</h2>
                                    </div>
                                </div>
                                <div style="clear:both;"></div>
                                <div id="explorestx_specs">
                                    <ul>
                                        <li>Scalability
                                            <div class=
                                            "explorestx_specs_blank">
                                                <div class=
                                                "explorestx_specs_fill_capacity_cl"
                                                id=
                                                "explorestx_specs_fill_capacity"
                                                style="width:50%;"></div>
                                            </div>
                                        </li>
                                        <li>Reliability
                                            <div class=
                                            "explorestx_specs_blank">
                                                <div class=
                                                "explorestx_specs_fill_reliability_cl"
                                                id=
                                                "explorestx_specs_fill_reliability"
                                                style="width:90%;"></div>
                                            </div>
                                        </li>
                                        <li>Cost
                                            <div class=
                                            "explorestx_specs_blank">
                                                <div class=
                                                "explorestx_specs_fill_cost_cl"
                                                id="explorestx_specs_fill_cost"
                                                style="width:50%;"></div>
                                            </div>
                                        </li>
                                    </ul>
                                    <div style="clear:both;"></div>
                                </div>
                                <div id="explorestx_specs_2">
                                    <div class="explorestx_specs_2_list_cl" id=
                                    "explorestx_specs_2_list">
                                        <ul>
                                            <li>Drive Type:<span>Flash Memory:
                                            SSD</span></li>
                                            <li>&<span>Mechanical Drives:
                                            HDD</span></li>
                                            <li>Network
                                            Port:<span>1000Mbit/s</span></li>
                                        </ul>
                                        <div style="clear:both;"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class=
                        "grid align-fig clearfix sub-features custom-1200-grid" id=
                        "grid">
                            <a data-path-hover=
                            "m 0,0 0,47.7775 c 24.580441,3.12569 55.897012,-8.199417 90,-8.199417 34.10299,0 65.41956,11.325107 90,8.199417 L 180,0 z"
                            href="#">
                            <figure>
                                <img src="img/feature-icon.png">
                                <svg preserveaspectratio="none" viewbox=
                                "0 0 180 320">
                                <path d=
                                "m 0,0 0,171.14385 c 24.580441,15.47138 55.897012,24.75772 90,24.75772 34.10299,0 65.41956,-9.28634 90,-24.75772 L 180,0 0,0 z"></path>
                                </svg>
                                <figcaption>
                                    <h2>Feature list</h2>
                                    <p>Compare all types of computing services
                                    to match your needs!</p>
                                    <button>View features</button>
                                </figcaption>
                            </figure></a>
                        </div>
				</a>
                    </div>
                    <div class=
                    "price-box col-xs-12 col-md-12 col-md-offset-1 col-lg-8">
                        <form class="form-horizontal form-pricing" role="form">
                            <div class="price-slider">
                                <h4 class="great">Plan</h4>
                                <div class="col-sm-12">
                                    <div id="slider"></div>
                                    <div id="radios01">
                                        <input checked id="option-n-1" name=
                                        "options" type="radio" value="test">
                                        <label for="option-n-1">X-01</label>
                                        <input id="option-n-2" name="options"
                                        type="radio"> <label for=
                                        "option-n-2">X-02</label> <input id=
                                        "option-n-3" name="options" type=
                                        "radio"> <label for=
                                        "option-n-3">X-03</label> <input id=
                                        "option-n-4" name="options" type=
                                        "radio"> <label for=
                                        "option-n-4">M-01</label> <input id=
                                        "option-n-5" name="options" type=
                                        "radio"> <label for=
                                        "option-n-5">M-02</label> <input id=
                                        "option-n-6" name="options" type=
                                        "radio"> <label for=
                                        "option-n-6">M-04</label> <input id=
                                        "option-n-7" name="options" type=
                                        "radio"> <label for=
                                        "option-n-7">L-01</label> <input id=
                                        "option-n-8" name="options" type=
                                        "radio"> <label for=
                                        "option-n-8">L-02</label>
                                    </div>
                                </div>
                            </div>
                            <div class="price-slider">
                                <h4 class="great">Summary</h4>
                                <div class="col-sm-12">
                                    <div id="slider2"></div>
                                </div>
                            </div>
                            <div class="price-form">
                                <div class="form-group">
                                    <label class="col-sm-6 control-label" for=
                                    "amount">Amount (USD):</label> <span class=
                                    "help-text">Monthly Cost</span>
                                    <div class="col-sm-6">
                                        <input class="form-control" id="amount"
                                        type="hidden">
                                        <p class="price lead" id=
                                        "amount-label2">$2</p><span class=
                                        "price">.00</span>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <!--
              <label for="duration" class="col-sm-6 control-label">Resources: </label>
              <span class="help-text">Display RESOURCES</span>
-->
                                    <div class="box-resources">
                                        <div class="left-resources">
                                            <strong>RAM</strong> 256MB
                                            <span></span>
                                        </div>
                                        <div class="middle-resources">
                                            <strong>STORAGE (SSD)</strong> 5GB
                                            <span></span>
                                        </div>
                                        <div class="right-resources">
                                            <strong>CPU Cores</strong> 1
                                        </div>
                                        <div class="left-resources">
                                            <strong>BANDWIDTH</strong> 500GB
                                            <span></span>
                                        </div>
                                        <div class="middle-resources">
                                            <strong>VM Limit</strong> 1
                                            <span></span>
                                        </div>
                                        <div class="right-resources">
                                            <strong>IPv4 Limit</strong> 1
                                        </div>
                                    </div>
                                </div>
                                <hr class="style">
                            </div>
                            <div class="form-group">
                                <div class="col-sm-12">
                                    <button class=
                                    "btn btn-primary btn-lg btn-block" type=
                                    "submit">Proceed <span class=
                                    "glyphicon glyphicon-chevron-right pull-right"
                                    style=
                                    "padding-right: 10px;"></span></button>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-12"><img class=
                                "img-responsive payment" src=
                                "img/payment.png"></div>
                            </div>
                        </form>
                    </div>
                </div>
   <?php include('includes/footer.php') ?>
</body>
</html>