Ext.define('AM.view.operation.RollerWarehouseMutation', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.rollerwarehousemutationProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'rollerwarehousemutationlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'rollerwarehousemutationdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});