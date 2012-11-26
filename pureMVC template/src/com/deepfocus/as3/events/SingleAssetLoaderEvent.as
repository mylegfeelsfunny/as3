package com.deepfocus.as3.events{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class SingleAssetLoaderEvent extends Event{
		
		//CONSTANTS
		public static const	LOAD_COMPLETE												:String = 'loadComplete';
		
		//vars
		public var asset																	:DisplayObject;
		
		public function SingleAssetLoaderEvent(type:String, $asset:DisplayObject,bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			asset	= $asset;
		}	
		public override function clone():Event{
			return new SingleAssetLoaderEvent(type, asset, bubbles, cancelable)
		}
		public override function toString():String{
			return formatToString('XMLLoaderEvent','type', 'asset', 'bubbles', 'cancelable');
		}
	}
}