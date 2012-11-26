package com.egraphicsNY.as3.demos.videoplayers
{
	import com.bigspaceship.utils.Out;
	import com.egraphicsNY.as3.display.video.egraphicsPlayers.StudioVideoPlayer;
	import com.egraphicsNY.as3.display.video.egraphicsPlayers.StudioVideoPlayerList;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class StudioVideoPlayerAssetManager extends MovieClip
	{
		public var  _mc:MovieClip;
		private var _videoLink:String;
		//
		private var _videolistXMLLink:String;
		private var _videolistRootDirectory:String;
		//
		private var _videoPlayer:StudioVideoPlayer;
		
		private var _videoPlayerList:StudioVideoPlayerList;


		public function StudioVideoPlayerAssetManager($mc:MovieClip):void{
			Out.debug(this,"class");
			addEventListener(Event.ADDED_TO_STAGE,_init,false,0,true);
			_mc = $mc;
		}
		protected function _init($evt:Event):void{
			Out.debug(this,"_init");
			removeEventListener(Event.ADDED_TO_STAGE,_init);
			//addChild(_mc);
			switch(StudioVideoPlayerConstants.STATE)
			{
				case StudioVideoPlayerConstants.DEFAULT_APPLICATION:
					_videoLink = "../deploy/video_assets/video01.flv";
					//
					_videolistXMLLink = "../deploy/xml/videolist.xml";
					_videolistRootDirectory = "../deploy/";
				break;
				case StudioVideoPlayerConstants.STUDIO_VIDEO_PLAYER:
					_videoLink = "../../../video_assets/video01.flv";
					//
					_videolistXMLLink = "../../../xml/videolist.xml";
					_videolistRootDirectory = "../../../";
				break;
			}
			
			//<!-- for single video player
			//_videoPlayer = new StudioVideoPlayer(_videoLink, 520, 300, _mc, 30);
			//addChild(_videoPlayer);
			// for single video player
			
			//<!-- for XML driven video player
			_videoPlayerList = new StudioVideoPlayerList(_videolistXMLLink, _videolistRootDirectory, 520, 300, _mc, 30);
			addChild(_videoPlayerList);
			//for XML driven video player -->
		}	

	}
}