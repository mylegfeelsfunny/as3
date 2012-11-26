package com.office365.view.ui.pickers.event
{
	import flash.events.Event;
	
	public class PickerEvent extends Event
	{
		public static const SELECTED							:String = 'selected';
		public static const SELECTION_FINISHED					:String = 'selection_finished';
		public static const REMOVE_SELECTED						:String = 'remoce_selectedd';
		
		public var data:Object;
		public function PickerEvent(type:String, $data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = $data;
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event{
			return new PickerEvent(type, data, bubbles, cancelable);
		}

	}
}