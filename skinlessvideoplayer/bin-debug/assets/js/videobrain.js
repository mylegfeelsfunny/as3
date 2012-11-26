function VideoBrain(parent, path) {
	this.parent		= parent;
	this.path		= path;
	
	this.addToPrototype(VideoBrain, Dispatcher);
	this.init();
}

VideoBrain.prototype = {
	
	video : 'undefined',
	path : 'undefined',
	updateInterval : 'undefined',
	actionState : 'undefined',
	loaded: 'undefined',
	
	init :function() {
		this.setUpVideoTags();
		
		var that = this;
		
		/*
		this.video.addEventListener('progress', function(e) {
			that.duration = that.video.duration;
			that.loaded = that.video.buffered.end(0) / that.video.duration;
			that.loaded = (that.loaded > .95) ? 1 : that.loaded;
			//that.dispatch('loaded_update', {loaded:that.loaded});
  			//console.log(this.buffered.end(0) +" :: "+that.duration);
		}, false);
		*/
		
        var vidReadyState = setInterval(function() {
			if (that.video.readyState > 0) {
				that.dispatch('video_ready', {duration:that.video.duration});
				that.startProgressUpdate();
				clearInterval(vidReadyState);
			}
        }, 30);
		this.video.volume = 0;
	},
	
	setUpVideoTags : function() {
		this.video = $('<video />').attr({
			'id'							: 'video',
			'width'							: this.parent.width()+'px',
			'height'						: this.parent.height()+'px',
			'preload'						: 'true'
		}).appendTo(this.parent);
		this.video = this.video[0];
	
		this.addSourceTag('.mp4');	
		this.addSourceTag('.ipad.mp4');	
		this.addSourceTag('.iphone.mp4');	
		this.addSourceTag('.webm', 'video/webm; codecs="vp8, vorbis"');	
		this.addSourceTag('.theora.ogv', 'video/ogg; codecs="theora, vorbis"');	
	},
	
	addSourceTag : function(format, type) {
		var attr = {};
		attr.src = this.path + format;
		if (type) attr.type = type;
		
		$('<source />').attr(attr).appendTo(this.video);
	},
	
	startProgressUpdate : function() {
		var that = this;
		updateInterval = setInterval(function() {
			var obj = {};
			//that.loaded 		= ;
			
			obj.progress		= that.video.currentTime / that.video.duration;
			obj.time 			= that.video.currentTime;
			obj.loaded 			= that.video.buffered.end(0) / that.video.duration;
			
			that.dispatch('update', obj);
		}, 30); 
	},
	
	
	//--------------------------------------------------------------------------
    //  CONTROL EVENT HANDLERS
    //--------------------------------------------------------------------------
	
	resumeHandler : function() {
		this.video.play();
	},
	
	pauseHandler : function() {
		this.video.pause();
	},
	
	onInitScrubHandler : function() {
		clearInterval(updateInterval);
		this.video.actionState =(this.video.paused) ? this.video.pause : this.video.play;
		this.video.pause();
	},
	
	onScrubHandler : function(data) {
		//console.log((data.ratio * this.duration));
		this.video.currentTime = (data.ratio * this.video.duration);
	},
	
	onEndScrubHandler : function() {
		//if (this.video.actionState == this.video.play) 
		this.startProgressUpdate();
		this.video.actionState();
	},
	
	volumeChangeHandler : function(data) {
		//console.log(data.volume)
		this.video.volume = data.volume;
	},
	
	fullscreenHandler : function() {
		$("#video")[0].webkitEnterFullscreen();
	},
	//--------------------------------------------------------------------------
    //  Little bit of mixin, adding pseudo event dispatching with return data
    //--------------------------------------------------------------------------
	addToPrototype : function(receiving, giving) {
		for (methodName in giving.prototype) {
			if (!receiving.prototype[methodName]) {
				receiving.prototype[methodName] = giving.prototype[methodName];
			}
		}
	}
	
}







//--------------------------------------------------------------------------
//  Dispatcher For events
//--------------------------------------------------------------------------
function Dispatcher() {

}

Dispatcher.prototype = {

	events : [], 
	
	addEventListener : function(event, callback) {
		this.events[event] = this.events[event] || [];
		if (this.events[event]) {
			this.events[event].push(callback);
		}
	},
	
	removeEventListener : function(event, callback) {
		if (this.events[event]) {
			var listeners = this.events[event], len = listeners.length;
			for (var i=0;i<len;i++) {
				if (listeners[i] === callback) {
					listenrs.splice(i, 1);
					//return true;
				}
			}
		}
		return false;
	},
	
	dispatch : function(event, data) {
		if (this.events[event]) {
			var listeners = this.events[event], len = listeners.length;
			while(len--) {
				listeners[len](data);
			}
		}
	}
}
