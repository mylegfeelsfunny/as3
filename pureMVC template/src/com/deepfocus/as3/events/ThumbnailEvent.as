package com.deepfocus.as3.events{
	import flash.events.Event;

	public class ThumbnailEvent extends Event{
		
		//type
		public static const ITEM_CHOOSEN				:String = 'itemChoosen';
		public static const ITEM_CHOOSEN_EXTERNALLY		:String = 'itemChoosenExternally';
		
		//var
		public var id									:int;
		
		public function ThumbnailEvent(type:String, $id:int, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			id		= $id;
		}
		public override function clone():Event{
			return new ThumbnailEvent(type, id, bubbles, cancelable)
		}
		public override function toString():String{
			return formatToString('ThumbnailEvent','type', 'id', 'bubbles', 'cancelable');
		}
	}
}