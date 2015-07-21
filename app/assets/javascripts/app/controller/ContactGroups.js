Ext.define('AM.controller.ContactGroups', {
  extend: 'Ext.app.Controller',

  stores: ['ContactGroups'],
  models: ['ContactGroup'],

  views: [
    'master.contactgroup.List',
    'master.contactgroup.Form'
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'contactgrouplist'
		} 
	],

  init: function() {
    this.control({
      'contactgrouplist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'contactgroupform button[action=save]': {
        click: this.updateObject
      },
      'contactgrouplist button[action=addObject]': {
        click: this.addObject
      },
      'contactgrouplist button[action=editObject]': {
        click: this.editObject
      },
      'contactgrouplist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			'contactgrouplist textfield[name=searchField]': {
				change: this.liveSearch
			}
		
    });
  },

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getContactGroupsStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getContactGroupsStore().load();
	},
 

	loadObjectList : function(me){
		// console.log("************* IN THE USERS CONTROLLER: afterRENDER");
		me.getStore().load();
	},

  addObject: function() {
    var view = Ext.widget('contactgroupform');
    view.show();
  },

  editObject: function() {
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('contactgroupform');

    view.down('form').loadRecord(record);
		view.setComboBoxData(record); 
  },

  updateObject: function(button) {
  	button.disable();
  	var me  = this; 
    var win = button.up('window');
    var form = win.down('form');

    var store = this.getContactGroupsStore();
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
			var newObject = new AM.model.ContactGroup( values ) ;
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
      form.query('checkbox').forEach(function(checkbox){
        newObject.set( checkbox['name']  ,checkbox['checked'] ) ;
      });
			newObject.save({
				success: function(record){
					//  since the grid is backed by store, if store changes, it will be updated
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
      var store = this.getContactGroupsStore();
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
