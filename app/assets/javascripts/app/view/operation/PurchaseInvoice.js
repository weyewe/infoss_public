Ext.define('AM.view.operation.PurchaseInvoice', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.purchaseinvoiceProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'purchaseinvoicelist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'purchaseinvoicedetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});