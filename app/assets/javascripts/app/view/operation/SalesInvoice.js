Ext.define('AM.view.operation.SalesInvoice', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.salesinvoiceProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'salesinvoicelist' ,
				flex : 3 //,
				// html : 'hahaha'
			},
			{
				xtype :'salesinvoicedetaillist',
				// html : "This is gonna be the price_rule",
				flex : 2
			} 
		],
 
});