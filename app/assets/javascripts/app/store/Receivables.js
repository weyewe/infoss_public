Ext.define('AM.store.Receivables', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.Receivable'],
  	model: 'AM.model.Receivable',
  	// autoLoad: {start: 0, limit: this.pageSize},
		autoLoad : false, 
  	autoSync: false,
	pageSize : 40, 
	
	
		
		
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 

	listeners: {

	} 
});
