package com.deepfocus.as3.templates.microsite{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
//TODO	over right below compiler directives in the subclass
	[SWF(width="640", height="480", backgroundColor="#ffffff", frameRate="30")]	
	
	
	public class AbstractFlexProxy extends Sprite{
		
		protected var _loader									:Loader;
		protected var _path										:String 
		
		public function AbstractFlexProxy($path:String){
			trace(this, $path);
			_init($path);
		}
		protected function _init($path:String):void{
			_loader 	= new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoadComplete,false,0,true);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false,0,true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress,false,0,true);

			_loader.load(new URLRequest($path));
		}
		
		protected function onAssetLoadComplete($evt:Event):void{
			//remove xml listeners, init asset manager and pass it asset mc and xml
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onAssetLoadComplete,false);
			_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress,false);
			//TODO:			overide this function, call its super and add this line to init main and add it to the stage addChild(Main($evt.target.content));
		}
		//loading hellper functions
		protected function httpStatusHandler($evt:HTTPStatusEvent):void{
			//trace("httpStatusHandler: " + $evt);
		}
		protected function ioErrorHandler($evt:IOErrorEvent):void{
			trace("ioErrorHandler: " + $evt);
		}
		protected function onLoadProgress($evt:ProgressEvent):void{
			//trace("progressHandler: bytesLoaded=" + $evt.bytesLoaded + " bytesTotal=" + $evt.bytesTotal);
		}		
				
	}
}