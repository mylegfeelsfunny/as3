package com.office365.view.ui.experience.scenes
{
	import com.deepfocus.as3.display.video.videoplayer.ChromelessVideoPlayer;
	import com.deepfocus.as3.display.video.videoplayer.events.VideoControllerEvent;
	import com.deepfocus.as3.templates.microsite.AbstractMain;
	import com.office365.model.DataCacheProxy;
	import com.office365.view.ui.experience.event.SceneEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.setInterval;

	public final class Scene7 extends FlashScene
	{
		private var _userImageMC:MovieClip;
		private var _bitmap:Bitmap;
		private var _videoPlayer:ChromelessVideoPlayer;
		private var _loader:Loader;

		public function Scene7($linkedIn:Object, $classInfo:Object)
		{
			super($linkedIn, $classInfo);
		}
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
		override public function prepareBody():void
		{
			_userImageMC = _body.userImageMC;
			
			_videoPlayer = new ChromelessVideoPlayer(AbstractMain.PATH+_xml.video, 960, 540)
			_videoPlayer.addEventListener(VideoControllerEvent.CONNECTION_MADE, videoReadyHandler, false, 0);
			_videoPlayer.addEventListener(VideoControllerEvent.VIDEO_OVER, bodyOverHandler, false, 0);
			_videoPlayer.addEventListener(VideoControllerEvent.VIDEO_CUE_POINT, videoCuePointHandler, false, 0);
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoadComplete,false,0,true);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false,0,true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress,false,0,true);
			_loader.load(new URLRequest(DataCacheProxy.IMAGEPROXY+_linkedIn["pictureurl"]));
		}
		
		override public function resize(obj:Object):void
		{
			if (_body) {
				//_body.scaleX = _body.scaleY = obj.scale;
				_body.width = obj.width;
				_body.height = obj.height;
				_body.y = obj.offsetY;
			}
		}
		
		override public function playSection():void { 
			
			//trace(this, "playSection", _volume );
			super.playSection();
			_videoPlayer.volume(_volume);
			_videoPlayer.resume();
			
			var obj:Object = {origin:"experience", scene:"7"}
			dispatchEvent(new SceneEvent(SceneEvent.TRACKING, obj));
		}
		
		override public function setVolume($ratio:Number):void
		{
			super.setVolume($ratio)
			if (_videoPlayer) { _videoPlayer.volume($ratio); }
		}
	
		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		override public function destroyBody($e:Event):void {
			_body.removeChild(_videoPlayer);
			super.destroyBody($e);
		}

		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		private function videoCuePointHandler($e:VideoControllerEvent):void
		{
			switch ($e.videoData.name)
			{
				case "boardFadeStart":
					_userImageMC.removeChild(_bitmap);
					_body.removeChild(_userImageMC);
					_bitmap = null;
					_userImageMC = null;
					break;
				case "boardFadeEnd":
					dispatchEvent(new SceneEvent(SceneEvent.FADE_IN_OUTRO));
					break;
			}
		}
		
		private function videoReadyHandler($e:VideoControllerEvent):void
		{
			super.prepareBody();
		}
		
		private function videoOverHandler($e:VideoControllerEvent):void
		{
			dispatchFinished()
		}
		
		private function onAssetLoadComplete($e:Event):void{
			//remove xml listeners, init asset manager and pass it asset mc and xml
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onAssetLoadComplete,false);
			_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress,false);
			
			_bitmap = Bitmap(_loader.content); 
			sizeAndPlace(_userImageMC, _bitmap);
			_userImageMC.visible = true;
			_body.addChildAt(_videoPlayer, 0);

		}
		
		//loading hellper functions
		private function httpStatusHandler($e:HTTPStatusEvent):void{
			//trace("httpStatusHandler: " + $e);
		}
		private function ioErrorHandler($e:IOErrorEvent):void{
			trace("ioErrorHandler: " + $e);
		}
		private function onLoadProgress($e:ProgressEvent):void{
			//trace("progressHandler: bytesLoaded=" + $e.bytesLoaded + " bytesTotal=" + $e.bytesTotal);
		}		

	}
}