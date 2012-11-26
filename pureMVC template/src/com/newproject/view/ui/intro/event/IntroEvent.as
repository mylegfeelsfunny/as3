package com.office365.view.ui.intro.event
{
	import flash.events.Event;
	
	public final class IntroEvent extends Event
	{
		
		public static const INTRO_OVER:String = "intro_over";
		public static const LINK_OUT:String = "link_out";
		public static const LOADED:String = "loaded";
		public static const SOUND_CUE:String = "sound_cue";
		public static const TRACKING:String = "tracking";
		
		public var body:Object;
		
		public function IntroEvent(type:String, $body:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			body = $body;
			super(type, bubbles, cancelable);
		}
	}
}