/*package {
	import com.egraphicsNY.as3.templates.richMedia.RichMediaMainDemo;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class EgraphicsNY extends Sprite{
		
		private var _loader									:Loader;
		
		public function EgraphicsNY(){
			_init();	
		}
		private function _init():void{
			_loader				= new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadComplete,false,0,true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onIOError,false,0,true);		
			_loader.load(new URLRequest('../deploy/richMediaMain.swf'));
		}		
		private function _onIOError($evt:IOErrorEvent):void{
			trace($evt.text);
		}
		private function _onLoadComplete($evt:Event):void{
			var m:RichMediaMainDemo 	= RichMediaMainDemo($evt.target.content);
			addChild(m); 
		}		
	}
}
*/

package {
	import com.egraphicsNY.as3.templates.richMedia.RichMediaMainDemo;
	import com.egraphicsNY.as3.demos.videoplayers.StudioVideoPlayerDemo;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class EgraphicsNY extends Sprite{
		
		private var _loader									:Loader;
		
		public function EgraphicsNY(){
			_init();	
		}
		private function _init():void{
			_loader				= new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadComplete,false,0,true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onIOError,false,0,true);		
			//_loader.load(new URLRequest('../deploy/richMediaMain.swf'));
			_loader.load(new URLRequest('../deploy/demos/display/videoplayers/StudioVideoPlayerDemo.swf'));
			//_loader.load(new URLRequest('../deploy/StudioVideoPlayerDemo.swf'));
		}		
		private function _onIOError($evt:IOErrorEvent):void{
			trace($evt.text);
		}
		private function _onLoadComplete($evt:Event):void{
			var m:StudioVideoPlayerDemo 	= StudioVideoPlayerDemo($evt.target.content);
			m.linkDeployValid();
			addChild(m); 
		}		
	}
}