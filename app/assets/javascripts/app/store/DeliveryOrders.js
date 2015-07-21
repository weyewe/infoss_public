Ext.define('AM.store.DeliveryOrders', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.DeliveryOrder'],
  	model: 'AM.model.DeliveryOrder',
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
