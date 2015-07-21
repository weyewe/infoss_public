Ext.define('AM.view.operation.RecoveryResult', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.recoveryresultProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'recoveryresultlist' ,
				flex : 2 //,
				// html : 'hahaha'
			},
			// {
			// 	xtype :'recoveryresultdetaillist',
			// 	// html : "This is gonna be the price_rule",
			// 	flex : 1
			// },
			{
				xtype : 'container',
				flex: 1 ,
				layout : {
					type : 'vbox',
					align : 'stretch'
				},
				items : [
					{
						xtype : 'recoveryresultdetaillist',
						flex : 1
					},

					{
						xtype : 'recoveryresultcompounddetaillist',
						flex : 2
					},
				]
				
			},
		],
 
});