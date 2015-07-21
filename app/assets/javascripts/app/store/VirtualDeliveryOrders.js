Ext.define('AM.store.VirtualDeliveryOrders', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.VirtualDeliveryOrder'],
  	model: 'AM.model.VirtualDeliveryOrder',
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
