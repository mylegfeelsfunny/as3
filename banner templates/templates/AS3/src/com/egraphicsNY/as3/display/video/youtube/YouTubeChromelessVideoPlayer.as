package com.egraphicsNY.as3.display.video.youtube
{
	import com.egraphicsNY.as3.display.video.videocontrols.VideoControls;
	import com.egraphicsNY.as3.events.VideoControlerEvent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class YouTubeChromelessVideoPlayer extends MovieClip
	{
		public static var PLAYER_READY:String 			= "Player Ready";
		public static var PLAYER_FINISHED:String 		= "Player Finished";
		public static var PLAYER_STATE_UNSTARTED:String = "-1";
		public static var PLAYER_STATE_ENDED:String 	= "0";
		public static var PLAYER_STATE_PLAYING:String 	= "1";
		public static var PLAYER_STATE_PAUSED:String 	= "2";
		public static var PLAYER_STATE_BUFFERING:String = "3";
		public static var PLAYER_STATE_CUED:String 		= "5";
		
		private var player:Object;
		private var playerW:Number;
		private var playerH:Number;
		private var vidId:String;
		private var loader:Loader;
		private var vpcontrols:MovieClip;
		private var loadComplete:Boolean;
		private var controlURL:String;
		private var controlHeight:Number;
		private var _contextMenu:ContextMenu;
		private var _menuText1:ContextMenuItem;
		private var _menuText2:ContextMenuItem;
		
		public function YouTubeChromelessVideoPlayer(youTubeVideoID:String, width:Number, height:Number, controlLoc:String = undefined, control_height:Number=30)
		{
			Security.allowDomain('www.youtube.com');  
			Security.allowDomain('youtube.com');  
			Security.allowDomain('s.ytimg.com');
			Security.allowDomain('i.ytimg.com');
			
			loader 			= new Loader();
			vidId 							= youTubeVideoID;
			playerW 						= width;
			playerH 						= height;
			controlURL 						= controlLoc;
			controlHeight 					= control_height;
			loadComplete 					= false;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));			
		}
		
		private function onLoaderCompleteHandler(e:Event):void
		{			
			addChild(loader);
				
			vpcontrols = new VideoControls(controlURL, playerW, controlHeight);
			vpcontrols.addEventListener(VideoControls.CONTROLS_READY, onControlsReady);
			
			loader.content.addEventListener("onReady", onPlayerReady);
		    loader.content.addEventListener("onError", onPlayerError);
		    loader.content.addEventListener("onStateChange", onPlayerStateChange);
		}
		
		private function onPlayerReady(e:Event):void
		{
			player = loader.content;
			player.setSize(playerW, playerH-controlHeight);
			player.loadVideoById(vidId, 0, "large");		
		}
		
		private function onControlsReady(e:Event):void
		{
			vpcontrols.y = playerH - controlHeight;
			vpcontrols.addEventListener(VideoControls.PLAYER_PLAY, onPlayVideo);
			vpcontrols.addEventListener(VideoControls.PLAYER_PAUSE, onPauseVideo);
			vpcontrols.addEventListener(VideoControls.PLAYER_CLOSE, onCloseVideo);	
			vpcontrols.addEventListener(VideoControls.SOUND_OFF, playerMute);	
			vpcontrols.addEventListener(VideoControls.SOUND_ON, playerUnmute);	
			
			vpcontrols.addEventListener(VideoControlerEvent.PAUSE_VIDEO,onPauseVideo,false,0,true);
			vpcontrols.addEventListener(VideoControlerEvent.RESUME_VIDEO,onPlayVideo,false,0,true);		
			vpcontrols.addEventListener(VideoControlerEvent.SEEK,_onScrub,false,0,true);
			addChild(vpcontrols);
			
			dispatchEvent(new Event(PLAYER_READY));	
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_contextMenu 					= new ContextMenu();
			_contextMenu.hideBuiltInItems();
			_menuText1 						= new ContextMenuItem("Copy Embed Code", false, true, true);
			_menuText2						= new ContextMenuItem("Copy Share Code", false, true, true);
			_contextMenu.customItems.push(_menuText1);
			_contextMenu.customItems.push(_menuText2);
			_menuText1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _menuAction1,false,0,true);
			_menuText2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _menuAction2,false,0,true);
			this.contextMenu 		= _contextMenu;
		}
		
		private function onPlayerError(e:Event):void
		{
			trace(e);
		}

		private function onIOErrorHandler(e:IOErrorEvent):void
		{			
			trace(this, e);
		}

		private function onEnterFrame(e:Event):void
		{
			try
			{
				var loadProgress:Number = (player.getVideoBytesLoaded()/player.getVideoBytesTotal());
				var playProgress:Number = (player.getCurrentTime()/player.getDuration());
				vpcontrols.LoadProgress(loadProgress);
				vpcontrols.PlayProgress(playProgress);
			}
			catch(e:Error)
			{;}
			finally
			{;}
		}
				
		public function playerMute(e:Event):void{
			player.mute();
		}
		
		public function playerUnmute(e:Event):void{
			player.unMute();
		}		
		
		private function onPlayVideo(e:Event):void
		{
			player.playVideo();
		}
		
		private function onPauseVideo(e:Event):void
		{
			player.pauseVideo();
		}
		
		private function onCloseVideo(e:Event):void
		{
			player.stopVideo();
			dispatchEvent(new Event(PLAYER_STATE_ENDED));
			kill();
		}
		
		private function onPlayerStateChange(e:Event):void
		{
			var state:String = Object(e).data.toString();
									
			switch(state)
			{
				case PLAYER_STATE_UNSTARTED:
					dispatchEvent(new Event(PLAYER_STATE_UNSTARTED));
					break;
				case PLAYER_STATE_ENDED:
					dispatchEvent(new Event(PLAYER_STATE_ENDED));
					//kill();
					player.seekTo(0, true);
					break;
				case PLAYER_STATE_PLAYING:
					dispatchEvent(new Event(PLAYER_STATE_PLAYING));
					break;
				case PLAYER_STATE_PAUSED:
					dispatchEvent(new Event(PLAYER_STATE_PAUSED));
					break;
				case PLAYER_STATE_BUFFERING:
					dispatchEvent(new Event(PLAYER_STATE_BUFFERING));					
					break;
				case PLAYER_STATE_CUED:
					dispatchEvent(new Event(PLAYER_STATE_CUED));
					break;	
			} 
		}
		
		private function _onScrub($evt:VideoControlerEvent):void
		{
			player.seekTo(Number($evt.position*player.getDuration()),true);
		}
		
		private function _menuAction1(e:Event):void
		{
			//trace("menuAction1");
		    System.setClipboard("eventinfo" + e);
		}
		
		private function _menuAction2(e:Event):void
		{
			//trace("menuAction2");
		    System.setClipboard("eventinfo" + e);
		}
		
		public function kill():void
		{
			player.destroy();
		}
		
	}
}