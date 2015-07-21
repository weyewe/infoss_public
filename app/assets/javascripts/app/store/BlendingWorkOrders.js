Ext.define('AM.store.BlendingWorkOrders', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BlendingWorkOrder'],
  	model: 'AM.model.BlendingWorkOrder',
  	// autoLoad: {start: 0, limit: this.pageSize},
		autoLoad : false, 
  	autoSync: false,
	pageSize : 40, 
	
	
		
		
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 

	listeners: {

	} 
});
