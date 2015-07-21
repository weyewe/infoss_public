Ext.define('AM.store.ClosingDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.ClosingDetail'],
  	model: 'AM.model.ClosingDetail',
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
