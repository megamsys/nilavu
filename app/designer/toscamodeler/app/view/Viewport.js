Ext.define('SimpleTasks.view.Viewport', {
    extend: 'Ext.container.Viewport',
    requires: [
	'SimpleTasks.ux.DragDrop',
	'Ext.ux.dd.PanelFieldDragZone',
        'Ext.layout.container.Border'

    ],

    layout: 'border',

    items: [
        {
            xtype: 'tasksToolbar',
            region: 'north'
        },             
        {
        xtype : 'panel',
	region : 'east',
        title : 'Cloud Meter',
        animCollapse : true,
	id : 'cloudSetting',
        collapsible : true,
        split : true,
        width : 225, // give east and west regions a width
        minSize : 175,
        maxSize : 400,
        margins : '0 5 0 0',
	html : '<p>Cloud settings details</p>'
    },
                
        
        {
            xtype: 'listTree',
            region: 'west',
            width: 300,
            collapsible: true,
            split: true
        },
        {
            centered :true,
	scrollable :'vertical',
	width :765,
	height :650,
	id: 'mainPanel',
	styleHtmlContent :true,
            xtype: 'panel',
            title: 'Panel',
tbar    : [
      {
        text    : 'App',
        handler : function(e) {
var i = 0;
var clickSource;
var pan =  Ext.getCmp('mainPanel').items.items[0];

//pan = document.getElementById("mainPanel");
i++;
pan.createApp(clickSource, i, 150, 150);
i++;
        }
      },
{
        text    : 'DB',
        handler : function(e) {
document.getElementById("newDecision").click();
var i = 0;
var height = 0;
var width = 0;
var clickSource;
var pan =  Ext.getCmp('mainPanel').items.items[0];

height += $('#' + i).height();
width += $('#' + i).width();
// console.log(height);
i++;
//pan = document.getElementById("mainPanel");
pan.createDb(clickSource, i, 350, 350);
i++;
        }
      }
    ],
	items : [ {

					listeners : {
						afterrender : function(panel, eopts) {
							console.log('panel rendered');
							panel.createflowchart(panel);
						}
					},
					createflowchart : function(panel) {
						console.log('Initialise function : createjsplumb');
						jsPlumb.setContainer(document.getElementById("mainPanel"));
						jpImportDefaults();
						var i = 0;
						var height = 0;
						var width = 0;
						var clickSource;
						var dec1 = panel.createDb(clickSource, i, 50, 50,true);
						i++;
						var act1 = panel.createApp(clickSource, i, 300, 50,true);
						i++;

						$('#mainPanel').bind('contextmenu', function(e) {
							clickSource = e;
							e.preventDefault();
							contextMenu.showAt(e.pageX, e.pageY);
						});

						var contextMenu = new Ext.menu.Menu({
							items : [
									{
										text : 'Decision',
										id : 'newDecision',
										handler : function() {
											console.log('Clicked : Decision')

											height += $('#' + i).height();
											width += $('#' + i).width();
											// console.log(height);
											i++;

											panel.createDb(clickSource,
													i, clickSource.pageX,
													clickSource.pageY);
										}
									},
									{
										text : 'Action',
										handler : function() {
											console.log('Clicked : Action')
											// source = 'action';
											i++;
											panel.createApp(clickSource, i,
													clickSource.pageX,
													clickSource.pageY);
										}
									} ]
						});

						$('#mainPanel').dblclick(function(e) {
							 panel.createDb(e,i);
						});
					},
					createDb : function(e, i, x, y, isDefault) {

						resourceName = 'Db'+i;
						if (resourceName) {
							var connect = $('<div>').addClass('connect');
							var title = $('<div>').addClass('decisionTitle').text(resourceName);
							
							var titlewidth = resourceName.length;
							var lword = longestWord(resourceName);

							var css = {
								'top' : y,
								'left' : x,
								'height' : 70,
								'width' : 150,
								'background-color' : '#00FFFF'
							};
							var decisionState = getJpRectangle(i, resourceName,
									resourceName, null, css);
							jsPlumb.makeTarget(decisionState, {
								anchor : 'Continuous'
							});
							jsPlumb.makeSource(connect, {
								parent : decisionState,
								anchor : 'Continuous',
								connector : [ "Flowchart", {
									cornerRadius : 5
								} ],
								connectorStyle : {
									strokeStyle : "#5c96bc",
									lineWidth : 4,
									outlineColor : "transparent",
									outlineWidth : 4
								}
							});

							//decisionState.append(title);
							decisionState.append(connect);

							$('#mainPanel').append(decisionState);

							jsPlumb.draggable(decisionState, {
								containment : 'parent'
							});
							decisionState.click(function(e) {
								Ext.getCmp('cloudSetting').update('hello '+resourceName);
								//alert(this.id);
								
							});

							i++;

						}
					},
					createApp : function(e, i, x, y, isDefault) {
						resourceName = 'App'+i;
						if (resourceName) {
							var css = {
								'top' : y,
								'left' : x,
								'height' : 70,
								'width' : 150,
								'background-color' : '#FF00FF'
							};
							var actionState = getJpRectangle(i, resourceName,
									resourceName, null, css);

							var connect = $('<div>').addClass('connect');

							jsPlumb.makeTarget(actionState, {
								anchor : 'Continuous'
							});

							jsPlumb.makeSource(connect, {
								parent : actionState,
								anchor : 'Continuous',
								connector : [ "Flowchart", {
									cornerRadius : 5
								} ],
								connectorStyle : {
									strokeStyle : "#5c9000",
									lineWidth : 2,
									outlineColor : "transparent",
									outlineWidth : 4
								}
							});

							actionState.append(connect);

							$('#mainPanel').append(actionState);

							jsPlumb.draggable(actionState, {
								containment : 'parent'
							});

							actionState.dblclick(function(e) {
								jsPlumb.detachAllConnections($(this));
								$(this).remove();
								e.stopPropagation();
							});
							actionState.click(function(e) {
								Ext.getCmp('cloudSetting').update('hello '+resourceName);
								//alert(this.id);
								
							});
							i++;

						}
					}
				} ],

				showProperty : function(component) {
					console.log('show property');
					console.log(component);
				}
//listeners: { render: initializeDropTarget },
        }
    ]
});







