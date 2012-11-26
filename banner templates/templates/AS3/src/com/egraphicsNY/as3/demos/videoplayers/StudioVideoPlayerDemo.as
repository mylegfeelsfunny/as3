package com.egraphicsNY.as3.demos.videoplayers
{
	import com.bigspaceship.utils.Out;
	import com.egraphicsNY.as3.demos.videoplayers.StudioVideoPlayerConstants;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	
	
	public class StudioVideoPlayerDemo extends MovieClip
	{
		protected var _assetsManager:StudioVideoPlayerAssetManager;
		public var _loader:Loader;
		public var linkVideoControls:String;
		
		public function StudioVideoPlayerDemo()
		{
			addEventListener(Event.ADDED_TO_STAGE,_init,false,0,true);
			//linkVideoControls = "../deploy/demos/display/videoplayers/VideoControls.swf";
			//linkVideoControls = "VideoControls.swf";
			StudioVideoPlayerConstants.STATE = StudioVideoPlayerConstants.STUDIO_VIDEO_PLAYER;
		}
		public function linkDeployValid():void{
			//linkVideoControls = "../deploy/demos/display/videoplayers/VideoControls.swf";
			StudioVideoPlayerConstants.STATE = StudioVideoPlayerConstants.DEFAULT_APPLICATION;
		}
		public function _init($event:*=null):void{
			removeEventListener(Event.ADDED_TO_STAGE,_init);
			//
			stage.align				= StageAlign.TOP_LEFT;
			stage.scaleMode			= StageScaleMode.NO_SCALE;
			//
			Out.enableAllLevels();
			Out.info(this,'_init()');
			//
			_loadAssets();
		}
		public function _loadAssets():void{
			//
			switch(StudioVideoPlayerConstants.STATE){
				case StudioVideoPlayerConstants.DEFAULT_APPLICATION:
					linkVideoControls = "../deploy/demos/display/videoplayers/VideoControls.swf";
				break;
				case StudioVideoPlayerConstants.STUDIO_VIDEO_PLAYER:
					linkVideoControls = "VideoControls.swf";
				break;
			}
				
			_loader = new Loader();
			var l:LoaderInfo		= _loader.contentLoaderInfo;
			l.addEventListener(Event.COMPLETE,_onAssetLoaded,false,0,true);
			_loader.load(new URLRequest(linkVideoControls));
			//deploy/display/videoplayers/VideoControls.swf
			//trace("_loadAssets")
		}
		public function _onAssetLoaded($evt:Event):void{
			//trace("_onAssetLoaded");
			var li:LoaderInfo		= LoaderInfo($evt.target);
			_assetsManager			= new StudioVideoPlayerAssetManager(MovieClip(_loader.contentLoaderInfo.content));
	        addChild(_assetsManager); 
		}

	}
}