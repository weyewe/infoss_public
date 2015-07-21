Ext.define('AM.store.Closings', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.Closing'],
  	model: 'AM.model.Closing',
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
