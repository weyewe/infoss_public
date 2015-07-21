Ext.define('AM.view.operation.PurchaseOrder', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.purchaseorderProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'purchaseorderlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'purchaseorderdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});