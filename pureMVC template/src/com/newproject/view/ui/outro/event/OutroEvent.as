package com.office365.view.ui.outro.event
{
	import flash.events.Event;
	
	public final class OutroEvent extends Event
	{
		
		public static const LOADED:String = "loaded";
		public static const ANIMATION_FINISHED:String = "animation_finished";
		public static const SOUNDBUTTON:String = "soundbutton";
		
		public var body:Object;
		
		public function OutroEvent(type:String, $body:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			body = $body;
			super(type, bubbles, cancelable);
		}
	}
}