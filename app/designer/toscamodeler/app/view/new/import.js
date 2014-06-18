Ext.create('Ext.form.Panel', {
    title: 'Upload a file',
    width: 400,
    bodyPadding: 10,
    frame: true,
    renderTo: Ext.getBody(),    
    items: [{
        xtype: 'filefield',
        name: 'file',
        fieldLabel: 'file',
        labelWidth: 50,
        msgTarget: 'side',
        allowBlank: false,
        anchor: '100%',
        buttonText: 'Select file...'
    }],

    buttons: [{
        text: 'Upload',
        handler: function() {
            var form = this.up('form').getForm();
            if(form.isValid()){
                form.submit({
                    url: 'file-upload.php',
                    waitMsg: 'Uploading your file...',
                    success: function(fp, o) {
                        Ext.Msg.alert('Success', 'Your file "' + o.result.file + '" has been uploaded.');
                    }
                });
            }
        }
    }]
});
