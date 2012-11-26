package{
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	[SWF(backgroundColor="#000")]	

	public class SkinlessVideoPlayer_Flex extends Sprite {
		
		protected const PATH										:String = "videoshell.swf";
		private var _loader											:Loader;	
		
		public function SkinlessVideoPlayer_Flex (){
			loadAssets();
		}
		
		private function loadAssets():void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoadComplete,false,0,true);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false,0,true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress,false,0,true);
			_loader.load(new URLRequest(PATH));
		}
		
		private function onAssetLoadComplete(e:Event):void{
			//remove xml listeners, init asset manager and pass it asset mc and xml
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onAssetLoadComplete,false);
			_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress,false);
			addChild(VideoShell(e.target.content));

		}
		//loading hellper functions
		private function httpStatusHandler(e:HTTPStatusEvent):void{
			//trace("httpStatusHandler: " + e);
		}
		private function ioErrorHandler(e:IOErrorEvent):void{
			//trace("ioErrorHandler: " + e);
		}
		private function onLoadProgress(e:ProgressEvent):void{
			//trace("progressHandler: bytesLoaded=" + e.bytesLoaded + " bytesTotal=" + e.bytesTotal);
		}		
	
	}
}	