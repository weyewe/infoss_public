Ext.define('AM.store.Warehouses', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Warehouse'],
	model: 'AM.model.Warehouse',
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
