package com.deepfocus.as3.templates.microsite.events{
	import flash.events.Event;
	
	public final class LoaderCompleteEvent extends Event{
		
		public static const	ON_LOADER_FILE_COMPLETE											:String = "onLoaderFileComplete";
		public static const	MAIN_FILE														:String = "mainFile";
		public static const	ASSETS_FILE														:String = "assetsFile";
		public static const	XML_FILE														:String = "xmlFile";
		
		public var file																		:String;
		
		public function LoaderCompleteEvent(type:String, $file:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			file = $file;
		}
		public override function clone():Event{
			return new LoaderCompleteEvent(type, file, bubbles, cancelable);
		}
		public override function toString():String{
			return formatToString("LoaderEvent", "file", "bubbles", "cancelable");
		}		
	}
}