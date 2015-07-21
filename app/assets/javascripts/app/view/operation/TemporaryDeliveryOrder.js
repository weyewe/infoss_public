Ext.define('AM.view.operation.TemporaryDeliveryOrder', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.temporarydeliveryorderProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'temporarydeliveryorderlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'temporarydeliveryorderdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});