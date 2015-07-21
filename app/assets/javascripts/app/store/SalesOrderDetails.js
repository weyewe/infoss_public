Ext.define('AM.store.SalesOrderDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.SalesOrderDetail'],
  	model: 'AM.model.SalesOrderDetail',
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
