<!DOCTYPE html>
<html>
<head>
    <title></title>
</head>
<body>
    <div class="container">
        <ul class="gn-menu-main" id="gn-menu">
            <li class="gn-trigger">
                <a class="gn-icon gn-icon-menu"><span>Menu</span></a>
                <nav class="gn-menu-wrapper">
                    <div class="gn-scroller">
                        <ul class="gn-menu">
                            <li>
                                <a href="market-place.php"><i class=
                                "icon-dashboard"></i> <span>Dashboard</span>
                                <span class="selected hidden-xs"></span></a>
                            </li>
                            <li>
                                <a href="app.php"><i class="icon-tasks"></i>
                                <span>Apps</span></a>
                                <ul class="gn-submenu">
                                   <!--Expected functionality with this submenu 
                                    is to display the last (two) recently used applications. (by used
                                    I mean navigated to in Vertice, so whenever a user loads a VM/APP 
                                    in the UI, we can add it to the 'recent' list)
                                    
                                    This is to enhance UX and shorten steps. We can also show the 
                                    status of the machine via a class 'offline/online'. 
                                    -->
                                    <li>
                                        <a class="offline"><i aria-hidden=
                                        "true" class="fa fa-circle"></i>
                                        app1.app.det.io</a>
                                    </li>
                                    <li>
                                        <a class="online"><i aria-hidden="true"
                                        class="fa fa-circle"></i>
                                        app2.app.det.io</a>
                                    </li>
                                    <!--Expected functionality with the ... 
                                    is to load the next most recently used apps (say the next 5) 
                                    through an AJAX call and update the UI.-->
                                    <li class="smaller">
                                        <a class="more">
                                        ...</a>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <a href="vm-overview.php"><i class=
                                "icon-bar-chart"></i> <span>Virtual
                                Machines</span></a>
                                <ul class="gn-submenu">
                                    <li>
                                        <a class="online"><i aria-hidden="true"
                                        class="fa fa-circle"></i>
                                        vm1.compute.det.io</a>
                                    </li>
                                    <li>
                                        <a class="offline"><i aria-hidden=
                                        "true" class="fa fa-circle"></i>
                                        vm2.compute.det.io</a>
                                    </li>
                                    <!--if the APP ... is already open when a user clicks the following (vice-versa) then we 
                                    close the other one. -->
                                    <li class="smaller">
                                        <a class="more">
                                        ...</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="start active">
                                <a href="cloud-settings.php"><i class="icon-key"></i>
                                <span>SSH Keys</span></a>
                            </li>
                            <li>
                                <a href="billing.php"><i class=
                                "icon-money"></i> <span>Billing</span>
                                <span class="selected hidden-xs"></span></a>
                            </li>
                        </ul>
                    </div><!-- /gn-scroller -->
                </nav>
            </li>
            <li>
                <a class="codrops-icon codrops-icon-prev add-new" href=
                "#new-modal"><i class="fa fa-plus"></i></a>
            </li>
        </ul>
    </div><!-- /container -->
</body>
</html>