Ext.define('AM.store.ExchangeRates', {
	extend: 'Ext.data.Store',
	require : ['AM.model.ExchangeRate'],
	model: 'AM.model.ExchangeRate',
	// autoLoad: {start: 0, limit: this.pageSize},
	autoLoad : false, 
	autoSync: false,
	pageSize : 10, 
	
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 
	listeners: {

	} 
});
