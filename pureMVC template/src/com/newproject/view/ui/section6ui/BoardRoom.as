package com.office365.view.ui.section6ui
{
	import com.deepfocus.as3.display.section.Section;
	import com.deepfocus.as3.display.video.videoplayer.ChromelessVideoPlayer;
	import com.deepfocus.as3.display.video.videoplayer.events.VideoControllerEvent;
	import com.deepfocus.as3.templates.microsite.AbstractMain;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public final class BoardRoom extends Section
	{
		private var _videoPlayer:ChromelessVideoPlayer;
		private var _path:String;
		private var _logoplacer:MovieClip;
		private var _logo:MovieClip;
		
		public function BoardRoom($mc:MovieClip, $path:String)
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
			_videoPlayer = new ChromelessVideoPlayer(_path, 960, 540, _tvPositionUpdate)
			_videoPlayer.addEventListener(VideoControllerEvent.CONNECTION_MADE, videoReadyHandler, false, 0);
			_videoPlayer.addEventListener(VideoControllerEvent.VIDEO_OVER, videoOverHandler, false, 0);
			_mc.addChildAt(_videoPlayer, 0);
			
			_logoplacer = MovieClip(_mc.content.tv.block);
			super._init();
		}
		
		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
		public function play():void
		{
			trace(this, "play");
			//_mc.content.gotoAndPlay(2);
			_videoPlayer.resume();
		}
		
		public function setLogo($logo:MovieClip):void
		{
			_logo = $logo;
			_logoplacer.addChild(_logo);
			_logoplacer.removeChildAt(0);
			_logoplacer.y = (_mc.content.tv.bkg.height - _logoplacer.height) * .5;

		}

		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		override protected function _destroy():void {
			_mc.removeChild(_videoPlayer);
			_videoPlayer = null;
			_mc.removeChild(_mc.content);
			_mc.content = null;
			super._destroy();
		}
		
		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		private function _tvPositionUpdate($data:Object):void
		{
			var frame:int = Math.ceil($data.progress * _mc.content.totalFrames);
			_mc.content.gotoAndStop(frame);
		}

		private function videoReadyHandler($e:VideoControllerEvent):void
		{
			trace(this, "videoReadyHandler");

			_videoPlayer.volume(0);
		}
		
		private function videoOverHandler($e:VideoControllerEvent):void
		{
			_videoPlayer.removeEventListener(VideoControllerEvent.CONNECTION_MADE, videoReadyHandler);
			_videoPlayer.removeEventListener(VideoControllerEvent.VIDEO_OVER, videoOverHandler);

			dispatchEvent(new Event("finished"));
		}

		
	}
}