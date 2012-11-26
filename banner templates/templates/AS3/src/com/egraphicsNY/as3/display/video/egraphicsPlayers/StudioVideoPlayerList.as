package com.egraphicsNY.as3.display.video.egraphicsPlayers
{
	
	import com.bigspaceship.utils.Out;
	import com.egraphicsNY.as3.display.video.videocontrols.StudioVideoControls;
	import com.egraphicsNY.as3.events.StudioVideoControlsEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class StudioVideoPlayerList extends MovieClip
	{
		protected var vpcontrols:StudioVideoControls;
		//
		public var _videolistXMLLink:String;
		public var _videolistRootDirectory:String;
		//
		protected var _controlMC:MovieClip;
		protected var playerW:Number;
		protected var playerH:Number;
		protected var controlHeight:Number;
		//
		public var _videolistArray:Array;
		public var _videolistCount:int;
		//
		public function StudioVideoPlayerList($videolistXMLLink:String, $videolistRootDirectory:String, $width:Number, $height:Number, $controlMC:MovieClip, $control_height:Number=30)
		{
			_videolistXMLLink = $videolistXMLLink;
			_videolistRootDirectory = $videolistRootDirectory;
			_controlMC = $controlMC;
			//
			
			playerW = $width;
			playerH = $height;
			
			controlHeight = $control_height;
			//
			parseXML();
		}
		
		protected function parseXML():void
		{
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.load(new URLRequest(_videolistXMLLink));
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoadComplete);
		}
		protected function xmlLoadComplete($e:Event=null):void
		{
			var xmlMy:XML = XML($e.currentTarget.data);
			_videolistArray = new Array();
			for(var I:int=0; I < xmlMy.children().length(); I++)
			{
				//trace(xmlMy.children()[I])
				var O:Object = new Object();
				O.title = xmlMy.children()[I].title;
				O.thumb = xmlMy.children()[I].thumb;
				O.link = xmlMy.children()[I].link;
				_videolistArray.push(O);
			}
			init();
		}
		
		
		protected function init():void
		{
			var vpcontrolsObject:Object = {mc:_controlMC, videoWidth:playerW, videoHeight:playerH, controlHeight:controlHeight} 
			vpcontrols = new StudioVideoControls(vpcontrolsObject);
			vpcontrols.addEventListener(StudioVideoControlsEvent.VIDEO_PLAY, studioVideoControlsHandler);
			vpcontrols.addEventListener(StudioVideoControlsEvent.VIDEO_PAUSE, studioVideoControlsHandler);
			vpcontrols.addEventListener(StudioVideoControlsEvent.VIDEO_RESUME, studioVideoControlsHandler);
			vpcontrols.addEventListener(StudioVideoControlsEvent.VIDEO_CLOSE, studioVideoControlsHandler);
			addChild(vpcontrols);
			//
			_videolistCount = 0;
			playVideolist();
		}
		
		protected function playVideolist():void
		{
			if(videolistCountCondition == "videoEnd")
			{
				return;
			}
			vpcontrols.videoLink = _videolistRootDirectory+ _videolistArray[_videolistCount].link;
			vpcontrols.videoState = StudioVideoControls.VIDEO_PLAY;
		}
		protected function addVideolistCount():void
		{
			_videolistCount ++;
		}
		protected function get videolistCountCondition():String
		{
			var myCondition:String;
			if(_videolistCount >= _videolistArray.length)
			{
				_videolistCount = 0;
				vpcontrols.videoLink = _videolistRootDirectory+ _videolistArray[0].link;
				myCondition = "videoEnd";
			}else
			{
				myCondition = "videoStart";
			}
			
			return myCondition;
		}
		
		public function studioVideoControlsHandler(e:StudioVideoControlsEvent=null):void
		{
			Out.debug(this, e.type);
			//trace("**studioVideoControlsHandler()",e.type);
			if(e.type == StudioVideoControlsEvent.VIDEO_CLOSE)
			{
				addVideolistCount();
				playVideolist();
			}
		}
		

	}
}