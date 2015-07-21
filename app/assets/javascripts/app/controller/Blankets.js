Ext.define('AM.controller.Blankets', {
  extend: 'Ext.app.Controller',

  stores: ['Blankets'],
  models: ['Blanket'],

  views: [
    'master.blanket.List',
    'master.blanket.Form' 
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'blanketlist'
		},
		{
			ref : 'searchField',
			selector: 'blanketlist textfield[name=searchField]'
		}
	],

  init: function() {
    this.control({
      'blanketlist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'blanketform button[action=save]': {
        click: this.updateObject
      },
      'blanketlist button[action=addObject]': {
        click: this.addObject
      },
      'blanketlist button[action=editObject]': {
        click: this.editObject
      },
      'blanketlist button[action=deleteObject]': {
        click: this.deleteObject
      },
	  	'blanketlist textfield[name=searchField]': {
        change: this.liveSearch
      },
    });
  },

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getBlanketsStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getBlanketsStore().load();
	},
	
	loadObjectList : function(me){
		me.getStore().getProxy().extraParams = {}
		me.getStore().load();
	},

  addObject: function() {
    var view = Ext.widget('blanketform');
    view.show();
  },

  editObject: function() {
		var me = this; 
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('blanketform');

		

    view.down('form').loadRecord(record);
    view.setComboBoxData( record ) ;
  },

  updateObject: function(button) {
		var me = this; 
    var win = button.up('window');
    var form = win.down('form');

    var store = this.getBlanketsStore();
    var record = form.getRecord();
    var values = form.getValues();

 
		
		
		if( record ){
			record.set( values );
			
			form.query('checkbox').forEach(function(checkbox){
				record.set( checkbox['name']  ,checkbox['checked'] ) ;
			});
			 
			form.setLoading(true);
			record.save({
				success : function(new_record){
					form.setLoading(false);
					//  since the grid is backed by store, if store changes, it will be updated
					var list = me.getList();
					AM.view.Constants.updateRecord( record, new_record );  
					AM.view.Constants.highlightSelectedRow( list );         
					
					// store.getProxy().extraParams = {
					//     livesearch: ''
					// };
	 
					// store.load();
					win.close();
				},
				failure : function(record,op ){
					button.enable();
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
				
			 
		}else{
			//  no record at all  => gonna create the new one 
			var me  = this; 
			var newObject = new AM.model.Blanket( values ) ;
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
			newObject.save({
				success: function(record){
	
					store.load();
					form.setLoading(false);
					win.close();
					
				},
				failure: function( record, op){
					button.enable();
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
		} 
  },

  deleteObject: function() {
    var record = this.getList().getSelectedObject();

    if (record) {
      var store = this.getBlanketsStore();
      store.remove(record);
      store.sync();
// to do refresh programmatically
			this.getList().query('pagingtoolbar')[0].doRefresh();
    }

  },

  selectionChange: function(selectionModel, selections) {
    var grid = this.getList();

    if (selections.length > 0) {
      grid.enableRecordButtons();
    } else {
      grid.disableRecordButtons();
    }
  }

});
