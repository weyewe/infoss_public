Ext.define("AM.controller.Operation", {
	extend : "AM.controller.BaseTreeBuilder",
	views : [
		"operation.OperationProcessList",
		'OperationProcessPanel',
		'Viewport'
	],

	 
	
	refs: [
		{
			ref: 'operationProcessPanel',
			selector: 'operationProcessPanel'
		} ,
		{
			ref: 'operationProcessList',
			selector: 'operationProcessList'
		}  
	],
	

	 
	init : function( application ) {
		var me = this; 
		 
		// console.log("starting the init in Operation.js");
		me.control({
			"operationProcessPanel" : {
				activate : this.onActiveProtectedContent,
				deactivate : this.onDeactivated
			} 
			
		});
		
	},
	
	onDeactivated: function(){
		// console.log("Operation process panel is deactivated");
		var worksheetPanel = Ext.ComponentQuery.query("operationProcessPanel #operationWorksheetPanel")[0];
		worksheetPanel.setTitle(false);
		// worksheetPanel.setHeader(false);
		worksheetPanel.removeAll();		 
		var defaultWorksheet = Ext.create( "AM.view.operation.Default");
		worksheetPanel.add(defaultWorksheet); 
	},
	
	 
  salesFolder : {
		text 			: "Penjualan", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'Sales Order', 
				viewClass:'AM.view.operation.SalesOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'sales_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Delivery Order', 
				viewClass:'AM.view.operation.DeliveryOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'delivery_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Temporary Delivery Order', 
				viewClass:'AM.view.operation.TemporaryDeliveryOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'temporary_delivery_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Virtual Order', 
				viewClass:'AM.view.operation.VirtualOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'virtual_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Delivery Virtual Order', 
				viewClass:'AM.view.operation.VirtualDeliveryOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'virtual_delivery_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Virtual Order Clearance', 
				viewClass:'AM.view.operation.VirtualOrderClearance', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'virtual_order_clearances',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Sales Invoice', 
				viewClass:'AM.view.operation.SalesInvoice', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'sales_invoices',
						action : 'index'
					}
				]
			}, 
 
			 
		]
	},
	
	purchaseFolder : {
		text 			: "Pembelian", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'PurchaseOrder', 
				viewClass:'AM.view.operation.PurchaseOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'purchase_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Penerimaan', 
				viewClass:'AM.view.operation.PurchaseReceival', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'purchase_receivals',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Purchase Invoice', 
				viewClass:'AM.view.operation.PurchaseInvoice', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'purchase_invoices',
						action : 'index'
					}
				]
			}, 
 
			 
		]
	},
	
	logisticFolder : {
		text 			: "Logistic", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'Penyesuaian Stock', 
				viewClass:'AM.view.operation.StockAdjustment', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'stock_adjustments',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Pindah Gudang', 
				viewClass:'AM.view.operation.WarehouseMutation', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'warehouse_mutations',
						action : 'index'
					}
				]
			}, 
 
 
			 
		]
	},
	
	batchFolder : {
		text 			: "Batch", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'Pendaftaran Batch', 
				viewClass:'AM.view.operation.BatchInstance', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'batch_instances',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Pengalokasian Batch', 
				viewClass:'AM.view.operation.BatchSource', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'batch_sources',
						action : 'index'
					}
				]
			}, 
 
 
			 
		]
	},
 
  
  financeFolder : {
		text 			: "Finance", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'PaymentRequest', 
				viewClass:'AM.view.operation.PaymentRequest', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'payment_requests',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'PaymentVoucher', 
				viewClass:'AM.view.operation.PaymentVoucher', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'payment_vouchers',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'ReceiptVoucher', 
				viewClass:'AM.view.operation.ReceiptVoucher', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'receipt_vouchers',
						action : 'index'
					}
				]
			}, 
 			{ 
				text:'SalesDownPayment', 
				viewClass:'AM.view.operation.SalesDownPayment', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'sales_down_payments',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'SalesDownPaymentAllocatiom', 
				viewClass:'AM.view.operation.SalesDownPaymentAllocation', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'sales_down_payment_allocations',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'PurchaseDownPayment', 
				viewClass:'AM.view.operation.PurchaseDownPayment', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'purchase_down_payments',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'PurchaseDownPaymentAllocatiom', 
				viewClass:'AM.view.operation.PurchaseDownPaymentAllocation', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'purchase_down_payment_allocations',
						action : 'index'
					}
				]
			}, 
			 
		]
	},
	
	manufacturingFolder : {
		text 			: "Manufacturing", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'Blending Work Order', 
				viewClass:'AM.view.operation.BlendingWorkOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'blending_work_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Blanket Work Order', 
				viewClass:'AM.view.operation.BlanketOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'blanket_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Blanket Work Process', 
				viewClass:'AM.view.operation.BlanketResult', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'blanket_work_processs',
						action : 'index'
					}
				]
			},
			{ 
				text:'Blanket Warehouse Mutation', 
				viewClass:'AM.view.operation.BlanketWarehouseMutation', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'blanket_warehouse_mutations',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Roller Identification Form (RIF)', 
				viewClass:'AM.view.operation.RollerIdentificationForm', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'roller_identification_forms',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Roller Collection Note (RCN)', 
				viewClass:'AM.view.operation.RecoveryOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'recovery_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Customer Accessories',
				viewClass:'AM.view.operation.RollerAcc', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'roller_accs',
						action : 'index_1'
					}
				]
			}, 
			{ 
				text:'Recovery Work Chart (RWC)', 
				viewClass:'AM.view.operation.RecoveryResult', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'recovery_results',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Recovery Warehouse Mutation', 
				viewClass:'AM.view.operation.RollerWarehouseMutation', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'roller_warehouse_mutations',
						action : 'index'
					}
				]
			}, 
		]
	},
	
	
	cashbankFolder : {
		text 			: "Cash dan Bank", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'Adjustment', 
				viewClass:'AM.view.operation.CashBankAdjustment', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'cash_bank_adjustments',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Mutation', 
				viewClass:'AM.view.operation.CashBankMutation', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'cash_bank_mutations',
						action : 'index'
					}
				]
			}, 
		]
	},
	
	accountingFolder : {
		text 			: "Accounting", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'Memorial', 
				viewClass:'AM.view.operation.Memorial', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'memorials',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'BankAdministration', 
				viewClass:'AM.view.operation.BankAdministration', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'bank_administrations',
						action : 'index'
					}
				]
			},
			{ 
				text:'Closing', 
				viewClass:'AM.view.operation.Closing', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'closings',
						action : 'index'
					}
				]
			}, 
		]
	},
 
	recoveryFolder : {
		text 			: "Roller", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'Recovery Order', 
				viewClass:'AM.view.operation.RecoveryOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'recovery_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Clearance', 
				viewClass:'AM.view.operation.RecoveryOrderClearance', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'recovery_order_clearances',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Pindah Gudang', 
				viewClass:'AM.view.operation.RecoveryWarehouseMutation', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'recovery_warehouse_mutations',
						action : 'index'
					}
				]
			}, 
		]
	},
	
	blanketFolder : {
		text 			: "Blanket Convertion", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'Blanket Order', 
				viewClass:'AM.view.operation.BlanketOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'blanket_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Clearance', 
				viewClass:'AM.view.operation.BlanketOrderClearance', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'blankety_order_clearances',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Pindah Gudang', 
				viewClass:'AM.view.operation.BlanketWarehouseMutation', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'blanket_warehouse_mutations',
						action : 'index'
					}
				]
			}, 
		]
	},
	
	blendingFolder : {
		text 			: "Blending", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'Blending Order', 
				viewClass:'AM.view.operation.BlendingOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'blending_orders',
						action : 'index'
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
			this.logisticFolder,
			this.batchFolder, 
			this.manufacturingFolder,
			
 			// this.recoveryFolder,
 			// this.blanketFolder,
 			// this.blendingFolder,
			this.salesFolder,
			this.purchaseFolder,
 			this.financeFolder,
 			this.accountingFolder,
 			this.cashbankFolder,

 			
		];
		
		var processList = panel.down('operationProcessList');
		processList.setLoading(true);
	
		var treeStore = processList.getStore();
		treeStore.removeAll(); 
		
		treeStore.setRootNode( this.buildNavigation(currentUser) );
		processList.setLoading(false);
	},
});