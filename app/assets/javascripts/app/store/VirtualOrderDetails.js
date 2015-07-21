Ext.define('AM.store.VirtualOrderDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.VirtualOrderDetail'],
  	model: 'AM.model.VirtualOrderDetail',
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
