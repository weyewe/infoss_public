Ext.define('AM.store.BlanketResults', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BlanketResult'],
  	model: 'AM.model.BlanketResult',
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
