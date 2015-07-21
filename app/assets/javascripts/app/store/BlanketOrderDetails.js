Ext.define('AM.store.BlanketOrderDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BlanketOrderDetail'],
  	model: 'AM.model.BlanketOrderDetail',
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
