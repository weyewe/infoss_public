Ext.define('AM.controller.BlanketWorkProcesses', {
  extend: 'Ext.app.Controller',

  stores: ['BlanketWorkProcesses'],
  models: ['BlanketWorkProcess'],

  views: [
    'operation.blanketworkprocess.List',
    'operation.blanketworkprocess.Form' 
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'blanketworkprocesslist'
		},
		{
			ref : 'searchField',
			selector: 'blanketworkprocesslist textfield[name=searchField]'
		}
	],

  init: function() {
    this.control({
      'blanketworkprocesslist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'blanketworkprocessform button[action=save]': {
        click: this.updateObject
      },
      'blanketworkprocesslist button[action=addObject]': {
        click: this.addObject
      },
      'blanketworkprocesslist button[action=editObject]': {
        click: this.editObject
      },
      'blanketworkprocesslist button[action=deleteObject]': {
        click: this.deleteObject
      },
	  	'blanketworkprocesslist textfield[name=searchField]': {
        change: this.liveSearch
      },
			'blanketworkprocesslist button[action=finishObject]': {
        click: this.finishObject
			}	,
			'blanketworkprocesslist button[action=unfinishObject]': {
        click: this.unfinishObject
			}	,
			
			'finishblanketworkprocessform button[action=confirm]' : {
				click : this.executeFinish
			},

			'unfinishblanketworkprocessform button[action=confirm]' : {
				click : this.executeUnfinish
			},
			
    });
  },

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getBlanketWorkProcessesStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getBlanketWorkProcessesStore().load();
	},
	
	finishObject: function(){
		// console.log("the startObject callback function");
		var record = this.getList().getSelectedObject();
		if(record){
			var view = Ext.widget('finishblanketworkprocessform');

			view.setParentData( record );
	    view.show();
		}
		
		
		// this.reloadRecordView( record, view ) ; 
	},
	
	unfinishObject: function(){
		// console.log("the startObject callback function");
		var view = Ext.widget('unfinishblanketworkprocessform');
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

    var store = this.getBlendingWorkOrdersStore();
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
	
	executeUnfinish: function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getBlendingWorkOrdersStore();
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

	loadObjectList : function(me){
		me.getStore().getProxy().extraParams = {}
		me.getStore().load();
	},

  addObject: function() {
    var view = Ext.widget('blanketworkprocessform');
    view.show();
  },

  editObject: function() {
		var me = this; 
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('blanketworkprocessform');

		

    view.down('form').loadRecord(record);
    view.setComboBoxData( record ) ;
  },

  updateObject: function(button) {
		var me = this; 
    var win = button.up('window');
    var form = win.down('form');

    var store = this.getBlanketWorkProcessesStore();
    var record = form.getRecord();
    var values = form.getValues();


		// console.log("The values");
		// console.log( values);
		form.query('checkbox').forEach(function(checkbox){
						// 
						// record.set( checkbox['name']  ,checkbox['checked'] ) ;
						// console.log("the checkbox name: " +  checkbox['name']   );
						// console.log("the checkbox value: " + checkbox['checked']  );
			values[checkbox['name']] = checkbox['checked'];
		});
		
		
		
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
			var newObject = new AM.model.BlanketWorkProcess( values ) ;
			
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
      var store = this.getBlanketWorkProcessesStore();
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
