Ext.define('AM.view.operation.BlanketWarehouseMutation', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.blanketwarehousemutationProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'blanketwarehousemutationlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'blanketwarehousemutationdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});