/**
 * @class SimpleTasks.view.Toolbar
 * @extends Ext.toolbar.Toolbar
 */
Ext.define('SimpleTasks.view.Toolbar', {
    extend: 'Ext.toolbar.Toolbar',
    xtype: 'tasksToolbar',
    alias: 'widget.header_menu',
    requires: [
        'SimpleTasks.ux.DragDrop',
	'Ext.dd.DropTarget',
        'Ext.grid.plugin.DragDrop'
              ],
    items: [
        {
            text: 'New',
            iconCls: 'tasks-new',
            menu: {
                items: [
                    {
                        text: 'Import',
                        iconCls: 'tasks-import',
                        handler: function() {
                            alert("New Text - Hello World");  
                            //import.js;
                            }
                      
                    }
                ]
            }
        },

        {
            iconCls: 'tasks-mark-complete',
            text: 'Save',
            id: 'save-app',
            disabled: true,
            tooltip: 'Save app'
        },
        {
            iconCls: 'tasks-mark-complete',
            text: 'Run',
            id: 'run-app',
            disabled: true,
            tooltip: 'Run App'
        },
        {
            iconCls: 'tasks-mark-active',
            text: 'test',
            id: 'mark-active-btn',
            disabled: true,
            tooltip: 'Mark Active'
        },

        {
            iconCls: 'tasks-show-all',
            text: 'App',
            id: 'toolApp',
            tooltip: 'Select App',
	    draggable: true,
            enableDragDrop: true,
            toggleGroup: 'status',
		 xtype: 'button',
	    click: function (b,e) {
     alert('x');
    }
        },
        {
            iconCls: 'tasks-show-active',
            text: 'LB',
            id: 'LB',
            tooltip: 'Load Balancer',
            toggleGroup: 'status'
        },
        {
            iconCls: 'tasks-show-complete',
            text: 'DB',
            id: 'DB',
            tooltip: 'Select Database',
            toggleGroup: 'status'
        },
        '->',
        {
            iconCls: 'tasks-show-all',
            id: 'show-all-btn',
            tooltip: 'All Tasks',
            toggleGroup: 'status'
        },
        {
            iconCls: 'tasks-show-active',
            id: 'show-active-btn',
            tooltip: 'Active Tasks',
            toggleGroup: 'status'
        },
        {
            iconCls: 'tasks-show-complete',
            id: 'show-complete-btn',
            tooltip: 'Completed Tasks',
            toggleGroup: 'status'
        }

    ]
});


