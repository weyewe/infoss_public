Ext.define('AM.controller.CashBankMutations', {
  extend: 'Ext.app.Controller',

  stores: ['CashBankMutations'],
  models: ['CashBankMutation'],

  views: [
    'operation.cashbankmutation.List',
    'operation.cashbankmutation.Form' 
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'cashbankmutationlist'
		},
		{
			ref : 'searchField',
			selector: 'cashbankmutationlist textfield[name=searchField]'
		}
	],

  init: function() {
    this.control({
      'cashbankmutationlist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'cashbankmutationform button[action=save]': {
        click: this.updateObject
      },
      'cashbankmutationlist button[action=addObject]': {
        click: this.addObject
      },
      'cashbankmutationlist button[action=editObject]': {
        click: this.editObject
      },
      'cashbankmutationlist button[action=deleteObject]': {
        click: this.deleteObject
      },
	  	'cashbankmutationlist textfield[name=searchField]': {
        change: this.liveSearch
      },
			'cashbankmutationProcess cashbankmutationlist button[action=confirmObject]': {
        click: this.confirmObject
      },

			'cashbankmutationtProcess cashbankmutationlist button[action=unconfirmObject]': {
        click: this.unconfirmObject
      },
			'confirmcashbankmutationform button[action=confirm]' : {
				click : this.executeConfirm
			},
			
			'unconfirmcashbankmutationform button[action=confirm]' : {
				click : this.executeUnconfirm
			},
		
    });
  },

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getCashBankMutationsStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getCashBankMutationsStore().load();
	},
	
	confirmObject: function(){
		console.log("the  confirmObject ");
		var view = Ext.widget('confirmcashbankmutationform');
		console.log( view ) ;
		var record = this.getList().getSelectedObject(); 
		console.log( record ) ;
		view.down('form').loadRecord(record);
 
	},
  
  unconfirmObject: function(){
 
		
		var view = Ext.widget('unconfirmcashbankmutationform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
    view.show();
	},
  
	executeConfirm : function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getCashBankMutationsStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
			var rec_id = record.get("id");
			record.set( 'confirmed_at' , values['confirmed_at'] );
			 
			form.query('checkbox').forEach(function(checkbox){
				record.set( checkbox['name']  ,checkbox['checked'] ) ;
			});
			
			form.setLoading(true);
			record.save({
				params : {
					confirm: true 
				},
				success : function(record){
					form.setLoading(false);
					// list.disableRecordButtons(record);
					list.fireEvent('confirmed', record);
					
					
					store.load();
					win.close();
					
				},
				failure : function(record,op ){
					// console.log("Fail update");
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					record.reject(); 
					// this.reject(); 
				}
			});
		}
	},
	
	
	
	
	executeUnconfirm : function(button){
		// console.log("unconfirm deceased");

		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getCashBankMutationsStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
			var rec_id = record.get("id");
			 
			// form.query('checkbox').forEach(function(checkbox){
			// 	record.set( checkbox['name']  ,checkbox['checked'] ) ;
			// });
			// 
			form.setLoading(true);
			record.save({
				params : {
					unconfirm: true 
				},
				success : function(record){
					form.setLoading(false);
					// list.disableRecordButtons(record);
					list.fireEvent('confirmed', record);
					
					
					store.load();
					win.close();
					
				},
				failure : function(record,op ){
					// console.log("Fail update");
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					record.reject(); 
					// this.reject(); 
				}
			});
		}
	}, 

	loadObjectList : function(me){
		me.getStore().getProxy().extraParams = {}
		me.getStore().load();
	},

  addObject: function() {
    var view = Ext.widget('cashbankmutationform');
    view.show();
  },

  editObject: function() {
		var me = this; 
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('cashbankmutationform');

		

    view.down('form').loadRecord(record);
    view.setComboBoxData( record ) ;
  },

  updateObject: function(button) {
		var me = this; 
    var win = button.up('window');
    var form = win.down('form');

    var store = this.getCashBankMutationsStore();
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
			var newObject = new AM.model.CashBankMutation( values ) ;
			
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
      var store = this.getCashBankMutationsStore();
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
