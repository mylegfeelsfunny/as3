package com.egraphicsNY.as3.templates.richMedia{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class RichMediaAssetManager extends Sprite{
		
		 protected var  _mc													:MovieClip;
		 protected var _contentXML											:XML;		

		public function RichMediaAssetManager($mc:MovieClip,$contentXML:XML){
			addEventListener(Event.ADDED_TO_STAGE,_init,false,0,true);
			_mc						= $mc;
			_contentXML				= $contentXML;
		}
		protected function _init($evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,_init);
			addChild(_mc);	
		}	
	}
}