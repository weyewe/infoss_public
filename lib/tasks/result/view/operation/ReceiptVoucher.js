Ext.define('AM.view.operation.ReceiptVoucher', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.receiptvoucherProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'templatelist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'receiptvoucherdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});