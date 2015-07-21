Ext.define('AM.store.StockAdjustments', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.StockAdjustment'],
  	model: 'AM.model.StockAdjustment',
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
