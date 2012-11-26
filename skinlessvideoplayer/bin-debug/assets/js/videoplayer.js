function HtmlVideoPlayer(path) {
	
	var div = $("#videoplayer");
	var videoBrain = new VideoBrain(div, path);
	var controls = new Controls(div);
	
	controls.addEventListener('resume', function() {
		videoBrain.resumeHandler();
	}); 
	
	controls.addEventListener('pause', function() {
		videoBrain.pauseHandler();
	});

	controls.addEventListener('scrubberstart', function(data) {
	   videoBrain.onInitScrubHandler();
	}); 
	
	controls.addEventListener('scrubberchange', function(data) {
		videoBrain.onScrubHandler(data);
	}); 
	
	controls.addEventListener('scrubberend', function(data) {
	   videoBrain.onEndScrubHandler();
	});

	controls.addEventListener('volumechange', function(data) {
		videoBrain.volumeChangeHandler(data);
	}); 
	
	controls.addEventListener('fullscreen', function() {
		videoBrain.fullscreenHandler();
		//div[0].webkitRequestFullscreen();
        var myPlayer = document.getElementById('#videoplayer');
        myPlayer.webkitRequestFullScreen();
	});
	
	videoBrain.addEventListener('video_ready', function(data) {	
		controls.videoData(data);
	});
		
	videoBrain.addEventListener('update', function(data) {
		//console.log('time 		:: '+data.time)
		//console.log('progress 	:: '+data.progress)
		
		controls.updateProgressScrubber({x:data.progress});
		controls.updateLoadedScrubber({x:data.loaded});
		controls.setTime(data.time);
	});






/*

				
		controls.addEventListener('scrubberchange', function(data) {
			flashContainer.flashOnScrubHandler(data);
		}); 

		controls.addEventListener('scrubberstart', function(data) {
		   flashContainer.flashOnInitScrubHandler();
		}); 
		controls.addEventListener('scrubberend', function(data) {
		   flashContainer.flashOnEndScrubHandler();
		});
		
		controls.addEventListener('fullscreen', function() {
			flashContainer.flashFullScreenHandler();
		});

		controls.addEventListener('volumechange', function(data) {
			flashContainer.flashVolumeChangeHandler(data);
		}); 
		
		window.update = function(obj) {
			controls.updateLoadedScrubber({x:obj.loaded});
			controls.updateProgressScrubber({x:obj.progress});
			controls.setTime(obj.time);
		}		
		
		window.initVideoData = function(data) {
		 	flashContainer = document.getElementById("flash");
			controls.videoData(data);
		}
		
		window.videoOver = function() {
			console.log('videoOver')
			controls.resetControls();
		}


*/
}