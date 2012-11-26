$(function() {

	var flashvars = {

	};
	var params = { 
		wmode: 'transparent',
		allowscriptaccess : "always"  	
	};
	var attributes = {};
	swfobject.embedSWF('assets/swf/loader.swf', "flash", "100%", "100%", "11", "assets/swf/expressInstall.swf", flashvars, params, attributes);

});