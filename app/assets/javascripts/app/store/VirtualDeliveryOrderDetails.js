Ext.define('AM.store.VirtualDeliveryOrderDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.VirtualDeliveryOrderDetail'],
  	model: 'AM.model.VirtualDeliveryOrderDetail',
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
