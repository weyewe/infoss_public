Ext.define('AM.controller.ExchangeRates', {
  extend: 'Ext.app.Controller',

  stores: ['ExchangeRates', 'Exchanges'],
  models: ['ExchangeRate'],

  views: [
    'master.exchangerate.List',
    'master.exchangerate.Form',
		'master.ExchangeRate',
  ],

  	refs: [
		{
			ref : "viewport",
			selector : "vp"
		},
		{
			ref : "wrapper",
			selector : "exchangerateProcess"
		},
		{
			ref : 'parentList',
			selector : 'exchangerateProcess masterexchangeList'
		},
		{
			ref: 'list',
			selector: 'exchangeratelist'
		},
		{
			ref : 'searchField',
			selector: 'exchangeratelist textfield[name=searchField]'
		}
	],

  init: function() {
    this.control({
			'exchangerateProcess masterexchangeList' : {
				afterrender : this.loadParentObjectList,
				selectionchange: this.parentSelectionChange,
			},
	
      'exchangeratelist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				// afterrender : this.loadObjectList,
				'confirmed' : this.reloadParentRow,
				destroy : this.onDestroy
      },
      'exchangerateform button[action=save]': {
        click: this.updateObject
      },
      'exchangeratelist button[action=addObject]': {
        click: this.addObject
      },

			'exchangeratelist button[action=addLockedObject]': {
        click: this.addLockedObject
      },

			'exchangeratelist button[action=addExchangeshipObject]': {
        click: this.addExchangeshipObject
      },

      'exchangeratelist button[action=editObject]': {
        click: this.editObject
      },
      'exchangeratelist button[action=deleteObject]': {
        click: this.deleteObject
      },

			'exchangeratelist button[action=confirmObject]': {
        click: this.confirmObject
			}	,
			
 
			 
	 
			
			'exchangerateProcess masterexchangeList textfield[name=searchField]': {
        change: this.liveSearch
      }
		
    });
  },

	onDestroy: function(){
		// console.log("on Destroy the savings_entries list ");
		this.getExchangeRatesStore().loadData([],false);
	},
	
	// try this guy: http://www.learnsomethings.com/2012/02/01/re-selecting-the-last-selected-record-after-store-load-in-extjs4/

	reloadParentRow: function(){
		
		// http://vadimpopa.com/reload-a-single-record-and-refresh-its-extjs-grid-row/
		
		var parentList = this.getParentList();
	
		var wrapper = this.getWrapper();
		modifiedId = wrapper.selectedParentId;
		var me = this; 
		
		
	 
		
		
/*
	// parentList.getView().
	// http://www.sencha.com/forum/showthread.php?258071-How-to-get-an-Element-of-a-grid-row-in-Ext-JS-4&p=945574
	// awesome discussion
	This shite is working.. but the effect is not selected effect
	var node = parentList.getView().getNode(0);
	console.log("The node: " );
	console.log( node );
	
	console.log(parentList.getView().getXType());
	
	result = parentList.getView().highlightItem( node );
*/
		var selectedRecord = parentList.getSelectionModel().getSelection()[0];
		var row = parentList.store.indexOf(selectedRecord);

		// console.log("The row" ) ;
		// console.log( row ) ;

		var node = parentList.getView().getNode(row);
	
		
		
		
		AM.model.Exchange.load( modifiedId , {
		    scope: parentList,
		    failure: function(record, operation) {
		        //do something if the load failed
		    },
		    success: function(record, operation) {
					
					var store = parentList.getStore(),
					recToUpdate = store.getById(modifiedId);

					recToUpdate.set(record.getData());

					recToUpdate.commit();

					parentList.getView().refreshNode(store.indexOfId(modifiedId));
					
					
					
		    },
		    callback: function(record, operation) {
					// result = parentList.getView().highlightItem( node );
					// console.log("The row: " + row);
					
					// 'exchangerateProcess masterexchangeList'   << the selector 
					
					// var textfieldChangeObj = this.eventbus.bus.selectionchange['exchangerateProcess masterexchangeList'].Login[0];
					// var textfield = btn.up("form").down("textfield[name='username']");        
					// textfieldChangeObj.suspend(true);
					// textfield.setValue('asasas');
					// textfieldChangeObj.resume(false);
					
					// Ext.util.Observable.suspendEvents(true);
					
					
					// this.suspendEvents();
					// 		node.collapseChildNodes(true);
					// 		this.resumeEvents();
					// 		
					// 		
					// me.suspendEvents(  ) ;
					// parentList.getSelectionModel().select( null );
					// parentList.ClearSelection()
					
					parentList.getSelectionModel().clearSelections()
					
					parentList.getSelectionModel().select( row  );
					// me.resumeEvents(false);
					
					// var rowIndex = me.getExchangesStore().find('id', record.getId());  //where 'id': the id field of your model, record.getId() is the method automatically created by Extjs. You can replace 'id' with your unique field.. And 'this' is your store.
					// parentList.getView().select(rowIndex);
		    }
		});
		
	},

	liveSearch : function(grid, newValue, oldValue, options){
		// console.log("Live search is called");
		var me = this;

		me.getExchangesStore().getProxy().extraParams = {
		    livesearch: newValue,				// 
		    				// is_deceased : true, 
		    				// is_run_away : true 
		};
	 
		me.getExchangesStore().load();
	},
 

	loadObjectList : function(me){
		me.getStore().load();
	},
	
	loadParentObjectList: function(me){
		// delete me.getStore().getProxy().extraParams ;
		me.getStore().getProxy().extraParams = {}
		me.getStore().load(); 
	},
 
	baseAddObject: function( parentObject, savingsStatus ) {
		var view = Ext.widget('exchangerateform');
		view.show();
		view.setParentData(parentObject); 
	},
	
	
	// addObject: function() {
	//     
	// 	var parentObject  = this.getParentList().getSelectedObject();
	// 	if( parentObject) {
	// 		var view = Ext.widget('exchangerateform');
	// 		view.show();
	// 		view.setParentData(parentObject);
	// 	}
	//   },

	addObject: function() {
    
		var parentObject  = this.getParentList().getSelectedObject();
		if( parentObject) {
			this.baseAddObject( parentObject, 0);  
		}
  },
 
	

	editObject: function() {
		var me = this; 
    var record = this.getList().getSelectedObject();
		var parentObject  = this.getParentList().getSelectedObject();
		
		if( parentObject) {
			var view = Ext.widget('exchangerateform');
			view.show();
			view.down('form').loadRecord(record);
			view.setParentData(parentObject); 
		}
		
		
    // var view = Ext.widget('exchangerateform');
    
  },

  updateObject: function(button) {
		var me = this; 
    var win = button.up('window');
    var form = win.down('form');
		var parentList = this.getParentList();
		var wrapper = this.getWrapper();

    var store = this.getExchangeRatesStore();
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
					
					// store.getProxy().extraParams = {
					//     livesearch: ''
					// };
	 
					store.load({
						params: {
							parent_id : wrapper.selectedParentId 
						}
					});
					 
					
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
			var newObject = new AM.model.ExchangeRate( values ) ;
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
			newObject.save({
				success: function(record){
	
					store.load({
						params: {
							parent_id : wrapper.selectedParentId 
						}
					});
					
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
      var store = this.getExchangeRatesStore();
      store.remove(record);
      store.sync();
// to do refresh programmatically
			this.getList().query('pagingtoolbar')[0].doRefresh();
    }

  },

  selectionChange: function(selectionModel, selections) {
    var grid = this.getList();
  
    if (selections.length > 0) {
			var record = this.getList().getSelectedObject();
      grid.enableRecordButtons();
			
			
    } else {
      grid.disableRecordButtons();
    }
  },

 
 
	 
	parentSelectionChange: function(selectionModel, selections) {
		var me = this; 
    var grid = me.getList();
		var parentList = me.getParentList();
		var wrapper = me.getWrapper();
		
		var selectedParentRecord = parentList.getSelectedObject();
		
		// console.log("The selectedParentRecord: " );
		// console.log( selectedParentRecord);
		// if( selectedParentRecord == undefined){
		// 	return;
		// }
		
		// if (typeof(selectedParentRecord) == 'undefined' || selectedParentRecord == null)
		// {
		// 	return; 
		// }
		
		
		var title = "";
		if( selectedParentRecord ){
			title = selectedParentRecord.get("name") ;
		}else{
			title = "";
		}
		grid.setTitle( title );
		
		
		// grid.setTitle( selectedParentRecord.get("name") + " | " + selectedParentRecord.get("id_number"));
		
		// console.log("parent selection change");
		// console.log("The wrapper");
		// console.log( wrapper ) ;

		if (selections.length > 0) {
			grid.enableAddButton();
			// grid.enableRecordButtons();
		} else {
			grid.disableAddButton();
			// grid.disableRecordButtons();
		}
		
		 
		if (parentList.getSelectionModel().hasSelection()) {
			var row = parentList.getSelectionModel().getSelection()[0];
			var id = row.get("id"); 
			wrapper.selectedParentId = id ; 
		}
		
		
		
		// console.log("The parent ID: "+ wrapper.selectedParentId );
		
		// grid.setLoading(true); 
		grid.getStore().getProxy().extraParams.parent_id =  wrapper.selectedParentId ;
		grid.getStore().getProxy().extraParams.is_savings_account =  true ;
		grid.getStore().load(); 
  },
 
 
});
