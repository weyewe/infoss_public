Ext.define('AM.view.operation.DeliveryOrder', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.deliveryorderProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'deliveryorderlist' ,
				flex : 3 //,
				// html : 'hahaha'
			},
			{
				xtype :'deliveryorderdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 2
			} 
		],
 
});