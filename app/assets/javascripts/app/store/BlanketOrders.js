Ext.define('AM.store.BlanketOrders', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BlanketOrder'],
  	model: 'AM.model.BlanketOrder',
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
