package com.deepfocus.as3.templates.microsite{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class AbstractAssetManager extends Sprite{
		
		protected var  _mc													:MovieClip;
		protected var _contentXML											:XML;
	
		public function AbstractAssetManager($mc:MovieClip,$contentXML:XML){
			addEventListener(Event.ADDED_TO_STAGE,_init,false,0,true);
			_mc						= $mc;
			_contentXML				= $contentXML;
		}
		protected function _init($evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,_init);
			addChild(_mc);	
			if(!AbstractMain.USING_LOADER_FLAG) startSite();
		}		
		public function startSite():void{
			trace(this, "startSite()");	
		}
	}
}