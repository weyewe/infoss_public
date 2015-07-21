Ext.define('AM.view.operation.SalesDownPaymentAllocation', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.salesdownpaymentallocationProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'salesdownpaymentallocationlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'salesdownpaymentallocationdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});