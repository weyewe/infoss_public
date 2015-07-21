Ext.define('AM.view.operation.PurchaseDownPaymentAllocation', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.purchasedownpaymentallocationProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'purchasedownpaymentallocationlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'purchasedownpaymentallocationdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});