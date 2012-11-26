package com.office365.view.ui.section6ui
{
	import com.deepfocus.as3.display.section.Section;
	import com.deepfocus.as3.display.video.videoplayer.ChromelessVideoPlayer;
	import com.deepfocus.as3.display.video.videoplayer.events.VideoControllerEvent;
	import com.deepfocus.as3.templates.microsite.AbstractMain;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public final class TimeSquare extends Section
	{
		private var _videoPlayer:ChromelessVideoPlayer;
		private var _path:String;
		private var _logo:MovieClip;
		private var _image:MovieClip;
		private var _logoplacer:MovieClip;
		
		private var _dampen:Number = 0.95;
		private var _vx:Number = .1;
		private var _vy:Number = .1;
		private var MAXYDIFF:Number = 40;

		private var _angleX:Number = 0;
		private var _angleY:Number = 0;
		private var _radiusX:Number = 8;
		private var _radiusY:Number = 7;
		private var _angleChangeX:Number = 4;
		private var _angleChangeY:Number = 5;
		private var _centerX:Number;
		private var _centerY:Number;

		
		public function TimeSquare($mc:MovieClip, $path:String)
		{
			_path = $path;
			super($mc);
		}		
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		override protected function _init():void {
			//_mc.x = _mc.width * .5;
			//_mc.y = _mc.height * .5;
			_image = _mc.image;

			var videoSizer:MovieClip = _mc.image.videocontainer.videosizer;
			_mc.image.videocontainer.removeChild(videoSizer);
			_videoPlayer = new ChromelessVideoPlayer(_path, videoSizer.width, videoSizer.height)
			_videoPlayer.addEventListener(VideoControllerEvent.CONNECTION_MADE, videoReadyHandler, false, 0);
			_videoPlayer.addEventListener(VideoControllerEvent.VIDEO_OVER, videoOverHandler, false, 0);
			_mc.image.videocontainer.addChildAt(_videoPlayer, 0);
			
			
			_logoplacer = _mc.image.videocontainer.logoplacer;
			super._init();
		}
		
		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
		public function play():void
		{
			_videoPlayer.resume();
			_mc.stage.addEventListener(Event.ENTER_FRAME, onMoveScreenHandler);
		}
		
		public function setLogo($logo:MovieClip):void
		{
			_logo = $logo;
			_logoplacer.addChild(_logo);
			_logoplacer.removeChildAt(0);
		}
		
		override public function resize(obj:Object):void {
			_mc.masker.width = obj.width;
			_mc.masker.height = obj.height;
				
			_centerX = obj.width * .5;
			_centerY = obj.height * .5;
			_image.width = obj.width + (obj.width * .3);
			_image.height = obj.height + (obj.height * .3);
		}
		
		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		override protected function _destroy():void {
			_mc.image.videocontainer.removeChild(_videoPlayer);
			_videoPlayer = null;
			_mc.image.removeChild(_mc.image.videocontainer);
			_mc.image.videocontainer = null;
			super._destroy();
		}
		
		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		private function videoReadyHandler($e:VideoControllerEvent):void
		{
			_videoPlayer.volume(0);
			//_videoPlayer.resume();
		}
		
		private function videoOverHandler($e:VideoControllerEvent):void
		{
			_videoPlayer.removeEventListener(VideoControllerEvent.CONNECTION_MADE, videoReadyHandler);
			_videoPlayer.removeEventListener(VideoControllerEvent.VIDEO_OVER, videoOverHandler);
			_mc.stage.removeEventListener(Event.ENTER_FRAME, onMoveScreenHandler);
			
			dispatchEvent(new Event("finished"));
		}
		
/*		private function onMoveScreenHandler(e:Event):void{
			//apply randomness to velocity
			
			_vx += Math.random() * 0.2 - 0.1;
			_vy += Math.random() * 0.2 - 0.1;
			
			_mc.x += _vx;
			_mc.y += _vy;
			_vx *= _dampen;
			_vy *= _dampen;
			//trace(this, _mc.y );
			//var diff:Number = _centerY - _mc.y;
			if (_mc.y > MAXYDIFF || _mc.y < -MAXYDIFF) {
				_vy *= -1;
			} 
		}
*/		
		private function onMoveScreenHandler(e:Event):void{
			var rX:Number = degToRad(_angleX);
			var rY:Number = degToRad(_angleY);
			_image.x = Math.cos(rX) * _radiusX + _centerX;
			_image.y = Math.sin(rY) * _radiusY + _centerY;
			_angleX += _angleChangeX;
			_angleY += _angleChangeY;
			_angleX %= 360;
			_angleY %= 360;
		}
		
		private function degToRad($deg:Number):Number
		{
			return $deg * (Math.PI/180);
		}
	}
}