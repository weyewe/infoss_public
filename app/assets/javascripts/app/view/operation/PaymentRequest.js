Ext.define('AM.view.operation.PaymentRequest', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.paymentrequestProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'paymentrequestlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'paymentrequestdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});