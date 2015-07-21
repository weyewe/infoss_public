Ext.define('AM.controller.SalesOrders', {
  extend: 'Ext.app.Controller',

  stores: ['SalesOrders'],
  models: ['SalesOrder'],

  views: [
    'operation.salesorder.List',
    'operation.salesorder.Form',
    'operation.salesorder.FilterForm',
		'operation.salesorderdetail.List',
		'Viewport'
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'salesorderlist'
		},
		{
			ref : 'salesOrderDetailList',
			selector : 'salesorderdetaillist'
		},
		
		{
			ref : 'form',
			selector : 'salesorderform'
		},
		{
			ref: 'viewport',
			selector: 'vp'
		},
	],

  init: function() {
    this.control({
      'salesorderProcess salesorderlist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'salesorderProcess salesorderform button[action=save]': {
        click: this.updateObject
      },
			'salesorderProcess salesorderform customcolorpicker' : {
				'colorSelected' : this.onColorPickerSelect
			},

      'salesorderProcess salesorderlist button[action=addObject]': {
        click: this.addObject
      },
      'salesorderProcess salesorderlist button[action=editObject]': {
        click: this.editObject
      },
      'salesorderProcess salesorderlist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			
			'salesorderProcess salesorderlist button[action=confirmObject]': {
        click: this.confirmObject
      },
      
      'salesorderProcess salesorderlist button[action=downloadObject]': {
        click: this.downloadObject
			}	,

			'salesorderProcess salesorderlist button[action=unconfirmObject]': {
        click: this.unconfirmObject
      },
			'confirmsalesorderform button[action=confirm]' : {
				click : this.executeConfirm
			},
			
			'unconfirmsalesorderform button[action=confirm]' : {
				click : this.executeUnconfirm
			},

			'salesorderProcess salesorderlist textfield[name=searchField]': {
				change: this.liveSearch
			},
			'salesorderform button[action=save]': {
        click: this.updateObject
      },
      'salesorderProcess salesorderlist button[action=filterObject]': {
        click: this.filterObject
      },
			'filtersalesorderform button[action=save]' : {
				click : this.executeFilterObject  
			},
			
			'filtersalesorderform button[action=reset]' : {
				click : this.executeResetFilterObject  
			},
		
    });
  },
  
  filterObject: function() {
  	// console.log("inside the filter object");
  	var me = this; 
		var view = Ext.widget('filtersalesorderform');
		
		view.setPreviousValue( me.getSalesOrdersStore().getProxy().extraParams ); 
		
	  view.show(); 
  },
  
  executeFilterObject: function(button) {
  	var win = button.up('window');
    var form = win.down('form');
  	var me  = this; 
		var store = this.getList().getStore();
		me.getSalesOrdersStore().currentPage  = 1; 
		
		
    var values = form.getValues(); 
 
		var extraParams = {};
		extraParams = {
			livesearch: me.getSalesOrdersStore().getProxy().extraParams["livesearch"]
		};
		 
		for (var k in values) {
		    if (values.hasOwnProperty(k)) {
		    	 
		    	if(   	values[k] === null  ||  	values[k] == "" 	){
		    			 continue; 
		    	 }
		    	
		    	extraParams[k] = values[k]; 
		    }
		}
		 
		 
		me.getSalesOrdersStore().getProxy().extraParams = extraParams;
		 
		me.getSalesOrdersStore().load();
		win.close();
  },
  
  executeResetFilterObject: function(button) {
  	var win = button.up('window');
    var form = win.down('form');
  	var me  = this; 
		var store = this.getList().getStore();
		me.getSalesOrdersStore().currentPage  = 1; 
		
		
    var values = form.getValues(); 
 
		var extraParams = {};
		extraParams = {
			livesearch: me.getSalesOrdersStore().getProxy().extraParams["livesearch"]
		};
		  
		me.getSalesOrdersStore().getProxy().extraParams = extraParams;
		 
		me.getSalesOrdersStore().load();
		win.close();
  },

	onColorPickerSelect: function(colorId, theColorPicker){
		var win = theColorPicker.up('window');
    var form = win.down('form');
		var colorField = form.getForm().findField('color'); 
		
		
		// console.log("the colorId in onColorPickerSelect:");
		// console.log( colorId);
		colorField.setValue( colorId );
		
		// console.log("The colorField.getValue()");
		// console.log( colorField.getValue() );
	
	},

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;
		
		me.getSalesOrdersStore().currentPage  = 1; 

		me.getSalesOrdersStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getSalesOrdersStore().load();
	},
 

	loadObjectList : function(me){
		// console.log( "I am inside the load object list" ); 
		me.getStore().load();
	},

  addObject: function() {
	var view = Ext.widget('salesorderform');
  view.show();

	 
  },

  editObject: function() {
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('salesorderform');

    view.down('form').loadRecord(record);
    view.setComboBoxData( record ) ;
  },

	confirmObject: function(){
		// console.log("the startObject callback function");
		var record = this.getList().getSelectedObject();
		if(record){
			var view = Ext.widget('confirmsalesorderform');

			view.setParentData( record );
	    view.show();
		}
		
		
		// this.reloadRecordView( record, view ) ; 
	},

  updateObject: function(button) {
  	button.disable();
  	var me  = this; 
    var win = button.up('window');
    var form = win.down('form');
		var me = this; 

    var store = this.getSalesOrdersStore();
    var record = form.getRecord();
    var values = form.getValues();
 
		if( record ){
			record.set( values );
			  
			
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
					// me.updateChildGrid(record );
				},
				failure : function(record,op ){
					button.enable();
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					me.reject();
				}
			});
				
			 
		}else{
			//  no record at all  => gonna create the new one 
			console.log("This is the new record")
			var me  = this; 
			var newObject = new AM.model.SalesOrder( values ) ; 
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
			newObject.save({
				success: function(record){
					//  since the grid is backed by store, if store changes, it will be updated
					// console.log("create new record");
					// console.log( record )
					
					store.load();
					form.setLoading(false);
					win.close();
					// console.log("The record details");
					// console.log(record);
					me.updateChildGrid(record );
					
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

	unconfirmObject: function(){
		// console.log("the startObject callback function");
		var view = Ext.widget('unconfirmsalesorderform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
    view.show();
		// this.reloadRecordView( record, view ) ; 
	},
	
	executeConfirm: function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getSalesOrdersStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
			var rec_id = record.get("id");
			record.set( 'confirmed_at' , values['confirmed_at'] );
			 
			// form.query('checkbox').forEach(function(checkbox){
			// 	record.set( checkbox['name']  ,checkbox['checked'] ) ;
			// });
			// 
			form.setLoading(true);
			record.save({
				params : {
					confirm: true 
				},
				success : function(new_record){
					form.setLoading(false);
					
					// // me.reloadRecord( record ) ; 
					
					list.enableRecordButtons();  
					AM.view.Constants.updateRecord( record, new_record );  
					AM.view.Constants.highlightSelectedRow( list );       
					
 
					
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
	
	
	
	executeUnconfirm: function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getSalesOrdersStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
			var rec_id = record.get("id");
			record.set( 'confirmed_at' , values['confirmed_at'] );
			 
			// form.query('checkbox').forEach(function(checkbox){
			// 	record.set( checkbox['name']  ,checkbox['checked'] ) ;
			// });
			// 
			form.setLoading(true);
			record.save({
				params : {
					unconfirm: true 
				},
				success : function(new_record){
					form.setLoading(false);
					
  
					
					list.enableRecordButtons();   
					AM.view.Constants.updateRecord( record, new_record );  
					AM.view.Constants.highlightSelectedRow( list );     
					
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
	


  deleteObject: function() {
    var record = this.getList().getSelectedObject();

    if (record) {
      var store = this.getSalesOrdersStore();
			store.remove(record);
			store.sync( );
 
			this.getList().query('pagingtoolbar')[0].doRefresh();
    }

  },

  selectionChange: function(selectionModel, selections) {
    var grid = this.getList();
		var me= this;
		var record = this.getList().getSelectedObject();
		if(!record){
			return; 
		}
		
		
		me.updateChildGrid(record );
		
		
		

    if (selections.length > 0) {
      grid.enableRecordButtons();
    } else {
      grid.disableRecordButtons();
    }
  },

	updateChildGrid: function(record){
		var templateDetailGrid = this.getSalesOrderDetailList();
		// templateDetailGrid.setTitle("Purchase Order: " + record.get('code'));
		templateDetailGrid.setObjectTitle( record ) ;
		
		// console.log("record id: " + record.get("id"));
		
		templateDetailGrid.getStore().getProxy().extraParams.sales_order_id =  record.get('id') ;
		 
		templateDetailGrid.getStore().load({
			params : {
				sales_order_id : record.get('id')
			},
			callback : function(records, options, success){
				templateDetailGrid.enableAddButton(); 
			}
		});
		
	},
	
	reloadRecord: function(record){
		
		var list = this.getList();
		var store = this.getList().getStore();
		var modifiedId = record.get('id');
		
		// console.log("modifiedId:  " + modifiedId);
		 
		AM.model.SalesOrder.load( modifiedId , {
		    scope: list,
		    failure: function(record, operation) {
		        //do something if the load failed
		    },
		    success: function(new_record, operation) {
					// console.log("The new record");
					// 				console.log( new_record);
					recToUpdate = store.getById(modifiedId);
					recToUpdate.set(new_record.getData());
					recToUpdate.commit();
					list.getView().refreshNode(store.indexOfId(modifiedId));
		    },
		    callback: function(record, operation) {
		        //do something whether the load succeeded or failed
		    }
		});
	},
	
	
	downloadObject: function(){
			var record = this.getList().getSelectedObject();
			var id = record.get("id");
			var currentUser = Ext.decode( localStorage.getItem('currentUser'));
			var auth_token_value = currentUser['auth_token'];
			if( record ){
				window.open( 'sales_orders/' + id + '.pdf'  + "?auth_token=" +auth_token_value );
			}
			
	},

	


});
