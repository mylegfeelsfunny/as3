package com.egraphicsNY.as3.display.video.videocontrols
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	
	public interface IVideoControls
	{
		
		function initAssets():void
		
		//<!-- button UI handler
		function playbuttonClick(e:Event):void
		
		function pausebuttonClick(e:Event):void
		
		function closebuttonClick(e:Event):void
		// button UI handler -->
		
		//<!-- scrubber UI hander
		function onScrubberMouseEvent($evt:MouseEvent):void
		
		function initScrubbing():void
		
		function stopScrubbing():void
		// scrubber UI hander -->
		
		//<!-- FLV steaming IO / Error handler
		function onIOErrorHandler(e:IOErrorEvent):void
		
		// FLV steaming IO / Error handler -->
		
	}
}