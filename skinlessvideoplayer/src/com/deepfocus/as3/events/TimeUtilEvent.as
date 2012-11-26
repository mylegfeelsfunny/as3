package com.deepfocus.as3.events
{
	import flash.events.Event;

	public class TimeUtilEvent extends Event
	{
		public static const	CLOCK_UPDATE						:String = "clock_update";
		public static const	COUNTDOWN_SINGLEUNIT_UPDATE			:String = "countdown_singleunit_update";
		public static const	COUNTDOWN_UPDATE					:String = "countdown_update";
		public static const	COUNTDOWN_SINGLEUNIT_COMPLETE		:String = "countdown_singleunit_complete";
		public static const	COUNTDOWN_COMPLETE					:String = "countdown_complete";
		
		public var clockValue									:String;
		public var countDownValue								:String;
		public var countDownValueObject							:Object;
		
		public function TimeUtilEvent(type:String, $clockValue:String = '', $countDownValue:String = '', $countDownValueObject:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			clockValue 											= $clockValue;
			countDownValue 										= $countDownValue;
			countDownValueObject								= $countDownValueObject;
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new TimeUtilEvent(type, clockValue, countDownValue, countDownValueObject, bubbles, cancelable);
		}
		
	}
}