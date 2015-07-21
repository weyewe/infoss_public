Ext.define('AM.view.operation.BankAdministration', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.bankadministrationProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'bankadministrationlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'bankadministrationdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});