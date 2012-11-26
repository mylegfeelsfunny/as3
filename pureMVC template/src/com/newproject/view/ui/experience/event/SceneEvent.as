package com.office365.view.ui.experience.event
{
	import flash.events.Event;
	
	public final class SceneEvent extends Event
	{
		public static const BODY_LOADED							:String = "body_loaded";
		public static const BODY_OVER							:String = "body_over";
		public static const EXPERIENCE_OVER						:String = "experience_over";
		public static const FADE_IN_OUTRO						:String = "fade_in_outro";
		
		public static const SOUND_CUE_EVENT						:String = "sound_cue";
		public static const SAVE_DATA_EVENT						:String = "save_data"
		public static const ADD_LOADER							:String = "add_loader";
		public static const REMOVE_LOADER						:String = "remove_loader";
		public static const PROFANITY_CHECK						:String = "profanity_check";
		public static const TRACKING							:String = "tracking";
		public static const PREP_OUTRO							:String = "prep_outro";
		
		public var data:Object;
		public function SceneEvent(type:String, $data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = $data;
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event{
			return new SceneEvent(type, data, bubbles, cancelable);
		}

	}
}