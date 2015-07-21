Ext.define("AM.controller.Master", {
	extend : "AM.controller.BaseTreeBuilder",
	views : [
		"master.MasterProcessList",
		'MasterProcessPanel',
		'Viewport'
	],

	 
	
	refs: [
		{
			ref: 'masterProcessPanel',
			selector: 'masterProcessPanel'
		} ,
		{
			ref: 'masterProcessList',
			selector: 'masterProcessList'
		}  
	],
	

	 
	init : function( application ) {
		var me = this; 
		 
		// console.log("starting the init in Master.js");
		me.control({
			"masterProcessPanel" : {
				activate : this.onActiveProtectedContent,
				deactivate : this.onDeactivated
			} 
			
		});
		
	},
	
	onDeactivated: function(){
		// console.log("Master process panel is deactivated");
		var worksheetPanel = Ext.ComponentQuery.query("masterProcessPanel #worksheetPanel")[0];
		worksheetPanel.setTitle(false);
		// worksheetPanel.setHeader(false);
		worksheetPanel.removeAll();		 
		var defaultWorksheet = Ext.create( "AM.view.master.Default");
		worksheetPanel.add(defaultWorksheet); 
	},
	
	 

	setupFolder : {
		text 			: "System Setup", 
		viewClass : '',
		iconCls		: 'text-folder', 
		expanded	: true,
		children 	: [
        
			{ 
				text:'User', 
				viewClass:'AM.view.master.User', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'users',
					action : 'index'
				}
				]
			},  
			{ 
				text:'Employee', 
				viewClass:'AM.view.master.Employee', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'employees',
					action : 'index'
				}
				]
			},  
    ]
	},
	
	customerSetupFolder : {
		text 			: "Contact", 
		viewClass : '',
		iconCls		: 'text-folder', 
		expanded	: true,
		children 	: [
        	{ 
				text:'Group', 
				viewClass:'AM.view.master.ContactGroup', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'contact_groups',
						action : 'index'
					}
				]
			}, 
		  
			{ 
				text:'Supplier', 
				viewClass:'AM.view.master.Supplier', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'suppliers',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Customer', 
				viewClass:'AM.view.master.Customer', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'customers',
						action : 'index'
					}
				]
			}, 
    ]
	},
	
	itemSetupFolder : {
		text 			: "Inventory Setup", 
		viewClass : '',
		iconCls		: 'text-folder', 
		expanded	: true,
		children 	: [
			
			
			{ 
				text:'Warehouse', 
				viewClass:'AM.view.master.Warehouse', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'warehouses',
						action : 'index'
					}
				]
			}, 
        	{ 
				text:'Item Type', 
				viewClass:'AM.view.master.ItemType', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'item_types',
						action : 'index'
					}
				]
			}, 
		  
			{ 
				text:'SubType', 
				viewClass:'AM.view.master.SubType', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'sub_types',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'UoM', 
				viewClass:'AM.view.master.Uom', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'uoms',
						action : 'index'
					}
				]
			}, 
 
			{ 
				text:'Item', 
				viewClass:'AM.view.master.Item', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'items',
						action : 'index'
					}
				]
			}, 
 
			{ 
				text:'Roller Type', 
				viewClass:'AM.view.master.RollerType', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'roller_types',
						action : 'index'
					}
				]
			}, 

    	]
	},
	
	manufactringItemtemSetupFolder : {
		text 			: "Manufacturing Item", 
		viewClass : '',
		iconCls		: 'text-folder', 
		expanded	: true,
		children 	: [
        	{ 
				text:'Machine', 
				viewClass:'AM.view.master.Machine', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'machines',
						action : 'index'
					}
				]
			}, 
			
			{ 
				text:'Core Builder', 
				viewClass:'AM.view.master.CoreBuilder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'core_builders',
						action : 'index'
					}
				]
			},
		  
			{ 
				text:'Roller Builder', 
				viewClass:'AM.view.master.RollerBuilder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'sub_types',
						action : 'index'
					}
				]
			}, 
			
			{ 
				text:'Blanket', 
				viewClass:'AM.view.master.Blanket', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'blankets',
						action : 'index'
					}
				]
			}, 
 			
 			{ 
				text:'Blending Recipe', 
				viewClass:'AM.view.master.BlendingRecipe', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'blending_recipes',
						action : 'index'
					}
				]
			}, 
 
	 
 
 
    	]
	},
	
	financeSetupFolder : {
		text 			: "Finance Setup", 
		viewClass : '',
		iconCls		: 'text-folder', 
		expanded	: true,
		children 	: [
        	{ 
				text:'CashBank', 
				viewClass:'AM.view.master.CashBank', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'cash_banks',
						action : 'index'
					}
				]
			}, 
			
			{ 
				text:'CoA', 
				viewClass:'AM.view.master.Account', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'accounts',
						action : 'index'
					}
				]
			}, 
			
			{ 
				text:'Currency', 
				viewClass:'AM.view.master.Exchange', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'exchanges',
						action : 'index'
					}
				]
			}, 
			
			{ 
				text:'Exchange Rate', 
				viewClass:'AM.view.master.ExchangeRate', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'exchange_rates',
						action : 'index'
					}
				]
			}, 
		    
    	]
	},
	
	reportFolder : {
		text 			: "Employee Report", 
		viewClass : '',
		iconCls		: 'text-folder', 
    expanded	: true,
		children 	: [
        
			{ 
				text:'By Customer', 
				viewClass:'AM.view.master.report.employee.WorkCustomer', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'maintenances',
						action : 'report'
					}
				]
			}, 
    ]
	},
	   
	 
	onActiveProtectedContent: function( panel, options) {
		var me  = this; 
		var currentUser = Ext.decode( localStorage.getItem('currentUser'));
		var email = currentUser['email'];
		
		me.folderList = [
			this.setupFolder,
			this.customerSetupFolder,
			this.itemSetupFolder,
			this.manufactringItemtemSetupFolder,
			this.financeSetupFolder,
			// this.projectReportFolder
		];
		
		var processList = panel.down('masterProcessList');
		processList.setLoading(true);
	
		var treeStore = processList.getStore();
		treeStore.removeAll(); 
		
		treeStore.setRootNode( this.buildNavigation(currentUser) );
		processList.setLoading(false);
	},
});