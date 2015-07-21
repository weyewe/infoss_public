Ext.define('AM.store.StockAdjustmentDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.StockAdjustmentDetail'],
  	model: 'AM.model.StockAdjustmentDetail',
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
