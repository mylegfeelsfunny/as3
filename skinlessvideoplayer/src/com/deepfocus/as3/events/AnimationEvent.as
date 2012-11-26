package com.deepfocus.as3.events{
	import flash.events.Event;

	public class AnimationEvent extends Event{
		
		public static var ANIMATE_IN_START						:String = "animateInStart";
		public static var ANIMATE_IN_FINISHED					:String = "animateInFinished";
		public static var ANIMATE_OUT_START						:String = "animateOutStart";
		public static var ANIMATE_OUT_FINISHED					:String = "animateOutFinished";
		public static var ANIMATE_STEP							:String = "animateStep";
		
		public var	id											:Object;	
		
		public function AnimationEvent($type:String, $id:Object=null,$bubbles:Boolean=false, $cancelable:Boolean=false){
			super($type, $bubbles, $cancelable);
			id = $id;
		}
		override public function clone() : Event {
			return new AnimationEvent(type, id, bubbles, cancelable);
		}
	}
}