/**
 * @class SimpleTasks.view.tasks.List
 * @extends Ext.grid.Panel
 * The tasks list view.  A grid that displays a list of tasks.
 */

Ext.define('SimpleTasks.view.tasks.Grid', {
    extend: 'Ext.panel.Panel',
	xtype: 'tomPanel',
    requires: [
        'SimpleTasks.ux.DragDrop',
        'SimpleTasks.ux.StatusColumn',
        'SimpleTasks.ux.ReminderColumn',
        'Ext.ux.TreePicker',
        'Ext.ux.CellDragDrop'
    ],
	centered :true,
	scrollable :'vertical',
	width :300,
	height :200,
	styleHtmlContent :true,
	html :'<h2>Hi there buddy</h2>',
    store: 'Tasks',

tools: [{
       type: 'help',
       handler: function(){
           // show help here
       }
   }, {
       itemId: 'refresh',
       type: 'refresh',
       hidden: true,
       handler: function(){
           // do refresh
       }
   }, {
       type: 'search',
       handler: function(event, target, owner, tool){
           // do search
           owner.child('#refresh').show();
       }
   }]

});
