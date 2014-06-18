Ext.define('SimpleTasks.controller.Toolbar', {
     extend: 'Ext.app.Controller'
    ,views: [ 'Toolbar']
	//à l'initialisation du controlleur
    ,init: function() {
    	
    	// Add all components to observe
        this.control({
			
        		'header_menu' :{
				beforerender: this.beforeRender
				},
        	
        	
				'header_menu button[action=newApp]': {
				click: this.showForm}
			});
    },

	beforeRender: function(panel, obj){
		//put the logic to check access right there
                // I get the menu panel and yet I just add un button
		tbar = panel.down('toolbar');
		tbar.add({xtype:'button',text: 'test'});
	}
});
