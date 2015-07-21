Ext.define('AM.store.VirtualOrders', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.VirtualOrder'],
  	model: 'AM.model.VirtualOrder',
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
