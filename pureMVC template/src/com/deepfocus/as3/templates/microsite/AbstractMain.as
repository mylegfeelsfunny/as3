﻿package com.deepfocus.as3.templates.microsite{	/*	 * 		this class loads in a assets swf, and optional exml and passes them to Asset manager		which this class also instantiates. to imploment supclass this clas and pass the swf and 		xml locations to the super. if you do not supply an xml it will not try to load it. ex:				package com.egraphicsNY.as3.templates.microsite{			public class Main extends AbstractMain{				public function Main(){					super('swf/assets.swf','xml/content.xml');	//,'xml/content.xml'				}							}		}				you can override _initAssetManager() to instatiate a subClass of AssetManager		*/	import com.deepfocus.as3.templates.microsite.events.LoaderCompleteEvent;	import com.deepfocus.as3.templates.microsite.events.LoaderEvent;		import flash.display.Loader;	import flash.display.LoaderInfo;	import flash.display.MovieClip;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;	import flash.events.HTTPStatusEvent;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.events.SecurityErrorEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.system.ApplicationDomain;	import flash.system.LoaderContext;	import flash.utils.getQualifiedClassName;	import flash.utils.getQualifiedSuperclassName;		public class AbstractMain extends MovieClip{				protected var _assetsManager										:AbstractAssetManager;		protected var _xml													:XML;		protected var _loader												:Loader;		protected var _paramObj												:Object;		private var _urlLoader												:URLLoader;			private var _swfPath												:String;		private var _xmlPath												:String;		private var _usingLoader											:Boolean;			private static var  _PATH											:String;		public static var USING_LOADER_FLAG									:Boolean;				public function AbstractMain($swfPath:String,$xmlPath:String=null){			_swfPath	= $swfPath;			_xmlPath	= $xmlPath;			addEventListener(Event.ADDED_TO_STAGE,_init,false,0,true);			}				//--------------------------------------------------------------------------		//  ACCESSORS		//--------------------------------------------------------------------------		public static function set PATH($path:String):void{ if(!_PATH) _PATH = $path;}		public static function get PATH():String{ return _PATH;}		public function get paramObj():Object { return _paramObj; }		public function set paramObj(value:Object):void { _paramObj = value;  }		public function set usingLoader($value:Boolean):void{ _usingLoader = $value;}				//--------------------------------------------------------------------------		//  INIT		//--------------------------------------------------------------------------				protected function _init($evt:Event):void{			removeEventListener(Event.ADDED_TO_STAGE,_init);						var classPath:String 	= getQualifiedSuperclassName(parent);			var classPathList:Array	= classPath.split("::");			var className:String	= classPathList[classPathList.length-1];			if(className =="AbstractLoader"){				USING_LOADER_FLAG	= true;				parent.addEventListener(Event.COMPLETE,_startSite,false,0,true);			}						var loaderURL:Array = this.loaderInfo.loaderURL.split("/");			var flexFlag:String	= loaderURL[loaderURL.length-2];				AbstractMain.PATH = (flexFlag =="bin-debug") ? "../deploy/" : "";			if(_paramObj != null) {				AbstractMain.PATH = (_paramObj["assetsURL"] != null) ? _paramObj["assetsURL"] : AbstractMain.PATH;			}				_loadXML();		}					//--------------------------------------------------------------------------		//  PUBLIC METHODS		//--------------------------------------------------------------------------				public function initAssetManager():void{			// you may override and imploment a subclass of assetMamager/*			_assetsManager			= new AbstractAssetManager(MovieClip(_loader.contentLoaderInfo.content),_xml);			addChild(_assetsManager);  	 			*/		}				protected function _startSite($evt:Event):void{			//event dispatched from loader if loader is used			_assetsManager.startSite();		}				//--------------------------------------------------------------------------		//  CREATE / DESTROY		//--------------------------------------------------------------------------		private function _loadXML():void{			_urlLoader				= new URLLoader();			_urlLoader.addEventListener(Event.COMPLETE,_onXMLLoaded,false,0,true);			_urlLoader.addEventListener(ProgressEvent.PROGRESS, _onAssetsLoadProgress,false,0,true);			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler,false,0,true);			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatusHandler,false,0,true);			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler,false,0,true);			_urlLoader.load(new URLRequest(AbstractMain.PATH+_xmlPath));						trace(AbstractMain.PATH+_xmlPath)		}			private function _loadAssets():void{			_loader					= new Loader();			var l:LoaderInfo		= _loader.contentLoaderInfo;			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);								l.addEventListener(Event.COMPLETE,_onAssetLoaded,false,0,true);			l.addEventListener(ProgressEvent.PROGRESS, _onAssetsLoadProgress,false,0,true);			l.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler,false,0,true);			l.addEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatusHandler,false,0,true);			l.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler,false,0,true);				_loader.load(new URLRequest(AbstractMain.PATH+_swfPath), loaderContext);				}			//--------------------------------------------------------------------------		//  EVENT HANDLERS		//--------------------------------------------------------------------------		private function _onXMLLoaded($evt:Event):void{			_urlLoader.removeEventListener(Event.COMPLETE,_onXMLLoaded,false);			_urlLoader.removeEventListener(ProgressEvent.PROGRESS, _onAssetsLoadProgress,false);			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler,false);			_urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatusHandler,false);			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler,false);				_xml					= XML($evt.target.data);			_loadAssets();		}				private function _onAssetLoaded($evt:Event):void{			var li:LoaderInfo		= LoaderInfo($evt.target);			li.removeEventListener(Event.COMPLETE,_onAssetLoaded,false);			li.removeEventListener(ProgressEvent.PROGRESS, _onAssetsLoadProgress,false);			li.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler,false);			li.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatusHandler,false);			li.removeEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler,false);			if (_usingLoader) {				dispatchEvent($evt);			} else {				initAssetManager();			}		}			private function _onAssetsLoadProgress($evt:ProgressEvent):void{			switch($evt.target){				case _urlLoader:					dispatchEvent(new LoaderEvent(LoaderEvent.ON_LOADER_PROGRESS,$evt.bytesLoaded, $evt.bytesTotal, AbstractLoader.XML));					break;				case _loader.contentLoaderInfo:					dispatchEvent(new LoaderEvent(LoaderEvent.ON_LOADER_PROGRESS,$evt.bytesLoaded, $evt.bytesTotal, AbstractLoader.ASSETS));					break;			}		}					private function _securityErrorHandler($evt:SecurityErrorEvent):void{			//trace(this, "securityErrorHandler: " + $evt);			}		private function _httpStatusHandler($evt:HTTPStatusEvent):void{			//trace(this, "httpStatusHandler: " + $evt);		}		private function _ioErrorHandler($evt:IOErrorEvent):void{			trace(this, "ioErrorHandler: " + $evt);		}	}}