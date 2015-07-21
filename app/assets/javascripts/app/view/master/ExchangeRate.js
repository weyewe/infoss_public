// Ext.define('AM.view.master.ExchangeRate', {
//     extend: 'AM.view.Worksheet',
//     alias: 'widget.exchangerateProcess',
	 
		
// 		items : [
// 			{
// 				xtype : 'exchangeratelist' ,
// 				flex : 1 //,
// 				// html : 'hahaha'
// 			} 
// 		]
// });

Ext.define('AM.view.master.ExchangeRate', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.exchangerateProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		items : [
		// just the list
			{
				xtype : 'masterexchangeList',
				flex : 1 
			},
			{
				xtype : 'exchangeratelist',
				flex : 3
			}, 
			 
		]
});