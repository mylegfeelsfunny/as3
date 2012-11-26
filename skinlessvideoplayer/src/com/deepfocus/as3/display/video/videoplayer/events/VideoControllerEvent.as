﻿package com.deepfocus.as3.display.video.videoplayer.events{		import flash.events.Event;		public class VideoControllerEvent extends Event{				public static const RESUME																:String = 'resume';		public static const PAUSE																:String = 'pause';		public static const VIDEO_OVER															:String = 'video_over';		public static const VOLUME_CHANGE														:String = 'volume_change';		public static const INIT_DATA															:String = 'init_data';		public static const INIT_SCRUBBING														:String = 'init_scrubbing';		public static const SCUB_CHANGE															:String = 'scrub_change';		public static const END_SCRUBBING														:String = 'end_scrubbing';		public static const VIDEO_CUE_POINT														:String = 'video_cue_point';		public static const FULLSCREEN															:String = 'full_screen';		public static const CONNECTION_MADE														:String = "connection_made";		public static const INVALID_TIME														:String = "invalid_time";				public var videoData																	:Object;				public function VideoControllerEvent(type:String, $videoData:Object = null, bubbles:Boolean=false, cancelable:Boolean=false){			videoData	= $videoData;			super(type, bubbles, cancelable);		}		public override function clone():Event{			return new VideoControllerEvent(type, videoData, bubbles, cancelable);		}		public override function toString():String{			return formatToString('VideoControlEvent','videoData', 'bubbles', 'cancelable');		}	}}