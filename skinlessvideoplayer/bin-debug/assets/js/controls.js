function Controls(parent, mode) {
	this.parentDiv = parent;
	this.modeCallback = mode;
	
	this.init();
}

Controls.HEIGHT = 50;
Controls.BLOCK_WIDTH = 50;
Controls.SCRUBBING = 'scrubberend';
Controls.VOLUME = 'volumeend';

Controls.prototype = {
	
	container : null,
	modeCallback : null,
	buttonContainer : null,
	outProgressBar : null,
	overwidth:'undefined',
	outwidth:'undefined',
	duration:'undefined',
	durationToString:'undefined',
	endActionState:'undefined',
	
	init : function() {
		this.drawUI();

		this.outwidth = this.parentDiv.width();
		this.overwidth = this.overprogress.width();
		this.container.css({
			'-webkit-transform'	: 'translate3d(0, -50px, 0)',
			'-moz-transform'	: 'translate(0, -50px)',
			'-o-transform'		: 'translate(0, -50px)',
			'-ms-transform'		: 'translate(0, -50px)',
			'-transform'		: 'translate(0, -50px)'
		});
		
		this.outProgressBar.css({
			'-webkit-transform'	: 'scale3d(1, 0, 0)',
			'-moz-transform'	: 'scale(1, 0)',
			'-o-transform'		: 'scale(1, 0)',
			'-ms-transform'		: 'scale(1, 0)',
			'-transform'		: 'scale(1, 0)'
		});
		
		this.fixSelection(this.parentDiv);
		this.fixSelection(this.selectionBlocker);
		this.pause.hide();
		this.selectionBlocker.hide();
		
		this.addToPrototype(Controls, Dispatcher);
		this.addListeners();
	},
	
	resetControls : function() {
		this.pause.hide();
		this.play.show();
		this.updateProgressScrubberWidth({x:0});
	},
	
	addListeners : function() {
		var that = this;		
		
		this.bindShowControls();
		this.play.click(function(e) { that.playClick(e) });
		this.pause.click(function(e) { that.pauseClick(e) });
		this.fullscreen.click(function(e) { that.fullScreenClick(e) });
		
		// scrubber events
		this.overloaded.bind('click', function(e) { that.onProgressClick(e) });
		this.overprogress.bind('click', function(e) { that.onProgressClick(e) });
		this.overloaded.mousedown(function(e) { that.onProgressMouseDown(e) });
		this.overprogress.mousedown(function(e) { that.onProgressMouseDown(e) });
		this.overloaded.mouseup(function(e) { that.bindShowControls(e) });
		this.overprogress.mouseup(function(e) { that.bindShowControls(e) });
		
		// volume events
		this.volume.mousedown(function(e) { that.onVolumeMouseDown(e) });
		this.volume.mouseup(function(e) { that.bindShowControls(e) });
		this.volume.click(function(e) { that.onVolumeMouseClick(e) });
		
		this.selectionBlocker.bind('selectstart', function(e) { e.preventDefault(); });
		this.selectionBlocker.mouseup(function(e) { that.bindShowControls(e) });
	},
	
	drawUI : function() {
		this.container = $("<div />").attr({'id':'container'}).css({
			'width'							: this.parentDiv.width(),
			'height'						: Controls.HEIGHT+'px',
			'bottom'						: -Controls.HEIGHT+'px'
		}).appendTo(this.parentDiv);
	
		this.buttonContainer = $("<div />").attr({'id':'buttonContainer'}).css({
			'position'						: 'absolute',
			'width'							: this.parentDiv.width(),
			'height'						: Controls.HEIGHT+'px'
		}).appendTo(this.container);
	
		this.play = this.returnBtn().attr({'id':'play'}).prepend($('<div />').attr({'id':'playIcon'})).appendTo(this.buttonContainer);
		this.pause = this.returnBtn().attr({'id':'pause'}).prepend($('<div />').attr({'id':'pauseIcon'})).appendTo(this.buttonContainer);
		this.makeVolumeControl();
		
		this.fullscreen = this.returnBtn().attr({'id':'fullscreen'}).css({
	        'left'							: (this.volume.position().left - Controls.BLOCK_WIDTH) + 'px'
		}).prepend( $('<div />').attr({'id':'fullscreenIcon'})).appendTo(this.buttonContainer);
		
		this.time = this.returnBtn().attr({'id':'time'}).text('00:00/00:00').appendTo(this.buttonContainer);
		this.time.css({
	        'left'							: this.fullscreen.position().left - this.time.width() + 'px'
		});
		
		var scrubWidth 	= (this.time.position().left - (this.pause.width()+ 1)) + 'px';
		var scrubLeft	= (this.pause.width()+ 1)+'px';
		
		this.overtotal = this.returnBtn().attr({'id':'overtotal'}).css({
	        'width'							: scrubWidth,
			'left'							: scrubLeft
		}).appendTo(this.buttonContainer);
		
		this.overloaded = this.returnBtn().attr({'id':'overloaded'}).css({
			'width'							: 0,
			'left'							: scrubLeft,
			'border-right'	 				: 'none'
		}).appendTo(this.buttonContainer);

		this.overprogress = this.returnBtn().attr({'id':'overprogress'}).css({
	        'width'							: 0,
			'left'							: scrubLeft,
			'border-right'	 				: 'none' 
		}).appendTo(this.buttonContainer);
		
		this.outProgressBar = $('<div />').attr({'id':'outProgressBar'}).appendTo(this.container);
		this.outtotal = $('<div />').attr({'id':'outtotal'}).appendTo(this.outProgressBar);		
		this.outprogress = $('<div />').attr({'id':'outprogress'}).appendTo(this.outProgressBar);
		this.selectionBlocker = $("<div />").attr({'id':'selectionBlocker'}).appendTo('body');
	},
	
	returnBtn : function() {
		return $('<div />').addClass('buttonBlock');
	},
	
	makeVolumeControl :function() {
		this.volume = this.returnBtn().css({
	        'left'							: (this.container.width() - Controls.BLOCK_WIDTH) + 'px',
    		'border-right'					:'none'		
    	}).attr({'id':'volume'}).appendTo(this.buttonContainer);
		
		this.volumeBackgroundImage = $('<div />').attr({'id':'volumeBackgroundImage'})
		.addClass('volumeIconContainer').appendTo(this.volume);

		this.volumeForegroundImage = $('<div />').attr({'id':'volumeForegroundImage'})
		.addClass('volumeIconContainer').appendTo(this.volume);

		var i = 0;
		for (i; i<6;i++){
			this.volumeBackgroundImage.prepend($('<div />').addClass('bar').css({
		        'left'						: (i * 4) + 'px',
			}));
		}
		
		for (i=0; i<6;i++){
			this.volumeForegroundImage.prepend($('<div />').addClass('bar').css({
				'position'					: 'absolute',
		        'left'						: (i * 4) + 'px',
		        'height'					: ((i+1) * (21/6))+'px',
		        'background-color'			: 'rgba(255, 255, 255, .6)'
			}));
		}
	},
		
	//--------------------------------------------------------------------------
    //  Public Methods
    //--------------------------------------------------------------------------
	setTime : function(value) {
		var current = this.parseTime(value);
		this.time.text(current + '/' + this.durationToString);
	},
	
	parseTime : function(value) {
		var clockSeconds = parseInt(value % 60).toString();
		var clockMinutes = parseInt(value / 60).toString();

		if (isNaN(clockMinutes)) clockMinutes = '00';
		if (isNaN(clockSeconds)) clockSeconds = '00';
		if(clockSeconds.length < 2) { 
			clockSeconds = "0" + clockSeconds; 
		}
		if(clockMinutes.length < 2) { 
			clockMinutes = "0" + clockMinutes; 
		}
		return clockMinutes + ":" + clockSeconds;
	},
	
	videoData : function(data) {
		this.duration = data.duration;
		this.durationToString = this.parseTime(parseInt(data.duration));
	},
	
	//--------------------------------------------------------------------------
    //  Dispatch Up Methods
    //--------------------------------------------------------------------------	
	
	//--------------------------------------------------------------------------
    //  Event Handlers
    //--------------------------------------------------------------------------
	mouseOver : function(e) {
		this.container.css({
			'-webkit-transform'				: 'translate3d(0, -50px, 0)',
			'-moz-transform'				: 'translate(0, -50px)',
			'-o-transform'					: 'translate(0, -50px)',
			'-ms-transform'					: 'translate(0, -50px)',
			'-transform'					: 'translate(0, -50px)',
		});	
		this.outProgressBar.css({
			'-webkit-transform'				: 'scale3d(1, 0, 0)',
			'-moz-transform'				: 'scale(1, 0)',
			'-o-transform'					: 'scale(1, 0)',
			'-ms-transform'					: 'scale(1, 0)',
			'-transform'					: 'scale(1, 0)',
		});	
	},
	
	mouseOut : function(e) {
		this.container.css({
			'-webkit-transform'				: 'translate3d(0, 0, 0)',
			'-moz-transform'				: 'translate(0, 0)',
			'-o-transform'					: 'translate(0, 0)',
			'-ms-transform'					: 'translate(0, 0)',
			'-transform'					: 'translate(0, 0)'
		});
		this.outProgressBar.css({
			'-webkit-transform'				: 'scale3d(1, 1, 0)',
			'-moz-transform'				: 'scale(1, 1)',
			'-o-transform'					: 'scale(1, 1)',
			'-ms-transform'					: 'scale(1, 1)',
			'-transform'					: 'scale(1, 1)'
		});	
	},
	
	playClick : function(e) {
		this.play.hide();
		this.pause.show();
		//this.modeCallback('play');
		this.dispatch('resume');
	},
	
	pauseClick : function(e) {
		this.play.show();
		this.pause.hide();
		//this.modeCallback('pause');
		this.dispatch('pause');

	},
	
	fullScreenClick : function(e) {
		this.dispatch('fullscreen');
	},
	
	
	//--------------------------------------------------------------------------
    //  CHANGE SCRUBBER VALUES
    //--------------------------------------------------------------------------
	
	// Loaded content updater, called from outside
	updateLoadedScrubber : function(vector) {
		var value = vector.x;
		var destwidth = value * this.overtotal.width();
		this.overloaded.width(destwidth);
	},
	
	onProgressMouseDown : function(e) {
		this.endActionState = Controls.SCRUBBING;
		//this.dispatch('scrubberstart');
		//this.overloaded.unbind('click');
		//this.overprogress.unbind('click');
		this.elementScrubRatioValues(e, this.userProgressScrubber, this.overprogress, this.overtotal);
		this.dispatch('scrubberstart');
	},
	
	onProgressClick : function(e) {
		this.endActionState = Controls.SCRUBBING;
		var width = this.getInnerElementMouseCoordinates(e, this.overprogress).x;
		var ratio = {}
		ratio.x = width / this.overtotal.width();
		this.userProgressScrubber(ratio);
	},
	
	// updates progress scrubber, cannot go past loaded scrubber
	userProgressScrubber : function(vector) {
		this.updateProgressScrubberWidth(vector);

		// send up value
		this.dispatch('scrubberchange', {ratio:vector.x});
	},
	
	// updates progress scrubber, cannot go past loaded scrubber
	updateProgressScrubber : function(vector) {
		this.updateProgressScrubberWidth(vector);
	},
	
	updateProgressScrubberWidth : function(vector) {
		var value = vector.x;
		this.setTime(value * this.duration);
		var destwidth = value * this.overtotal.width();
		if (destwidth > this.overloaded.width()) return;

		this.overprogress.width(destwidth);

		destwidth = value * this.outtotal.width();
		this.outprogress.width(destwidth);
	},
	
	
	//--------------------------------------------------------------------------
    //  END CHANGE SCRUBBER VALUES
    //--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
    //  CHANGE VOLUME
    //--------------------------------------------------------------------------
	onVolumeMouseDown : function(e) {
		this.endActionState = Controls.VOLUME;

		this.elementScrubRatioValues(e, this.onChangeVolume, this.volumeForegroundImage);
	},
	
	onVolumeMouseClick : function(e) {
		this.endActionState = Controls.VOLUME;

		var vector = {};
		vector.x = this.ratioByAxis('x', e, this.volumeForegroundImage);
		vector.y = this.ratioByAxis('y', e, this.volumeForegroundImage);
		this.onChangeVolume(vector);
	},
	
	onChangeVolume : function(vector) {
		var value = vector.x;
		this.volumeForegroundImage.empty();
		var loop =(value < .05) ? 0 : Math.ceil(value * 6);
		for (var i=0;i<loop;i++) {
			this.volumeForegroundImage.prepend($('<div />').addClass('bar').css({
		        'left'						: (i * 4) + 'px',
		        'height'					: ((i+1) * (21/6))+'px',
		        'background-color'			: 'rgba(255, 255, 255, .6)'
			}));
		}	
		
		// send up value
		this.dispatch('volumechange', {volume:value});
	},
	//--------------------------------------------------------------------------
    //  END CHANGE VOLUME
    //--------------------------------------------------------------------------
	
	
	//--------------------------------------------------------------------------
    //  DRAGGING UTILITY CODE
    //--------------------------------------------------------------------------

    //	returns ratio of mouse coordinates in one element vs the dimensions of another element
    //	sends back data via a mousedown dragging event, blocks cursor selection
    //	removes eventlistener when done
	elementScrubRatioValues : function(e, callback, theElement, elementToMeasureAgainst) {
		var againstElement =(elementToMeasureAgainst) ? elementToMeasureAgainst : theElement;
		
		this.parentDiv.unbind('mouseout');
		this.parentDiv.unbind('mouseover');
		var that = this;
		$(document).bind('mousemove touchmove', function(e) {
			that.selectionBlocker.show();
			var vector = {};
			vector.x = that.ratioByAxis('x', e, theElement, againstElement);
			vector.y = that.ratioByAxis('y', e, theElement, againstElement);
			callback.call(that, vector)
		}).bind("mouseup touchend", function(e){
			$(document).unbind('mousemove touchmove');
			$(document).unbind('mouseup touchend');			
		});
	},
	
    //  returns ratio of mouse coordinates axis == 'x' or 'y' 
    //	in one element vs the dimensions of another element
	//--------------------------------------------------------------------------
	ratioByAxis : function(axis, e, theElement, elementToMeasureAgainst) {
		var againstElement =(elementToMeasureAgainst) ? elementToMeasureAgainst : theElement;
		var dist =(axis=='x') ? 'width' : 'height';
		var ratio = this.getInnerElementMouseCoordinates(e, theElement)[axis];
		if (ratio < 0) ratio = 0;
		else if (ratio > againstElement[dist]()) ratio = againstElement[dist]();
		return ratio / againstElement[dist]();
	},
	
    //  returns mouse coordinates relative to inside of specific element
	getInnerElementMouseCoordinates :function(e, element) {
		var coordinates = {};
		coordinates.x = e.pageX-(element.offset().left);
		coordinates.y = e.pageY-(element.offset().top);
		return coordinates;
	},
	
    //  blocks cursor selection, via absolute positioned div over all content
	bindShowControls : function() {
		this.selectionBlocker.hide();
		var that = this;
		this.parentDiv.bind('mouseover', function(e) { that.mouseOver(e) });
		this.parentDiv.bind('mouseout', function(e) { that.mouseOut(e) });

		this.dispatch(this.endActionState);

	},
		
    //  removes selection blocking div
	progressActionsDone : function() {
		this.parentDiv.unbind('mouseout');
		this.parentDiv.unbind('mouseover');
	},
	
    //  makes user selection null for element specified
	fixSelection : function (element) {
		element.addClass('fixSelection');
	},
	
	//--------------------------------------------------------------------------
    //  END DRAGGING UTILITY CODE
    //--------------------------------------------------------------------------
	
	
	
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









































