package com.deepfocus.as3.events{
	import flash.events.Event;
	
	public class SliderEvent extends Event{
		
		public static const ON_STEP					:String = 'on_step';
	
		public var position							:Number;
	
		public function SliderEvent(type:String, $position:Number,bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			position = $position;
		}
		public override function clone():Event{
			return new SliderEvent(type, position,bubbles, cancelable);
		}
	}
}