package com.egraphicsNY.as3.display.video.videocontrols
{
	import com.egraphicsNY.as3.events.StudioVideoControlsEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	public class StudioVideoControls extends MovieClip implements IVideoControls
	{
		//
		private var _videoState:String;
		private var _soundState:String;
		//
		public static const PLAYER_INIT												:String = "playerInit";
		public static const VIDEO_PLAY												:String 	= "videoPlay";
		public static const VIDEO_PAUSE											:String 	= "videoPause";
		public static const VIDEO_RESUME											:String 	= "videoResume";
		public static const VIDEO_SEEK												:String 	= "videoSeek";
		public static const VIDEO_CLOSE											:String 	= "videoClose";
		//
		public static const SOUND_OFF												:String 	= "soundOff";
		public static const SOUND_ON												:String 	= "soundOn";
		//
		public static const SCRUBBER_STARTDRAG								:String 	= "scrubberStartDrag";
		public static const SCRUBBER_STOPDRAG								:String 	= "scrubberStopDrag";
		//
		private var _video:Video;
		private var _video_duration:Number;
		private var _videoVolumeTransform:SoundTransform;
		private var _volumeNumberDefault:Number = 1;
		private var _volumeNumber:Number = _volumeNumberDefault;
		private var _netconnection:NetConnection;
		private var _netstream:NetStream;
		//
		private var _scrubberState:String;
		//
		private var _bytesNS_Timer:Timer;
		private var _mcFullbarWidth:Number;
		private var _mcFullbarOffsetX:Number;
		private var _mcFullbarOffsetY:Number;
		private var _mcScrubberOffsetX:Number;
		private var _mcScrubberOffsetY:Number;
		//
		private var _videoLink:String;
		private var _videoWidth:uint;
		private var _videoHeight:uint;
		private var _controlHeight:uint;
		//
		private var _mc:MovieClip;
		private var _mcPlaybutton:MovieClip;
		private var _mcPausebutton:MovieClip;
		private var _mcClosebutton:MovieClip;
		private var _mcFullbar:MovieClip;	
		private var _mcLoadprogressbar:MovieClip;
		private var _mcPlayprogressbar:MovieClip;	
		private var _mcBackground:MovieClip;
		private var _mcScrubber:MovieClip;	
		private var _mcSound:MovieClip;
		private var collectActivateUI_videoClose:Array;
		
		public function StudioVideoControls($vpcontrolsObject:Object):void
		{
			
			videoWidth = $vpcontrolsObject.videoWidth;
			videoHeight = $vpcontrolsObject.videoHeight;
			_controlHeight = $vpcontrolsObject.controlHeight;
			//
			_mc = $vpcontrolsObject.mc;
			this.addChild(_mc);
			//
			initAssets();
		}
		
		public function initAssets():void
		{
			videoState = StudioVideoControls.PLAYER_INIT;
		}
		
		
		
		//************************************
		//<!-- set video state
		
		public function set videoState($videoState:String):void
		{
			_videoState = $videoState;
			videoStateUpdate();
		}
		public function get videoState():String
		{
			return _videoState;
		}
		public function videoStateUpdate():void
		{
			switch (videoState)
			{
				case StudioVideoControls.PLAYER_INIT:
					initVideo();
					initSound();
					initUI();
					initBytesNetStream();
					//
					dispatchEvent(new StudioVideoControlsEvent(StudioVideoControlsEvent.PLAYER_INIT));
				break;
				case StudioVideoControls.VIDEO_PLAY:
					connectStream();
					dispatchEvent(new StudioVideoControlsEvent(StudioVideoControlsEvent.VIDEO_PLAY));
					//<!-- for bug of video close and automatic sequence play
					var timerMy:Timer = new Timer(100,1);
					timerMy.addEventListener(TimerEvent.TIMER_COMPLETE, function():void
					{
						displayVideo(true);
						exclusivePlayPause(false);
						indicateNetStream(true);
						activateUI(true);
					});
					timerMy.start();
					// for bug of video close and automatic sequence play -->
				break;
				case StudioVideoControls.VIDEO_PAUSE:
					_netstream.pause();
					dispatchEvent(new StudioVideoControlsEvent(StudioVideoControlsEvent.VIDEO_PAUSE));
					exclusivePlayPause(true);
					indicateNetStream(false);
				break;
				case StudioVideoControls.VIDEO_RESUME:
					_netstream.resume();
					dispatchEvent(new StudioVideoControlsEvent(StudioVideoControlsEvent.VIDEO_RESUME));
					exclusivePlayPause(false);
					indicateNetStream(true);
				break;
				case StudioVideoControls.VIDEO_SEEK:
					//
					_netstream.seek(seekSeconds);
					//_netstream.resume();
					//
					dispatchEvent(new StudioVideoControlsEvent(StudioVideoControlsEvent.VIDEO_SEEK));
					//indicateNetStream(true);
					videoState = StudioVideoControls.VIDEO_RESUME;
				break;
				case StudioVideoControls.VIDEO_CLOSE:
					_netstream.close();
					displayVideo(false);
					dispatchEvent(new StudioVideoControlsEvent(StudioVideoControlsEvent.VIDEO_CLOSE));
					exclusivePlayPause(true);
					indicateNetStream(false);
					activateUI(false);
					resetUI();
				break;
				default:
				break;
			}
		}
		
		public function set videoLink($videoLink:String):void
		{
			_videoLink = $videoLink;
		}
		public function get videoLink():String
		{
			return _videoLink;
		}
		
		public function set videoHeight($videoHeight:uint):void
		{
			_videoHeight = $videoHeight;
		}
		public function get videoHeight():uint
		{
			return _videoHeight;
		}
		
		public function set videoWidth($videoWidth:uint):void
		{
			_videoWidth = $videoWidth;
		}
		public function get videoWidth():uint
		{
			return _videoWidth;
		}
		
			
		// set video state -->
		//************************************
		
		
		
		
		//************************************
		//<!-- set sound state
		
		public function initSound():void
		{
			_soundState = StudioVideoControls.SOUND_ON;
			
		}
		
		public function set soundState($soundState:String):void
		{
			_soundState = $soundState;
			soundStateUpdate();
		}
		public function get soundState():String
		{
			return _soundState;
		}
		public function soundStateUpdate():void
		{
			trace("soundState=",soundState)
			switch (soundState)
			{
				case StudioVideoControls.SOUND_ON:
					volumeNumber = _volumeNumberDefault;
					_videoVolumeTransform.volume = volumeNumber;
					_netstream.soundTransform = _videoVolumeTransform;
				break;
				case StudioVideoControls.SOUND_OFF:
					volumeNumber = 0;
					_videoVolumeTransform.volume = volumeNumber;
					_netstream.soundTransform = _videoVolumeTransform;
				break;
			}
			drawSoundUI();
		}
		
		
		public function set volumeNumber($volumeNumber:Number):void
		{
			_volumeNumber = $volumeNumber;	
		}
		public function get volumeNumber():Number
		{
			return _volumeNumber;
		}

		
		
		//<!-- set sound state
		//************************************
		
		
		
		
		//************************************
		//<!-- UI set up
		public function initUI():void
		{
			_mcBackground = _mc.background;
			_mcBackground.height = _controlHeight;
			//
			_mcPlaybutton = _mc.playbutton;
			_mcPlaybutton.buttonMode = true;
			_mcPlaybutton.addEventListener(MouseEvent.CLICK, playbuttonClick);
			//
			_mcPausebutton = _mc.pausebutton;
			_mcPausebutton.buttonMode = true;
			_mcPausebutton.addEventListener(MouseEvent.CLICK, pausebuttonClick);
			//
			_mcFullbar = _mc.fullbar;
			_mcLoadprogressbar = _mc.loadprogressbar;
			_mcPlayprogressbar = _mc.playprogressbar;
			//
			_mcScrubber = _mc.scrubber;
			_mcScrubber.buttonMode = true;
			_mcScrubber.addEventListener(MouseEvent.MOUSE_DOWN, onScrubberMouseEvent);
			_mcScrubber.addEventListener(MouseEvent.MOUSE_UP, onScrubberMouseEvent);
			//
			//_mcScrubber.stage.addEventListener(MouseEvent.MOUSE_MOVE, onScrubberMouseEvent);
			_mcScrubber.addEventListener(Event.ADDED_TO_STAGE, function():void{
				_mcScrubber.stage.addEventListener(MouseEvent.MOUSE_UP, onScrubberMouseEvent);
			});
			//
			_mcSound = _mc.sound;
			_mcSound.buttonMode = true;
			_mcSound.mouseChildren = false;
			_mcSound.addEventListener(MouseEvent.CLICK, soundbuttonClick);
			
			_mcClosebutton = _mc.closebutton;
			_mcClosebutton.buttonMode = true;
			_mcClosebutton.mouseChildren = false;
			_mcClosebutton.addEventListener(MouseEvent.CLICK, closebuttonClick);
			//<!-- you need to initialize video first //_video
			initChildIndex(_video,_mcClosebutton);
			//
			collectActivateUI_videoClose = [_mcPausebutton, _mcScrubber, _mcSound, _mcClosebutton];
			
			resetUI();
			drawSoundUI();
		}
		public function initChildIndex($child1:*, $child2:*):void
		{
			$child1.parent.swapChildren($child1,$child2);
		}
		public function resetUI():void
		{
			_mcBackground.width = videoWidth;
			_mcBackground.y = videoHeight;
			//
			var mcPausebuttonOffsetY:Number = _mcBackground.y + 15;
			_mcPausebutton.x = 10;
			_mcPausebutton.y = mcPausebuttonOffsetY;
			//
			var mcPlaybuttonOffsetY:Number = _mcBackground.y + 15;
			_mcPlaybutton.x = 10;
			_mcPlaybutton.y = mcPlaybuttonOffsetY;
			//
			//<!-- important for common variable
			_mcFullbarOffsetX = 40;
			_mcFullbarOffsetY = _mcBackground.y + 15;
			_mcFullbarWidth = (_mcBackground.width - 40) - 40;
			// important for common variable -->
			
			_mcFullbar.x = _mcFullbarOffsetX;
			_mcFullbar.y = _mcFullbarOffsetY;
			_mcFullbar.width = _mcFullbarWidth;
			//
			_mcLoadprogressbar.x = _mcFullbarOffsetX;
			_mcLoadprogressbar.y = _mcFullbarOffsetY;
			//_mcLoadprogressbar.width = _mcFullbarWidth;
			//
			_mcPlayprogressbar.x = _mcFullbarOffsetX;
			_mcPlayprogressbar.y = _mcFullbarOffsetY;
			_mcPlayprogressbar.width = _mcFullbarWidth;
			//
			//<!-- important for common variable
			_mcScrubberOffsetX = _mcFullbarOffsetX-5;
			_mcScrubberOffsetY = _mcFullbarOffsetY-7.5;
			// important for common variable -->
			//
			//_mcScrubber.alpha = .25
			_mcScrubber.x = _mcScrubberOffsetX;
			_mcScrubber.y = _mcScrubberOffsetY;
			//
			_mcSound.x = _mcFullbarOffsetX + _mcFullbarWidth + 15;
			_mcSound.y =  _mcBackground.y + 5;
			//
			_mcClosebutton.x = videoWidth - 60;
		}
		
		public function drawLoadprogressbar($N:Number):void
		{
			_mcLoadprogressbar.width = $N * _mcFullbarWidth;
		}
		public function drawPlayprogressbar($N:Number):void
		{
			_mcPlayprogressbar.width = $N * _mcFullbarWidth;
		}
		public function drawScrubber($N:Number):void
		{
			if(scrubberState != StudioVideoControls.SCRUBBER_STARTDRAG)
			{
				_mcScrubber.x = _mcScrubberOffsetX + _mcFullbarWidth * $N;
			}
		}
		
		public function get mcLoadprogressbarWidth():Number
		{
			return _mcLoadprogressbar.width;
		}
		
		public function get seekSeconds():Number
		{
			var mySeekSeconds:Number;
			var mySeekRatio:Number = Math.round( (_mcScrubber.x - _mcScrubberOffsetX)/_mcFullbarWidth*100)/100;
			mySeekSeconds = mySeekRatio * _video_duration;
			return mySeekSeconds;
		}
		
		
			
		public function exclusivePlayPause($b:Boolean=true):void
		{
			switch($b)
			{
				case true:
					_mcPlaybutton.visible = true;
					_mcPausebutton.visible = false;
				break;
				case false:
					_mcPlaybutton.visible = false;
					_mcPausebutton.visible = true;
				break;
			}
		}
		
		public function drawSoundUI():void
		{
			switch (soundState)
			{
				case StudioVideoControls.SOUND_ON:
					_mcSound.slash.visible = false;
				break;
				case StudioVideoControls.SOUND_OFF:
					_mcSound.slash.visible = true;
				break;
			}
		}
		
		
		
		public function activateUI($valid:Boolean):void
		{
			for(var I:int=0; I < collectActivateUI_videoClose.length; I++)
			{
				collectActivateUI_videoClose[I].mouseEnabled = $valid;
				//collectActivateUI_videoClose[I].visible = $valid;
			}
		}
		// UI set up -->
		//************************************
		
		
		
		
		
		
		//************************************
		//<!-- UI encapsulation
		
		public function playbuttonClick(e:Event):void
		{
			trace("playbuttonClick/videoState=",videoState)
			switch(videoState)
			{
				case StudioVideoControls.VIDEO_CLOSE:
					videoState = StudioVideoControls.VIDEO_PLAY;
				break;
				case StudioVideoControls.VIDEO_PAUSE:
					videoState = StudioVideoControls.VIDEO_RESUME;
				break;
			}
			
		}
		
		public function pausebuttonClick(e:Event):void
		{
			videoState = StudioVideoControls.VIDEO_PAUSE;
		}
		
		public function closebuttonClick(e:Event):void
		{
			videoState = StudioVideoControls.VIDEO_CLOSE;
		}
		
		public function onIOErrorHandler(e:IOErrorEvent):void
		{
			
		}
		
		public function soundbuttonClick(e:Event):void
		{
			//exclusive sound button logic
			if(soundState == StudioVideoControls.SOUND_ON)
			{
				soundState = StudioVideoControls.SOUND_OFF;
			}else
			{
				soundState = StudioVideoControls.SOUND_ON;
			}
		}
		
		// UI encapsulation -->
		//************************************
		
		
		
		
		
		
		//************************************
		//<!-- scrubber encapsulation
		public function set scrubberState($scrubberState:String):void
		{
			_scrubberState = $scrubberState;
		}
		public function get scrubberState():String
		{
			return _scrubberState;
		}
		
		public function onScrubberMouseEvent($evt:MouseEvent):void
		{
			//trace("onScrubberMouseEvent()");
			switch($evt.type)
			{
				case MouseEvent.MOUSE_DOWN:
					//videoState = StudioVideoControls.VIDEO_PAUSE;
					//var rectangle:Rectangle = new Rectangle(mcTotalbar.x, mcScrubber.initY, mcTotalbar.width, 0);
					//mcScrubber.startDrag(true,rectangle);
					var rectangle:Rectangle = new Rectangle(_mcScrubberOffsetX, _mcScrubberOffsetY, mcLoadprogressbarWidth, 0);
					_mcScrubber.startDrag(false, rectangle);
					
					initScrubbing();
					
				break;
				case MouseEvent.MOUSE_UP:
					_mcScrubber.stopDrag();
					
					if(scrubberState == StudioVideoControls.SCRUBBER_STARTDRAG)
					{
						//trace("seek video");
						videoState = StudioVideoControls.VIDEO_SEEK;
					}
					
					stopScrubbing();
					
				break;
			}
		}
		
		public function initScrubbing():void
		{
			scrubberState = StudioVideoControls.SCRUBBER_STARTDRAG;
		}
		
		public function stopScrubbing():void
		{
			scrubberState = StudioVideoControls.SCRUBBER_STOPDRAG;
		}
		
		// scrubber encapsulation -->
		//************************************
		
		
		
		
		
		//************************************
		//<!-- NetConnection, NetStream Handler
		private function securityErrorHandler($evt:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + $evt);
		}
		private function netStatusHandler($evt:NetStatusEvent):void {
			for (var ID:* in $evt.info) {
				//trace("event.info."+ID+" = "+$evt.info[ID]);
			}
			switch ($evt.info.code) {
				case "NetConnection.Connect.Success" :
					//connectStream();
					break;
				case "NetStream.Play.StreamNotFound" :
					trace("Stream not found: " + _videoLink);
					break;
				case "NetStream.Play.Stop" :
					trace("NetStream.Play.Stop:VIDEO STOPS end duration");
					videoState = StudioVideoControls.VIDEO_CLOSE;
					//_dispatcher.doComplete();
					break;
			}
			//event.info.level = status;
			//event.info.code = NetConnection.Connect.Success;
			//event.info.code = NetStream.Play.Start;
			//event.info.code = NetStream.Buffer.Full;
			//event.info.code = NetStream.Buffer.Flush;
			//event.info.code = NetStream.Play.Stop;
			//event.info.code = NetStream.Buffer.Empty;
			//event.info.code = NetStream.Buffer.Flush;
		}
		//important these should be public
		public function onMetaData(info:Object):void {
			trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			_video_duration = Number(info.duration);
		}
		public function onCuePoint(info:Object):void {
			trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		public function onXMPData(info:Object):void {
			trace("XMPData: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		
		public function initBytesNetStream():void
		{
			_bytesNS_Timer = new Timer(250, 0);
			_bytesNS_Timer.addEventListener(TimerEvent.TIMER, HandlerNetStream);
		}
		public function indicateNetStream($valid:Boolean):void
		{
			switch($valid)
			{
				case true:
					_bytesNS_Timer.start();
				break;
				case false:
					_bytesNS_Timer.stop();
				break;
			}
			
		}
		public function HandlerNetStream($e:TimerEvent=null):void
		{
			var ratioLoaded:Number = _netstream.bytesLoaded / _netstream.bytesTotal;
			ratioLoaded = Math.round(ratioLoaded*100)/100;
			drawLoadprogressbar(ratioLoaded);
			//trace("ratioLoaded=",ratioLoaded);
			
			var ratioPlayed:Number = _netstream.time / _video_duration;
			ratioPlayed = Math.round(ratioPlayed*100)/100;
			drawPlayprogressbar(ratioPlayed);
			drawScrubber(ratioPlayed);
			//trace("_netstream.time",_netstream.time);
			//trace("ratioPlayed=",ratioPlayed);
			
		}
		
		
		private function initVideo():void
		{
			//<!-- video player set up
			_video = new Video();
			_video.smoothing = true;
			_mc.addChild(_video);
			// video player set up -->
			
			_netconnection = new NetConnection();
			_netconnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_netconnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_netconnection.connect(null);
		}
		private function displayVideo($valid:Boolean):void
		{
			switch($valid)
			{
				case true:
					_video.visible= true;
				break;
				case false:
					_video.visible = false;
				break;
			}
		}
		
		
		
		private function connectStream():void
		{
			//
			_netstream = new NetStream(_netconnection);
			_netstream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			//<!-- very important to call-back "onMetaData"
			_netstream.client = this;
			// very important to call-back "onMetaData" -->

			
			_video.attachNetStream(_netstream);
			_video.width = _videoWidth;
			_video.height = _videoHeight;
			
			//
			//trace("_videoLink=",_videoLink)
			_netstream.play(videoLink);
			//netstream.pause();
			//netstream.resume();
			
			
			_videoVolumeTransform = new SoundTransform();
			_videoVolumeTransform.volume = volumeNumber;
			_netstream.soundTransform = _videoVolumeTransform;
			
			//volumeOnOff = "on";
			//volumeNumber = .8;
			

			
		}
		
		
			
		// NetConnection, NetStream Handler -->
		//************************************

	}
}