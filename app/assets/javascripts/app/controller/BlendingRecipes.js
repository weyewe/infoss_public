Ext.define('AM.controller.BlendingRecipes', {
  extend: 'Ext.app.Controller',

  stores: ['BlendingRecipes'],
  models: ['BlendingRecipe'],

  views: [
    'master.blendingrecipe.List',
    'master.blendingrecipe.Form',
		'master.blendingrecipedetail.List',
		'Viewport'
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'blendingrecipelist'
		},
		{
			ref : 'blendingRecipeDetailList',
			selector : 'blendingrecipedetaillist'
		},
		
		{
			ref : 'form',
			selector : 'blendingrecipeform'
		},
		{
			ref: 'viewport',
			selector: 'vp'
		},
	],

  init: function() {
    this.control({
      'blendingrecipeProcess blendingrecipelist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'blendingrecipeProcess blendingrecipeform button[action=save]': {
        click: this.updateObject
      },
			'blendingrecipeProcess blendingrecipeform customcolorpicker' : {
				'colorSelected' : this.onColorPickerSelect
			},

      'blendingrecipeProcess blendingrecipelist button[action=addObject]': {
        click: this.addObject
      },
      'blendingrecipeProcess blendingrecipelist button[action=editObject]': {
        click: this.editObject
      },
      'blendingrecipeProcess blendingrecipelist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			
			'blendingrecipeProcess blendingrecipelist textfield[name=searchField]': {
				change: this.liveSearch
			},
			'blendingrecipeform button[action=save]': {
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

		me.getBlendingRecipesStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getBlendingRecipesStore().load();
	},
 

	loadObjectList : function(me){
		// console.log( "I am inside the load object list" ); 
		me.getStore().load();
	},

  addObject: function() {
	var view = Ext.widget('blendingrecipeform');
  view.show();

	 
  },

  editObject: function() {
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('blendingrecipeform');

    view.down('form').loadRecord(record);
    view.setComboBoxData( record ) ;
  },


  updateObject: function(button) {
  	button.disable();
  	var me  = this; 
    var win = button.up('window');
    var form = win.down('form');
		var me = this; 

    var store = this.getBlendingRecipesStore();
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
			var newObject = new AM.model.BlendingRecipe( values ) ; 
			
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

  deleteObject: function() {
    var record = this.getList().getSelectedObject();

    if (record) {
      var store = this.getBlendingRecipesStore();
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
		var templateDetailGrid = this.getBlendingRecipeDetailList();
		// templateDetailGrid.setTitle("Purchase Order: " + record.get('code'));
		templateDetailGrid.setObjectTitle( record ) ;
		
		// console.log("record id: " + record.get("id"));
		
		templateDetailGrid.getStore().getProxy().extraParams.blending_recipe_id =  record.get('id') ;
		 
		templateDetailGrid.getStore().load({
			params : {
				blending_recipe_id : record.get('id')
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
		 
		AM.model.BlendingRecipe.load( modifiedId , {
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
