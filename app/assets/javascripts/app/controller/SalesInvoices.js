Ext.define('AM.controller.SalesInvoices', {
  extend: 'Ext.app.Controller',

  stores: ['SalesInvoices'],
  models: ['SalesInvoice'],

  views: [
    'operation.salesinvoice.List',
    'operation.salesinvoice.Form',
    'operation.salesinvoice.FilterForm',
		'operation.salesinvoicedetail.List',
		'Viewport'
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'salesinvoicelist'
		},
		{
			ref : 'salesInvoiceDetailList',
			selector : 'salesinvoicedetaillist'
		},
		
		{
			ref : 'form',
			selector : 'salesinvoiceform'
		},
		{
			ref: 'viewport',
			selector: 'vp'
		},
	],

  init: function() {
    this.control({
      'salesinvoiceProcess salesinvoicelist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'salesinvoiceProcess salesinvoiceform button[action=save]': {
        click: this.updateObject
      },
			'salesinvoiceProcess salesinvoiceform customcolorpicker' : {
				'colorSelected' : this.onColorPickerSelect
			},

      'salesinvoiceProcess salesinvoicelist button[action=addObject]': {
        click: this.addObject
      },
      'salesinvoiceProcess salesinvoicelist button[action=editObject]': {
        click: this.editObject
      },
      'salesinvoiceProcess salesinvoicelist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			
			'salesinvoiceProcess salesinvoicelist button[action=confirmObject]': {
        click: this.confirmObject
      },

			'salesinvoiceProcess salesinvoicelist button[action=unconfirmObject]': {
        click: this.unconfirmObject
      },
			'confirmsalesinvoiceform button[action=confirm]' : {
				click : this.executeConfirm
			},
			
			'unconfirmsalesinvoiceform button[action=confirm]' : {
				click : this.executeUnconfirm
			},

			'salesinvoiceProcess salesinvoicelist textfield[name=searchField]': {
				change: this.liveSearch
			},
			'salesinvoiceform button[action=save]': {
        click: this.updateObject
      },
      
      'salesinvoiceProcess salesinvoicelist button[action=downloadObject]': {
			    click: this.downloadObject
			},
	    'salesinvoiceProcess salesinvoicelist button[action=filterObject]': {
	        click: this.filterObject
	    },
	    'filtersalesinvoiceform button[action=save]' : {
	    	click : this.executeFilterObject  
	    },
	    
	    'filtersalesinvoiceform button[action=reset]' : {
	    	click : this.executeResetFilterObject  
	    },
	    
			

		
    });
  },
  

      
  filterObject: function() {
  	// console.log("inside the filter object");
  	var me = this; 
		var view = Ext.widget('filtersalesinvoiceform');
		
		view.setPreviousValue( me.getSalesInvoicesStore().getProxy().extraParams ); 
		
	  view.show(); 
  },
  
  executeFilterObject: function(button) {
  	var win = button.up('window');
    var form = win.down('form');
  	var me  = this; 
		var store = this.getList().getStore();
		me.getSalesInvoicesStore().currentPage  = 1; 
		
		
    var values = form.getValues(); 
 
		var extraParams = {};
		extraParams = {
			livesearch: me.getSalesInvoicesStore().getProxy().extraParams["livesearch"]
		};
		 
		for (var k in values) {
		    if (values.hasOwnProperty(k)) {
		    	 
		    	if(   	values[k] === null  ||  	values[k] == "" 	){
		    			 continue; 
		    	 }
		    	
		    	extraParams[k] = values[k]; 
		    }
		}
		 
		 
		me.getSalesInvoicesStore().getProxy().extraParams = extraParams;
		 
		me.getSalesInvoicesStore().load();
		win.close();
  },
  
  executeResetFilterObject: function(button) {
  	var win = button.up('window');
    var form = win.down('form');
  	var me  = this; 
		var store = this.getList().getStore();
		me.getSalesInvoicesStore().currentPage  = 1; 
		
		
    var values = form.getValues(); 
 
		var extraParams = {};
		extraParams = {
			livesearch: me.getSalesInvoicesStore().getProxy().extraParams["livesearch"]
		};
		  
		me.getSalesInvoicesStore().getProxy().extraParams = extraParams;
		 
		me.getSalesInvoicesStore().load();
		win.close();
  },
	  
	 downloadObject: function(){
			var record = this.getList().getSelectedObject();
			var id = record.get("id");
			var currentUser = Ext.decode( localStorage.getItem('currentUser'));
			var auth_token_value = currentUser['auth_token'];
			if( record ){
				window.open( 'sales_invoices/' + id + '.pdf' + "?auth_token=" +auth_token_value);
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

		me.getSalesInvoicesStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getSalesInvoicesStore().load();
	},
 

	loadObjectList : function(me){
		// console.log( "I am inside the load object list" ); 
		me.getStore().load();
	},

  addObject: function() {
	var view = Ext.widget('salesinvoiceform');
  view.show();

	 
  },

  editObject: function() {
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('salesinvoiceform');

    view.down('form').loadRecord(record);
    view.setComboBoxData( record ) ;
  },

	confirmObject: function(){
		// console.log("the startObject callback function");
		var record = this.getList().getSelectedObject();
		if(record){
			var view = Ext.widget('confirmsalesinvoiceform');

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

    var store = this.getSalesInvoicesStore();
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
			var newObject = new AM.model.SalesInvoice( values ) ; 
			
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
		var view = Ext.widget('unconfirmsalesinvoiceform');
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

    var store = this.getSalesInvoicesStore();
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

    var store = this.getSalesInvoicesStore();
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
      var store = this.getSalesInvoicesStore();
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
		var templateDetailGrid = this.getSalesInvoiceDetailList();
		// templateDetailGrid.setTitle("Purchase Order: " + record.get('code'));
		templateDetailGrid.setObjectTitle( record ) ;
		
		// console.log("record id: " + record.get("id"));
		
		templateDetailGrid.getStore().getProxy().extraParams.sales_invoice_id =  record.get('id') ;
		 
		templateDetailGrid.getStore().load({
			params : {
				sales_invoice_id : record.get('id')
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
		 
		AM.model.SalesInvoice.load( modifiedId , {
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
