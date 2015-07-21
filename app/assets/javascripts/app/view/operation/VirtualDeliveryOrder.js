Ext.define('AM.view.operation.VirtualDeliveryOrder', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.virtualdeliveryorderProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'virtualdeliveryorderlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'virtualdeliveryorderdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});