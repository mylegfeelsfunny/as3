package com.office365.view.ui.pickers.overlay.event
{
	import flash.events.Event;
	
	public final class OverlayEvent extends Event
	{
		public static const OVERLAY_ACCEPTED			:String = 'overlay_accepted';
		public static const OVERLAY_DENIED				:String = 'overlay_denied';

		public function OverlayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}