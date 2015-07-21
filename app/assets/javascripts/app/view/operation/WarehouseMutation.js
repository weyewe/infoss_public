Ext.define('AM.view.operation.WarehouseMutation', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.warehousemutationProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'warehousemutationlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'warehousemutationdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});