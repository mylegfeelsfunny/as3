﻿package com.egraphicsNY.as3.display.video.youtube{	import flash.display.Loader;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Rectangle;	import flash.net.URLRequest;	import flash.system.Security;			public class YouTubeChromeVideoPlayer extends MovieClip	{		public static var PLAYER_READY:String = "Player Ready";		public static var PLAYER_FINISHED:String = "Player Finished";		public static var PLAYER_STATE_UNSTARTED:String = "-1";		public static var PLAYER_STATE_ENDED:String = "0";		public static var PLAYER_STATE_PLAYING:String = "1";		public static var PLAYER_STATE_PAUSED:String = "2";		public static var PLAYER_STATE_BUFFERING:String = "3";		public static var PLAYER_STATE_CUED:String = "5";				private var player:Object;		private var playerW:int;		private var playerH:int;		private var vidId:String;		private var loader:Loader;		private var vpcontrols:MovieClip;		private var controlURL:String;		private var controlHeight:uint;				public function YouTubeChromeVideoPlayer(youTubeVideoID:String, width:int, height:int, controlLoc:String=undefined, control_height:int = 30)		{					Security.allowDomain('www.youtube.com');  			Security.allowDomain('youtube.com');  			Security.allowDomain('s.ytimg.com');			Security.allowDomain('i.ytimg.com');									var background:Sprite = new Sprite();			background.graphics.beginFill(0x000000);			background.graphics.drawRect(0,0, width, height);			background.graphics.endFill();			addChild(background);						loader = new Loader();			vidId = youTubeVideoID;			playerW = width;			playerH = height;			controlURL = controlLoc;			controlHeight = control_height;			var url:String = "http://www.youtube.com/v/"+vidId+"?version=3&autoplay=1&loop=10&rel=0&showsearch=0&hd=1&egm=1&iv_load_policy=1";			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);			loader.load(new URLRequest(url));		}		private function onLoaderInit(e:Event):void		{						addChild(loader);				loader.content.addEventListener("onReady", onPlayerReady);					loader.content.addEventListener("onStateChange", onPlayerStateChange);			}				private function onPlayerReady(e:Event):void		{			player = loader.content;			player.setSize(playerW, playerH);			player.playVideo();		}				private function onPlayerStateChange(e:Event):void		{			var state:String = Object(e).data.toString();												switch(state)			{				case PLAYER_STATE_UNSTARTED:					dispatchEvent(new Event(PLAYER_STATE_UNSTARTED));					break;				case PLAYER_STATE_ENDED:					dispatchEvent(new Event(PLAYER_STATE_ENDED));					kill();					break;				case PLAYER_STATE_PLAYING:					dispatchEvent(new Event(PLAYER_STATE_PLAYING));					break;				case PLAYER_STATE_PAUSED:					dispatchEvent(new Event(PLAYER_STATE_PAUSED));					break;				case PLAYER_STATE_BUFFERING:					dispatchEvent(new Event(PLAYER_STATE_BUFFERING));										break;				case PLAYER_STATE_CUED:					dispatchEvent(new Event(PLAYER_STATE_CUED));					break;				}		}				public function kill():void		{			player.destroy();		}	}}