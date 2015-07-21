Ext.define('AM.controller.DeliveryOrders', {
  extend: 'Ext.app.Controller',

  stores: ['DeliveryOrders'],
  models: ['DeliveryOrder'],

  views: [
    'operation.deliveryorder.List',
    'operation.deliveryorder.Form',
    'operation.deliveryorder.FilterForm',
		'operation.deliveryorderdetail.List',
		'Viewport'
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'deliveryorderlist'
		},
		{
			ref : 'deliveryOrderDetailList',
			selector : 'deliveryorderdetaillist'
		},
		
		{
			ref : 'form',
			selector : 'deliveryorderform'
		},
		{
			ref: 'viewport',
			selector: 'vp'
		},
	],

  init: function() {
    this.control({
      'deliveryorderProcess deliveryorderlist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'deliveryorderProcess deliveryorderform button[action=save]': {
        click: this.updateObject
      },
			'deliveryorderProcess deliveryorderform customcolorpicker' : {
				'colorSelected' : this.onColorPickerSelect
			},

      'deliveryorderProcess deliveryorderlist button[action=addObject]': {
        click: this.addObject
      },
      'deliveryorderProcess deliveryorderlist button[action=editObject]': {
        click: this.editObject
      },
      'deliveryorderProcess deliveryorderlist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			
			'deliveryorderProcess deliveryorderlist button[action=confirmObject]': {
        click: this.confirmObject
      },

			'deliveryorderProcess deliveryorderlist button[action=unconfirmObject]': {
        click: this.unconfirmObject
      },
			'confirmdeliveryorderform button[action=confirm]' : {
				click : this.executeConfirm
			},
			
			'unconfirmdeliveryorderform button[action=confirm]' : {
				click : this.executeUnconfirm
			},

			'deliveryorderProcess deliveryorderlist textfield[name=searchField]': {
				change: this.liveSearch
			},
			'deliveryorderform button[action=save]': {
        click: this.updateObject
      },
      
      'deliveryorderProcess deliveryorderlist button[action=downloadObject]': {
        click: this.downloadObject
			}	,
		
      'deliveryorderProcess deliveryorderlist button[action=filterObject]': {
        click: this.filterObject
      },
			'filterdeliveryorderform button[action=save]' : {
				click : this.executeFilterObject  
			},
			
			'filterdeliveryorderform button[action=reset]' : {
				click : this.executeResetFilterObject  
			},
		
    });
  },
  
  filterObject: function() {
  	// console.log("inside the filter object");
  	var me = this; 
		var view = Ext.widget('filterdeliveryorderform');
		
		view.setPreviousValue( me.getDeliveryOrdersStore().getProxy().extraParams ); 
		
	  view.show(); 
  },
  
  executeFilterObject: function(button) {
  	var win = button.up('window');
    var form = win.down('form');
  	var me  = this; 
		var store = this.getList().getStore();
		me.getDeliveryOrdersStore().currentPage  = 1; 
		
		
    var values = form.getValues(); 
 
		var extraParams = {};
		extraParams = {
			livesearch: me.getDeliveryOrdersStore().getProxy().extraParams["livesearch"]
		};
		 
		for (var k in values) {
		    if (values.hasOwnProperty(k)) {
		    	 
		    	if(   	values[k] === null  ||  	values[k] == "" 	){
		    			 continue; 
		    	 }
		    	
		    	extraParams[k] = values[k]; 
		    }
		}
		 
		 
		me.getDeliveryOrdersStore().getProxy().extraParams = extraParams;
		


 
	 
		me.getDeliveryOrdersStore().load();
		win.close();
  },
  
  executeResetFilterObject: function(button) {
  	var win = button.up('window');
    var form = win.down('form');
  	var me  = this; 
		var store = this.getList().getStore();
		me.getDeliveryOrdersStore().currentPage  = 1; 
		
		
    var values = form.getValues();
    // console.log("The values");
    // console.log( values ) ;

 
		var extraParams = {};
		extraParams = {
			livesearch: me.getDeliveryOrdersStore().getProxy().extraParams["livesearch"]
		};
		 
	 
		 
		me.getDeliveryOrdersStore().getProxy().extraParams = extraParams;
		 
		me.getDeliveryOrdersStore().load();
		win.close();
  },
  
	downloadObject: function(){
			var record = this.getList().getSelectedObject();
			var id = record.get("id");
			var currentUser = Ext.decode( localStorage.getItem('currentUser'));
			var auth_token_value = currentUser['auth_token'];
			if( record ){
				window.open( 'delivery_orders/' + id + '.pdf' + "?auth_token=" +auth_token_value);
			}
			
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

		me.getDeliveryOrdersStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getDeliveryOrdersStore().load();
	},
 

	loadObjectList : function(me){
		// console.log( "I am inside the load object list" ); 
		me.getStore().load();
	},

  addObject: function() {
	var view = Ext.widget('deliveryorderform');
  view.show();

	 
  },

  editObject: function() {
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('deliveryorderform');

    view.down('form').loadRecord(record);
    view.setComboBoxData( record ) ;
  },

	confirmObject: function(){
		// console.log("the startObject callback function");
		var record = this.getList().getSelectedObject();
		if(record){
			var view = Ext.widget('confirmdeliveryorderform');

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

    var store = this.getDeliveryOrdersStore();
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
			var newObject = new AM.model.DeliveryOrder( values ) ; 
			
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
		var view = Ext.widget('unconfirmdeliveryorderform');
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

    var store = this.getDeliveryOrdersStore();
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
					
					// me.reloadRecord( record ) ; 
					
					list.enableRecordButtons();  
					AM.view.Constants.updateRecord( record, new_record );  
					AM.view.Constants.highlightSelectedRow( list );      
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

    var store = this.getDeliveryOrdersStore();
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
					
					// me.reloadRecord( record ) ; 
					list.enableRecordButtons();  
					AM.view.Constants.updateRecord( record, new_record );  
					AM.view.Constants.highlightSelectedRow( list );      
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
      var store = this.getDeliveryOrdersStore();
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
		var templateDetailGrid = this.getDeliveryOrderDetailList();
		// templateDetailGrid.setTitle("Purchase Order: " + record.get('code'));
		templateDetailGrid.setObjectTitle( record ) ;
		
		// console.log("record id: " + record.get("id"));
		
		templateDetailGrid.getStore().getProxy().extraParams.delivery_order_id =  record.get('id') ;
		 
		templateDetailGrid.getStore().load({
			params : {
				delivery_order_id : record.get('id')
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
		 
		AM.model.DeliveryOrder.load( modifiedId , {
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

	


});
