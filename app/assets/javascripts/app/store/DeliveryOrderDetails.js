Ext.define('AM.store.DeliveryOrderDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.DeliveryOrderDetail'],
  	model: 'AM.model.DeliveryOrderDetail',
  	// autoLoad: {start: 0, limit: this.pageSize},
		autoLoad : false, 
  	autoSync: false,
	pageSize : 20, 
	
	
		
		
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 

	listeners: {

	} 
});
