package com.office365.view.ui.experience.scenes
{
	import com.deepfocus.as3.display.video.videoplayer.ChromelessVideoPlayer;
	import com.deepfocus.as3.display.video.videoplayer.events.VideoControllerEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public final class VideoScene extends AbstractScene
	{
		
		public function VideoScene($json:Object,$path:String)
		{
			super($json, $path);
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
		override public function playSection():void {
			_body.resume();
			super.playSection();
		}
		
		override public function resize(obj:Object):void
		{
			_body.resize(obj.width, obj.height);
			super.resize(obj);
		}
		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		override public function prepareBody():void
		{
			// JSON MS STUFF
			
			super.prepareBody();
		}
		
		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		override public function createBody():void { 
			_body = new ChromelessVideoPlayer(_path, stage.stageWidth, stage.stageWidth * (5 / 9));
			_body.addEventListener(VideoControllerEvent.CONNECTION_MADE, startVideoHandler, false, 0);
			_body.addEventListener(VideoControllerEvent.VIDEO_OVER, bodyOverHandler, false, 0);
			addChild(_body);
		}
		
		override public function destroyBody($e:Event):void {
			
			super.destroyBody($e);
		}
		
		private function startVideoHandler($e:VideoControllerEvent):void
		{
			_body.volume(0);
			prepareBody()
			//_body.resume();
		}
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		

	}
}