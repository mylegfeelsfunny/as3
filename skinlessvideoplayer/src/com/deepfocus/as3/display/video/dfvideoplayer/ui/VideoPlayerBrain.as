package com.deepfocus.as3.display.video.dfvideoplayer.ui
{
	import com.deepfocus.as3.display.video.dfvideoplayer.DFVideoPlayer;
	import com.deepfocus.as3.display.video.dfvideoplayer.events.VideoControllerEvent;
	import com.deepfocus.as3.utils.TimeUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	public class VideoPlayerBrain extends EventDispatcher
	{
		protected var _video				:Video;
		protected var _path					:String;
		protected var _controls				:VideoControls;
		protected var _netConnection		:NetConnection;
		protected var _videoStream			:NetStream;
		protected var _videoDuration		:Number;
		protected var _scrubTimer			:Timer;
		protected var _timeUtil				:TimeUtil;
		protected var _width				:Number;
		protected var _height				:Number;
		protected var _dimensionsRecieved	:Boolean = false;
		
		public function VideoPlayerBrain($video:Video, $path:String, $controls:VideoControls)
		{
			_video = $video;
			_width = _video.width;
			_height = _video.height;
			_path = $path;
			_controls = $controls;
			_timeUtil = TimeUtil.getInstance();
		}
		
		public function get path():String { return _path; }
		public function set path(value:String):void { _path = value;  }
		
		//--------------------------------------------------------------------------
		// PUBLIC METHODS 
		//--------------------------------------------------------------------------
		
		public function openConnection():void
		{
			_video.alpha = 1;
			_netConnection = new NetConnection();
			_netConnection.connect(null);
			_videoStream = new NetStream(_netConnection);
			_videoStream.client = this;
			_netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			_videoStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
			//_video.smoothing = true;
			_video.attachNetStream(_videoStream);
			_scrubTimer = new Timer(250);
			_scrubTimer.addEventListener(TimerEvent.TIMER, netStreamInfoHandler, false, 0, true);
			_videoStream.play(_path);
		}
		
		public function closeConnection():void
		{
			_netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false);
			_videoStream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false);
			_scrubTimer.removeEventListener(TimerEvent.TIMER, netStreamInfoHandler, false);
			_videoStream.close();
			_videoStream = null;
			_netConnection = null;
			_scrubTimer = null;
			_video.clear();
		}
				
		public function resume():void
		{
			_video.alpha = 1;
			_videoStream.resume();
			indicateNetStream(true);
		}
		
		public function pause():void
		{
			_videoStream.pause();
			indicateNetStream(false);
		}
		
		public function seek($ratio:Number):void
		{
			trace(this, "percent seeker", $ratio);
			_videoStream.seek(_videoDuration * $ratio);	
			_controls.currentTimeValue = _timeUtil.aggregateValueAsTime(_videoStream.time);
		}
		
		public function soundTransform($ratio:Number):void
		{
			var transform:SoundTransform = new SoundTransform();
			transform.volume = $ratio;
			_videoStream.soundTransform = transform;
		}
		
		public function indicateNetStream($valid:Boolean):void
		{
			switch($valid)
			{
				case true:
					_scrubTimer.start();
					break;
				case false:
					_scrubTimer.stop();
					break;
			}
		}
		
		//important these should be public
		public function onMetaData(info:Object):void {
			//	trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			_videoDuration = Number(info.duration);
			_controls.totalTimeValue = _timeUtil.aggregateValueAsTime(_videoDuration);
/*			if (!_dimensionsRecieved) {
				_dimensionsRecieved = true;
				//trace(this, "BEFORE");
				//trace(this, "info.width", info.width);
				//trace(this, "info.height", info.height);
				var scaleX:Number = _video.width/info.width;
				var scaleY:Number = _video.height/info.height;
				var scale:Number =(scaleX < scaleY) ? scaleX : scaleY;
				_video.width = info.width;
				_video.height = info.height;
				_video.width *= scale;
				_video.height *= scale;
				_video.x = (_width * .5) - (_video.width * .5);
				_video.y = (_height * .5) - (_video.height * .5);
				//trace(this, "AFTER");
				//trace(this, "_video.width", _video.width);
				//trace(this, "_video.height", _video.height);
			}
*/		}
		public function onCuePoint(info:Object):void {
			//trace(this, "onCuePoint///////////////////////////////////////" );
			//trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
			dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_CUE_POINT, undefined, info.name.toString()));
		}
		
		public function onXMPData(info:Object):void {
			//trace("XMPData: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		
		public function kill():void
		{
			closeConnection();
			
			if (_scrubTimer) {
				_scrubTimer.stop();
				_scrubTimer = null;
			}
			_timeUtil = null;
			_videoDuration = undefined;
			_path = undefined;
		}

		//--------------------------------------------------------------------------
		// PRIVATE METHODS 
		//--------------------------------------------------------------------------

		protected function netStreamInfoHandler($e:TimerEvent):void
		{
			var ratioLoaded:Number = _videoStream.bytesLoaded / _videoStream.bytesTotal;
			ratioLoaded = Math.round(ratioLoaded*100)/100;
			_controls.setLoadProgressWidth(ratioLoaded);
			
			var ratioPlayed:Number = _videoStream.time/_videoDuration;
			_controls.setScrubberPosition(ratioPlayed);
			_controls.currentTimeValue = _timeUtil.aggregateValueAsTime(_videoStream.time);
		}
		
		private function aggregateAsTime($value:Number):void
		{
			
		}

		//<!-- NetConnection, NetStream Handler
		private function securityErrorHandler($e:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + $e);
		}
		
		private function netStatusHandler($evt:NetStatusEvent):void {
			for (var ID:* in $evt.info) {
				trace("event.info."+ID+" = "+$evt.info.code);
			}
			switch ($evt.info.code) {
				case "NetConnection.Connect.Success" :
					trace("NetConnection.Connect.Success");
					break;
				case "NetStream.Buffer.Full":
					dispatchEvent(new VideoControllerEvent(VideoControllerEvent.CONNECTION_MADE));
					break;
				case "NetStream.Seek.InvalidTime" :
					dispatchEvent(new VideoControllerEvent(VideoControllerEvent.INVALID_TIME));
					break;
				case "NetStream.Play.StreamNotFound" :
					throw new Error("Stream not found: " + _path);
					break;
				case "NetStream.Play.Stop" :
					trace("NetStream.Play.Stop:VIDEO STOPS end duration");
					dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_OVER));
					break;
			}
		}

	}
}