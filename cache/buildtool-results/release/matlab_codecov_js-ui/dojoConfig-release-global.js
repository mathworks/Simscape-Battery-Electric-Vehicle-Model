var dojoConfig = {
	tlmSiblingOfDojo : false,
	isDebug : false,
	async : true,
	has : {
		"production" : 1
	},
	/*temporary fix made to as per geck (g1818221) and part of moving mw-menu, mw-mixins-tests and mw-mixins into the mw-form project
	  will be removed once all dependent projects use version 1.1.0 for mw-form (g1841145)*/
	map : {
		"*" : {
			"mw-menu" : "mw-form",
			"mw-mixins" : "mw-form/mixins",
			"mw-mixins-tests" : "mw-form/mixins-tests"
		}
	}
};
