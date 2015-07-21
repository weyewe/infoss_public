Ext.define('AM.store.HomeAssignmentDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.HomeAssignmentDetail'],
  	model: 'AM.model.HomeAssignmentDetail',
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
