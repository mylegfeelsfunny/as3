package com.egraphicsNY.as3.templates.richMedia{
	import com.bigspaceship.utils.Out;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class RichMediaMain extends MovieClip{
		
		protected var _assetsManager											:RichMediaAssetManager;
		protected var _xml														:XML;
		protected var _loader													:Loader;
		protected var _urlLoader												:URLLoader;		
		
		public function RichMediaMain(){
			addEventListener(Event.ADDED_TO_STAGE,_init,false,0,true);
		}
		protected function _init($evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,_init);
			stage.align				= StageAlign.TOP_LEFT;
			stage.scaleMode			= StageScaleMode.NO_SCALE;
			Out.enableAllLevels();
			Out.info(this,'_init()');
			//grabb flash vars here: this.stage.loaderInfo.parameters.[flashVarName]
			RichMediaConstants.PATH 			=  (this.stage.loaderInfo.parameters.path) 	? this.stage.loaderInfo.parameters.path 	: '';
			var p:String = RichMediaConstants.PATH ;
			_loadAssets();
		}			
		protected function _loadAssets():void{
			_loader					= new Loader();
			var l:LoaderInfo		= _loader.contentLoaderInfo;
				l.addEventListener(Event.COMPLETE,_onAssetLoaded,false,0,true);
				l.addEventListener(ProgressEvent.PROGRESS, _onAssetsLoadProgress,false,0,true);
				l.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler,false,0,true);
	            l.addEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatusHandler,false,0,true);
	            l.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler,false,0,true);	
	        // in subclass you must call super._loadAssets(); and then load swf, 
	        // use  RichMediaConstants.PATH to get to root folder
//	        example:  _loader.load(new URLRequest(RichMediaConstants.PATH+'swf/richMediaAssetManger.swf'));		
		}		
		protected function _loadXML():void{
			_urlLoader				= new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE,_onXMLLoaded,false,0,true);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, _onAssetsLoadProgress,false,0,true);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler,false,0,true);
            _urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatusHandler,false,0,true);
            _urlLoader.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler,false,0,true);
           // in subclass you must call super._loadXML(); and then load xml, 
	        // use  RichMediaConstants.PATH to get to root folder
//            example: _urlLoader.load(new URLRequest(RichMediaConstants.PATH+'xml/content.xml'));
		}
		protected function _onAssetLoaded($evt:Event):void{
			var li:LoaderInfo		= LoaderInfo($evt.target);
				li.removeEventListener(Event.COMPLETE,_onAssetLoaded,false);
				li.removeEventListener(ProgressEvent.PROGRESS, _onAssetsLoadProgress,false);
				li.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler,false);
	            li.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatusHandler,false);
	            li.removeEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler,false);
/* 	        if you have an xml to load call    
  			example: _loadXML()	 */
/*   			else call _initAssetManager to finish initing app
  			example: _initAssetManager() */
		}
		protected function _onXMLLoaded($evt:Event):void{
			_urlLoader.removeEventListener(Event.COMPLETE,_onXMLLoaded,false);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS, _onAssetsLoadProgress,false);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler,false);
            _urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatusHandler,false);
            _urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler,false);	
         	_xml					= XML(URLLoader($evt.target).data);
			_initAssetManager();
		}
		protected function _initAssetManager():void{
		//create asset Manager and add as child	
/*            	_assetsManager			= new RichMediaAssetManager(MovieClip(_loader.contentLoaderInfo.content),_xml);
	        addChild(_assetsManager);  	 */		
		}
		protected function _securityErrorHandler($evt:SecurityErrorEvent):void{
			Out.info(this, "securityErrorHandler: " + $evt);	
		}
		protected function _httpStatusHandler($evt:HTTPStatusEvent):void{
			  Out.info(this, "httpStatusHandler: " + $evt);
		}
		protected function _ioErrorHandler($evt:IOErrorEvent):void{
			Out.info(this, "ioErrorHandler: " + $evt);
		}
		protected function _onAssetsLoadProgress($evt:ProgressEvent):void{
			Out.debug(this,'_onAssetsLoadProgress()');
			dispatchEvent($evt);
		}		
	}
}