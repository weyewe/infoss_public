Ext.define('AM.view.operation.BlendingWorkOrder', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.blendingworkorderProcess',
	 
		
		items : [
			{
				xtype : 'blendingworkorderlist' ,
				flex : 1 
			} 
		]
});