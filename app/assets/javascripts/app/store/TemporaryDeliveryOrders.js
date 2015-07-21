Ext.define('AM.store.TemporaryDeliveryOrders', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.TemporaryDeliveryOrder'],
  	model: 'AM.model.TemporaryDeliveryOrder',
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
