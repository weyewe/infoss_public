Ext.define('AM.view.operation.RecoveryWorkProcess', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.recoveryworkprocessProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'recoveryworkprocesslist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'recoveryworkprocessdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});