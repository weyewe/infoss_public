Ext.define('AM.store.VirtualOrderClearanceDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.VirtualOrderClearanceDetail'],
  	model: 'AM.model.VirtualOrderClearanceDetail',
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
