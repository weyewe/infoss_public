Ext.define('AM.controller.BlanketResults', {
  extend: 'Ext.app.Controller',

  stores: ['BlanketResults'],
  models: ['BlanketResult'],

  views: [
    'operation.blanketresult.List',
    'operation.blanketresult.Form',
		'operation.blanketresultdetail.List',
		'Viewport'
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'blanketresultlist'
		},
		{
			ref : 'blanketResultDetailList',
			selector : 'blanketresultdetaillist'
		},
		
		{
			ref : 'form',
			selector : 'blanketresultform'
		},
		{
			ref: 'viewport',
			selector: 'vp'
		},
	],

  init: function() {
    this.control({
      'blanketresultProcess blanketresultlist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'blanketresultProcess blanketresultform button[action=save]': {
        click: this.updateObject
      },
			'blanketresultProcess blanketresultform customcolorpicker' : {
				'colorSelected' : this.onColorPickerSelect
			},

      'blanketresultProcess blanketresultlist button[action=addObject]': {
        click: this.addObject
      },
      'blanketresultProcess blanketresultlist button[action=editObject]': {
        click: this.editObject
      },
      'blanketresultProcess blanketresultlist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			
			'blanketresultProcess blanketresultlist button[action=finishObject]': {
        click: this.finishObject
      },

			'blanketresultProcess blanketresultlist button[action=unfinishObject]': {
        click: this.unfinishObject
      },
			'finishblanketresultform button[action=finish]' : {
				click : this.executeFinish
			},
			
			'unfinishblanketresultform button[action=finish]' : {
				click : this.executeUnfinish
			},

			'blanketresultProcess blanketresultlist textfield[name=searchField]': {
				change: this.liveSearch
			},
			'blanketresultform button[action=save]': {
        click: this.updateObject
      }
		
    });
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

		me.getBlanketResultsStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getBlanketResultsStore().load();
	},
 

	loadObjectList : function(me){
		// console.log( "I am inside the load object list" ); 
		me.getStore().load();
	},

  addObject: function() {
	var view = Ext.widget('blanketresultform');
  view.show();

	 
  },

  editObject: function() {
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('blanketresultform');

    view.down('form').loadRecord(record);
    view.setComboBoxData( record ) ;
  },



  updateObject: function(button) {
  	button.disable();
  	var me  = this; 
    var win = button.up('window');
    var form = win.down('form');
		var me = this; 

    var store = this.getBlanketResultsStore();
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
			var newObject = new AM.model.BlanketResult( values ) ; 
			
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
  
	finishObject: function(){
		// console.log("the startObject callback function");
		console.log("clicked the finishObject");
		var record = this.getList().getSelectedObject();
		if(record){
			var view = Ext.widget('finishblanketresultform');

			view.setParentData( record );
	    view.show();
		} 
	},

	unfinishObject: function(){
		// console.log("the startObject callback function");
		var view = Ext.widget('unfinishblanketresultform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
    view.show();
		// this.reloadRecordView( record, view ) ; 
	},
	
	executeFinish: function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getBlanketResultsStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
		 
			
			record.set( 'finished_at' , values['finished_at'] );
			record.set( 'finished_quantity' , values['finished_quantity'] );
			record.set( 'rejected_quantity' , values['rejected_quantity'] );
			record.set( 'roll_blanket_usage' , values['roll_blanket_usage'] );
			record.set( 'roll_blanket_defect' , values['roll_blanket_defect'] );
			record.set( 'roll_blanket_defect' , values['roll_blanket_defect'] );
			 
			form.query('checkbox').forEach(function(checkbox){
				record.set( checkbox['name']  ,checkbox['checked'] ) ;
			});
			
			form.setLoading(true);
			record.save({
				params : {
					finish: true 
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
	 
	
	
	
	executeUnfinish: function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getBlanketResultsStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
			var rec_id = record.get("id");
			record.set( 'finished_at' , values['finished_at'] );
			 
			// form.query('checkbox').forEach(function(checkbox){
			// 	record.set( checkbox['name']  ,checkbox['checked'] ) ;
			// });
			// 
			form.setLoading(true);
			record.save({
				params : {
					unfinish: true 
				},
				success : function(new_record){
					form.setLoading(false);
					
					// me.reloadRecord( record ) ; 
					
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
      var store = this.getBlanketResultsStore();
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
		var templateDetailGrid = this.getBlanketResultDetailList();
		// templateDetailGrid.setTitle("Purchase Order: " + record.get('code'));
		templateDetailGrid.setObjectTitle( record ) ;
		
		// console.log("record id: " + record.get("id"));
		
		templateDetailGrid.getStore().getProxy().extraParams.blanket_result_id =  record.get('id') ;
		 
		templateDetailGrid.getStore().load({
			params : {
				blanket_result_id : record.get('id')
			},
			callback : function(records, options, success){
				templateDetailGrid.enableAddButton(); 
			}
		});
		
	},
	
	reloadRecord: function(record){

		var data = record.data ; 
		 for (var k in data) {
        if (data.hasOwnProperty(k)) {
            
            if( k !== "id"){ 
            	record.set( k, data[k]);
            }
        }
    }
		
		// var list = this.getList();
		// var store = this.getList().getStore();
		// var modifiedId = record.get('id');
		
		// // console.log("modifiedId:  " + modifiedId);
		 
		// AM.model.BlanketResult.load( modifiedId , {
		//     scope: list,
		//     failure: function(record, operation) {
		//         //do something if the load failed
		//     },
		//     success: function(new_record, operation) {
		// 			// console.log("The new record");
		// 			// 				console.log( new_record);
		// 			recToUpdate = store.getById(modifiedId);
		// 			recToUpdate.set(new_record.getData());
		// 			recToUpdate.commit();
		// 			list.getView().refreshNode(store.indexOfId(modifiedId));
		//     },
		//     callback: function(record, operation) {
		//         //do something whether the load succeeded or failed
		//     }
		// });
	},

	


});
