package com.deepfocus.as3.templates.microsite.events{
	import flash.events.Event;
	
	public final class LoaderEvent extends Event{
		
		public static const	ON_LOADER_PROGRESS												:String = "onLoaderProgress";

		

		public var bytesLoaded																:uint;
		public var bytesTotal																:uint;
		public var loadPercent																:Number;

		
		public function LoaderEvent(type:String, $bytesLoaded:uint, $bytesTotal:uint, $loadPercent:Number, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			bytesLoaded 	= $bytesLoaded;
			bytesTotal		= $bytesTotal;
			loadPercent		= $loadPercent;
		}
		public override function clone():Event{
			return new LoaderEvent(type, bytesLoaded, bytesTotal, loadPercent, bubbles, cancelable);
		}
		public override function toString():String{
			return formatToString("LoaderEvent","type", "bytesLoaded", "bytesTotal", "loadPercent", "bubbles", "cancelable");
		}
	}
}