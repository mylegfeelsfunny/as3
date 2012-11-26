package com.deepfocus.as3.display.video.dfvideoplayer.events
{	
	import flash.events.Event;
	
	public class VideoControllerEvent extends Event{
		
		public static const VIDEO_RESUME														:String = 'video_resume';
		public static const VIDEO_PAUSE															:String = 'video_pause';
		public static const VIDEO_OVER															:String = 'video_over';
		public static const VIDEO_INIT_SCRUBBING												:String = 'video_init_scrubbing';
		public static const VIDEO_SCRUB_POSITION												:String = 'video_scrub_position';
		public static const VIDEO_END_SCRUBBING													:String = 'video_end_scrubbing';
		public static const VIDEO_SOUND_TRANSFORM												:String = 'video_sound_transform';
		public static const VIDEO_CUE_POINT														:String = 'video_cue_point';
		public static const FULLSCREEN															:String = 'full_screen';
		public static const CONNECTION_MADE														:String = "connection_made";
		public static const INVALID_TIME														:String = "invalid_time";
		
		public var percent																		:Number;
		public var cuePoint																		:String;
		
		public function VideoControllerEvent(type:String, $percent:Number=undefined, $cuePoint:String = "", bubbles:Boolean=false, cancelable:Boolean=false){
			percent	= $percent;
			cuePoint	= $cuePoint;
			super(type, bubbles, cancelable);
		}
		public override function clone():Event{
			return new VideoControllerEvent(type, percent, cuePoint, bubbles, cancelable);
		}
		public override function toString():String{
			return formatToString('VideoControlEvent','type', 'position', 'bubbles', 'cancelable');
		}
	}
}