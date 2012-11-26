package com.egraphicsNY.as3.templates.richMedia{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public final class RichMediaMainDemo extends RichMediaMain{
		public function RichMediaMainDemo(){
			super();
		}
		override protected function _loadAssets():void{		
			super._loadAssets();
			_loader.load(new URLRequest(RichMediaConstants.PATH+'swf/richMediaAssetManger.swf'));				
		}
		override protected function _onAssetLoaded($evt:Event):void{
			super._onAssetLoaded($evt);
/* 	        if you have an xml to load call    
  			example: _loadXML()	 */
/*   			else call _initAssetManager to finish initing app
  			example: _initAssetManager() */		
  			
  				
			_loadXML();
//			_initAssetManager();
		}
		override protected function _loadXML():void{
			super._loadXML();
			_urlLoader.load(new URLRequest(RichMediaConstants.PATH+'xml/content.xml'));
		}
		protected override function _initAssetManager():void{
			super._initAssetManager();
            _assetsManager			= new RichMediaAssetManagerDemo(MovieClip(_loader.contentLoaderInfo.content),_xml);
	        addChild(_assetsManager);  	 		
		}		
	}
}