Ext.define('SimpleTasks.model.Task', {
    extend: 'Ext.data.Model',
    requires:[
        'Ext.data.proxy.LocalStorage',
        'Ext.data.proxy.Ajax'
    ],
    fields: [

    ],

    proxy: SimpleTasksSettings.useLocalStorage ? {
        type: 'localstorage',
        id: 'SimpleTasks-Task'
    } : {
        type: 'ajax',
        api: {

        },
        reader: {
            type: 'json',
            root: 'tasks',
            messageProperty: 'message'
        }
    }

});
