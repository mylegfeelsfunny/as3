package com.deepfocus.as3.events{
	import flash.events.Event;

	public class XMLLoaderEvent extends Event{
		
		//CONSTANTS
		public static const	LOAD_COMPLETE												:String = 'loadComplete';
		
		//vars
		public var data																	:XML;
		
		public function XMLLoaderEvent(type:String, $data:XML,bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			data	= $data;
		}	
		public override function clone():Event{
			return new XMLLoaderEvent(type, data, bubbles, cancelable)
		}
		public override function toString():String{
			return formatToString('XMLLoaderEvent','type', 'data', 'bubbles', 'cancelable');
		}
	}
}