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
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	public final class Scene1 extends FlashScene
	{
		private var _userImageMC:MovieClip;
		private var _bitmap:Bitmap;
		private var _locObj:Object = {};
		private var _videoPlayer:ChromelessVideoPlayer;
		private var _loader:Loader;
		
		public function Scene1($linkedIn:Object, $classInfo:Object)
		{
			super($linkedIn, $classInfo);
		}
		
		override public function prepareBody():void
		{

			trace(this, "prepareBody", _linkedIn );
			_userImageMC = _body.userImageMC_0;
			_userImageMC.visible = false;
			_body.userImageMC_1.visible = false;
			
			_locObj.image = {x:_userImageMC.x, y:_userImageMC.y};
			
			_videoPlayer = new ChromelessVideoPlayer(AbstractMain.PATH+_xml.video, 960, 540)
			_videoPlayer.addEventListener(VideoControllerEvent.CONNECTION_MADE, videoReadyHandler, false, 0);
			_videoPlayer.addEventListener(VideoControllerEvent.VIDEO_OVER, bodyOverHandler, false, 0);
			_videoPlayer.addEventListener(VideoControllerEvent.VIDEO_CUE_POINT, videoCuePointHandler, false, 0);
			_videoPlayer.visible = false;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoadComplete,false,0,true);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false,0,true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress,false,0,true);
			_loader.load(new URLRequest(DataCacheProxy.IMAGEPROXY+_linkedIn["pictureurl"]));
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
		override public function resize(obj:Object):void
		{
			try	{
			//_body.scaleX = _body.scaleY = obj.scale;
			
			_body.width = obj.width;
			_body.height = obj.height;

			_body.y = obj.offsetY;
			} catch ($e:Error) {
				trace(this, "$e.name", $e.name);
			}
		}
		
		override public function playSection():void { 
			//_videoPlayer.resume();
			trace(this, "volume", _volume);
			_videoPlayer.resume();
			_videoPlayer.visible = true;
			_userImageMC.visible = true;

			var obj:Object = {origin:"experience", scene:"1"}
			dispatchEvent(new SceneEvent(SceneEvent.TRACKING, obj));

			super.playSection();
		}
		
		override public function setVolume($ratio:Number):void
		{

			super.setVolume($ratio);
			if (_videoPlayer) _videoPlayer.volume($ratio);
		}

		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		override public function destroyBody($e:Event):void {
			_body.removeChild(_videoPlayer);
			_userImageMC.removeChild(_bitmap);
			_body.removeChild(_userImageMC);
			_bitmap = null;
			_userImageMC = null;
			super.destroyBody($e);
		}
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		private function videoCuePointHandler($e:VideoControllerEvent):void
		{
			switch ($e.videoData.name)
			{
				case "board1OUT":
					_userImageMC.removeChild(_bitmap);
					_body.removeChild(_userImageMC);
					_userImageMC = null;
					_userImageMC = _body.userImageMC_1;
					sizeAndPlace(_userImageMC, _bitmap);
					break;
				case "board1IN":
					_userImageMC.visible = true;
					break;
			}
		}
		
		private function videoReadyHandler($e:VideoControllerEvent):void
		{
			super.prepareBody();
		}
		
		private function videoOverHandler($e:VideoControllerEvent):void
		{
			dispatchFinished();
			//_body.dispatchEvent(new Event("flash_timeline_over"));
		}

		private function onAssetLoadComplete($e:Event):void{
			//remove xml listeners, init asset manager and pass it asset mc and xml
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onAssetLoadComplete,false);
			_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress,false);
			
			_bitmap = Bitmap(_loader.content); 
			sizeAndPlace(_userImageMC, _bitmap);
			_body.addChildAt(_videoPlayer, 0);
			
			_body.stage.dispatchEvent(new Event(Event.RESIZE));
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