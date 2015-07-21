Ext.define('AM.view.operation.RecoveryOrder', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.recoveryorderProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'recoveryorderlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'recoveryorderdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});