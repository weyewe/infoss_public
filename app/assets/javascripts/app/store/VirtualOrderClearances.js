Ext.define('AM.store.VirtualOrderClearances', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.VirtualOrderClearance'],
  	model: 'AM.model.VirtualOrderClearance',
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
