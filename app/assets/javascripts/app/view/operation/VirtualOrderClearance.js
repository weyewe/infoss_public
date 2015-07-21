Ext.define('AM.view.operation.VirtualOrderClearance', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.virtualorderclearanceProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'virtualorderclearancelist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'virtualorderclearancedetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});