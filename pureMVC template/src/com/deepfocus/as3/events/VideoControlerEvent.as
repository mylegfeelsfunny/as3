package com.deepfocus.as3.events
{
	import com.deepfocus.as3.events.VideoControlBarEvent;
	
	import flash.events.Event;

	public class VideoControlerEvent extends Event{
		
		public static const PAUSE_VIDEO															:String = 'pauseVideo';
		public static const RESUME_VIDEO														:String = 'resumeVideo';
		public static const SEEK																:String	= 'seek';
		
		public var position																		:Number;
		
		public function VideoControlerEvent(type:String, $position:Number=undefined,bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			position	= $position;
		}
		public override function clone():Event{
			return new VideoControlBarEvent(type, position, bubbles, cancelable);
		}
		public override function toString():String{
			return formatToString('VideoControlBarEvent','type', 'position', 'bubbles', 'cancelable');
		}
	}
}