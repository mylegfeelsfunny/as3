package com.deepfocus.as3.templates.microsite{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class AbstractAssetManager extends Sprite{
		
		protected var  _mc											:MovieClip;
		protected var _xml											:XML;
		protected var _paramObj										:Object;

		public function AbstractAssetManager($mc:MovieClip,$contentXML:XML,$paramObj:Object=null){
			addEventListener(Event.ADDED_TO_STAGE,_init,false,0,true);
			_mc						= $mc;
			_xml					= $contentXML;
			_paramObj				= $paramObj;
		}
		
		public function get xml():XML { return _xml; }
		public function get mc():MovieClip { return _mc; }
		public function get paramObj():Object { return _paramObj; }
		public function set paramObj(value:Object):void { _paramObj = value;  }
		
		protected function _init($evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,_init);
			addChild(_mc);	
			startSite();
		}
		
		public function startSite():void{
			trace(this, "startSite() + AbstractAssetManager");	
		}
	}
}