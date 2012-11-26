package com.egraphicsNY.as3.events
{
	import flash.events.Event;

	public class VideoControlBarEvent extends Event{
		//type
		public static const	PLAY								:String = 'play';
		public static const	PAUSE								:String = 'pause';
		public static const	RESET								:String = 'reset';
		public static const	FAST_FORWARD						:String = 'fastForward';
		public static const	SOUND_ON							:String = 'soundOn';
		public static const	SOUND_OFF							:String = 'soundOff';
		public static const LOADING								:String = 'loading';
		public static const VOLUME								:String = 'volume';
		public static const VIDEO_POSITION						:String = 'videoPostion';
		public static const VIDEO_SLIDER_POSITION				:String = 'videoSliderPostion';
		public static const THUMBNAIL_VIEWER_BUTTON_CLICK		:String = 'thumbnailViewerButtonClick';
		
		public var value										:Number;
		
		public function VideoControlBarEvent(type:String, $value:Number=undefined, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			value = $value;
		}
		public override function clone():Event{
			return new VideoControlBarEvent(type, value, bubbles, cancelable);
		}
		public override function toString():String{
			return formatToString('VideoControlBarEvent','type', 'value','bubbles', 'cancelable');
		}
	}
}