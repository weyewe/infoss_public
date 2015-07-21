Ext.define('AM.store.Payables', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.Payable'],
  	model: 'AM.model.Payable',
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
