Ext.define('AM.controller.CoreBuilders', {
  extend: 'Ext.app.Controller',

  stores: ['CoreBuilders'],
  models: ['CoreBuilder'],

  views: [
    'master.corebuilder.List',
    'master.corebuilder.Form' 
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'corebuilderlist'
		},
		{
			ref : 'searchField',
			selector: 'corebuilderlist textfield[name=searchField]'
		}
	],

  init: function() {
    this.control({
      'corebuilderlist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'corebuilderform button[action=save]': {
        click: this.updateObject
      },
      'corebuilderlist button[action=addObject]': {
        click: this.addObject
      },
      'corebuilderlist button[action=editObject]': {
        click: this.editObject
      },
      'corebuilderlist button[action=deleteObject]': {
        click: this.deleteObject
      },
	  	'corebuilderlist textfield[name=searchField]': {
        change: this.liveSearch
      },
			'corebuilderlist button[action=markasdeceasedObject]': {
        click: this.markAsDeceasedObject
			}	,
			'markmemberasdeceasedform button[action=confirmDeceased]' : {
				click : this.executeConfirmDeceased
			},

			'corebuilderlist button[action=unmarkasdeceasedObject]': {
        click: this.unmarkAsDeceasedObject
			}	,
			'unmarkmemberasdeceasedform button[action=unconfirmDeceased]' : {
				click : this.executeConfirmUndeceased
			},
			
			'corebuilderlist button[action=markasrunawayObject]': {
        click: this.markAsRunAwayObject
			}	,
			'markmemberasrunawayform button[action=confirmRunAway]' : {
				click : this.executeConfirmRunAway
			},
		
    });
  },

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getCoreBuildersStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getCoreBuildersStore().load();
	},
	
	markAsDeceasedObject: function(){
		// console.log("mark as Deceased is clicked");
		var view = Ext.widget('markmemberasdeceasedform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
		view.down('form').getForm().findField('deceased_at').setValue(record.get('deceased_at')); 
    view.show();
	},
	
	executeConfirmDeceased : function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getCoreBuildersStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
			var rec_id = record.get("id");
			record.set( 'deceased_at' , values['deceased_at'] );
			 
			// form.query('checkbox').forEach(function(checkbox){
			// 	record.set( checkbox['name']  ,checkbox['checked'] ) ;
			// });
			// 
			form.setLoading(true);
			record.save({
				params : {
					mark_as_deceased: true 
				},
				success : function(record){
					form.setLoading(false);
					
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

	unmarkAsDeceasedObject: function(){
		// console.log("mark as Deceased is clicked");
		var view = Ext.widget('unmarkmemberasdeceasedform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
    view.show();
	},

	executeConfirmUndeceased : function(button){
		// console.log("unconfirm deceased");

		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getCoreBuildersStore();
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
					unmark_as_deceased: true 
				},
				success : function(record){
					form.setLoading(false);
					
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
	
	// RUN AWAY
	
	markAsRunAwayObject: function(){
		// console.log("mark as Deceased is clicked");
		var view = Ext.widget('markmemberasrunawayform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
		view.down('form').getForm().findField('run_away_at').setValue(record.get('run_away_at')); 
    view.show();
	},
	
	executeConfirmRunAway : function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getCoreBuildersStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
			var rec_id = record.get("id");
			record.set( 'run_away_at' , values['run_away_at'] );
			 
			// form.query('checkbox').forEach(function(checkbox){
			// 	record.set( checkbox['name']  ,checkbox['checked'] ) ;
			// });
			// 
			form.setLoading(true);
			record.save({
				params : {
					mark_as_run_away: true 
				},
				success : function(record){
					form.setLoading(false);
					
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
    var view = Ext.widget('corebuilderform');
    view.show();
  },

  editObject: function() {
		var me = this; 
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('corebuilderform');

		

    view.down('form').loadRecord(record);
    view.setComboBoxData( record ) ;
  },

  updateObject: function(button) {
		var me = this; 
    var win = button.up('window');
    var form = win.down('form');

    var store = this.getCoreBuildersStore();
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
			var newObject = new AM.model.CoreBuilder( values ) ;
			
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
      var store = this.getCoreBuildersStore();
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
