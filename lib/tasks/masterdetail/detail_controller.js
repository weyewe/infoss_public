Ext.define('AM.controller.TemplateDetails', {
  extend: 'Ext.app.Controller',

  stores: ['TemplateDetails', 'Templates'],
  models: ['TemplateDetail'],

  views: [
    'template.templatedetail.List',
    'template.templatedetail.Form',
		'template.template.List'
  ],

  refs: [
		{
			ref: 'list',
			selector: 'templatedetaillist'
		},
		{
			ref : 'parentList',
			selector : 'templatelist'
		}
	],

  init: function() {
    this.control({
      'templatedetaillist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange ,
				afterrender : this.loadObjectList
      },
      'templatedetailform button[action=save]': {
        click: this.updateObject
      },

	 
      'templatedetaillist button[action=addObject]': {
        click: this.addObject
      },

			'templatedetaillist button[action=repeatObject]': {
        click: this.addObject
      },


      'templatedetaillist button[action=editObject]': {
        click: this.editObject
      },
      'templatedetaillist button[action=deleteObject]': {
        click: this.deleteObject
      },
 
			// monitor parent(sales_order) update
			'templatelist' : {
				'updated' : this.reloadStore,
				'confirmed' : this.reloadStore,
				'deleted' : this.cleanList
			}
		
    });
  },

	loadObjectList : function(me){
		me.getStore().loadData([],false);
	},

	reloadStore : function(record){
		var list = this.getList();
		var store = this.getTemplateDetailsStore();
		
		store.load({
			params : {
				template_id : record.get('id')
			}
		});
		
		list.setObjectTitle(record);
	},
	
	cleanList : function(){
		var list = this.getList();
		var store = this.getTemplateDetailsStore();
		
		list.setTitle('');
		// store.removeAll(); 
		store.loadRecords([], {addRecords: false});
	},
 

  addObject: function(button) {
		
		// I want to get the currently selected item 
		var record = this.getParentList().getSelectedObject();
		if(!record){
			return; 
		}
		 
		var widgetName = 'templatedetailform'; 
		
    var view = Ext.widget(widgetName , {
			parentRecord : record 
		});
		view.setParentData( record );
		
    view.show(); 
  },

  editObject: function() {
		var parentRecord = this.getParentList().getSelectedObject();
		
    var record = this.getList().getSelectedObject();
		if(!record || !parentRecord){
			return; 
		}


		var widgetName = 'templatedetailform';
		 
    var view = Ext.widget(widgetName, {
			parentRecord : parentRecord
		});

    view.down('form').loadRecord(record);
		view.setParentData( parentRecord );
		// console.log("selected record id: " + record.get('id'));
		// console.log("The selected poe id: " + record.get('purchase_order_entry_id'));
		view.setComboBoxData(record); 
  },

  updateObject: function(button) {
  	button.disable();
  	var me  = this; 
    var win = button.up('window');
    var form = win.down('form');

		var parentRecord = this.getParentList().getSelectedObject();
	
    var store = this.getTemplateDetailsStore();
    var record = form.getRecord();
    var values = form.getValues();
		console.log("The values: " );
		console.log( values ) 
		
		if( record ){
			record.set( values );
			 
			form.query('checkbox').forEach(function(checkbox){
				record.set( checkbox['name']  ,checkbox['checked'] ) ;
			});
			
			form.setLoading(true);
			record.save({
				params : {
					template_id : parentRecord.get('id')
				},
				success : function(record){
					form.setLoading(false);
					//  since the grid is backed by store, if store changes, it will be updated
					// form.fireEvent('item_quantity_changed');
					store.load({
						params: {
							template_id : parentRecord.get('id')
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
		
			var newObject = new AM.model.TemplateDetail( values ) ;
			
		 
			
			form.query('checkbox').forEach(function(record){
				newObject.set( record['name']  ,record['checked'] ) ;
			});
			
			// populate the checkbox value to the object 
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
			newObject.save({
				params : {
					template_id : parentRecord.get('id')
				},
				success: function(record){
					//  since the grid is backed by store, if store changes, it will be updated
					store.load({
						params: {
							template_id : parentRecord.get('id')
						}
					});
					// form.fireEvent('item_quantity_changed');
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
		if(!record){return;}
		var parent_id = record.get('template_id');
		var list  = this.getList();
		list.setLoading(true); 
		
    if (record) {
			record.destroy({
				success : function(record){
					list.setLoading(false);
					list.fireEvent('deleted');	
					// this.getList().query('pagingtoolbar')[0].doRefresh();
					// console.log("Gonna reload the shite");
					// this.getPurchaseOrdersStore.load();
					list.getStore().load({
						params : {
							template_id : parent_id
						}
					});
				},
				failure : function(record,op ){
					list.setLoading(false);
					
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					
					if( errors["generic_errors"] ){
						Ext.MessageBox.show({
						           title: 'DELETE FAIL',
						           msg: errors["generic_errors"],
						           buttons: Ext.MessageBox.OK, 
						           icon: Ext.MessageBox.ERROR
						       });
					}
					
				}
			});
    }

  },

  selectionChange: function(selectionModel, selections) {
    var grid = this.getList();

		// var record = this.getList().getSelectedObject();

    if (selections.length > 0) {
      grid.enableRecordButtons();
    } else {
      grid.disableRecordButtons();
    }
  }

});
