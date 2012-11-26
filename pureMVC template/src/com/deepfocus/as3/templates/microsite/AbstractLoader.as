﻿package com.deepfocus.as3.templates.microsite{	/*	* This class; 	* loads main, 	* adds itLoaderas a movieclip, 	* listens for loadeLoaderrom main, 	* display loading indicator, 	* calls function on main to start site		*/		import com.deepfocus.as3.events.AnimationEvent;	import com.deepfocus.as3.templates.microsite.events.LoaderEvent;	import com.greensock.TweenNano;	import com.greensock.easing.Strong;		import flash.display.DisplayObject;	import flash.display.Loader;	import flash.display.LoaderInfo;	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.HTTPStatusEvent;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.net.URLRequest;		public class AbstractLoader extends MovieClip{		protected var _loader 										:Loader;			public var loaderView										:MovieClip;		protected var _loaderNumFrames								:int;			protected var _main											:AbstractMain;		protected var _paramObj										:Object;		protected var _totalBytes									:Number		= 0; 		protected var _percent										:Number		= 0; 				private var MAIN_LOAD_WEIGHT								:Number		= 0;		private var ASSET_LOAD_WEIGHT								:Number		= 0;		private var XML_LOAD_WEIGHT									:Number		= 0;		private var _loaded											:Number;			private var MAIN_SWF_NAME									:String;		private var _currenTarget									:String;		public static const	ASSETS									:String = "assets";		public static const	MAIN									:String = "main";		public static const	XML										:String = "xml";				public function AbstractLoader($MAIN_SWF_NAME:String,$MAIN_LOAD_WEIGHT:Number,$ASSET_LOAD_WEIGHT:Number,$XML_LOAD_WEIGHT:Number){			MAIN_SWF_NAME		= $MAIN_SWF_NAME;			MAIN_LOAD_WEIGHT	= $MAIN_LOAD_WEIGHT;			ASSET_LOAD_WEIGHT	= $ASSET_LOAD_WEIGHT;			XML_LOAD_WEIGHT		= $XML_LOAD_WEIGHT;			_init();		}						//--------------------------------------------------------------------------		//  ACCESSORS		//--------------------------------------------------------------------------		public function get paramObj():Object { 			_paramObj = LoaderInfo(this.root.loaderInfo).parameters;			trace(_paramObj)			if (_paramObj['assetsURL'] == undefined) {				_paramObj['assetsURL'] = "";			}			return _paramObj; 		}		public function set paramObj(value:Object):void { _paramObj = value;  }		//--------------------------------------------------------------------------		//  INIT		//--------------------------------------------------------------------------		protected function _init():void{			_currenTarget = MAIN;			_loaded = 0;			_loader= new Loader();			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoadComplete,false,0,true);			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false,0,true);			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress,false,0,true);						// override in super			//_loaderNumFrames = MovieClip(loaderView.symbol).totalFrames;			//loaderView.addEventListener("finished", _onSiteLoaded, false, 0, true);				_totalBytes = MAIN_LOAD_WEIGHT + XML_LOAD_WEIGHT + ASSET_LOAD_WEIGHT;						var loaderURL:Array = this.loaderInfo.loaderURL.split("/");			var flexFlag:String	= loaderURL[loaderURL.length-2];				var path:String		= (flexFlag =="bin-debug") ? "../deploy/" : "";			trace(this, "paramObj['assetsURL']", paramObj['assetsURL']);			trace(this, "path+MAIN_SWF_NAME", paramObj['assetsURL']+MAIN_SWF_NAME);						_loader.load(new URLRequest(paramObj['assetsURL']+MAIN_SWF_NAME));		}				//--------------------------------------------------------------------------		//  PUBLIC METHODS		//--------------------------------------------------------------------------		protected function adjustLoader($value:Number):void		{		}				protected function resize($e:Event):void {		}		//--------------------------------------------------------------------------		//  CREATE / DESTROY		//--------------------------------------------------------------------------				//--------------------------------------------------------------------------		//  EVENT HANDLERS		//--------------------------------------------------------------------------				protected function onAssetLoadComplete(e:Event):void{			//remove xml listeners, init asset manager and pass it asset mc and xml			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onAssetLoadComplete,false);			_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false);			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false);			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress,false);						_main = AbstractMain(_loader.content);						_main.usingLoader = true;			_main.addEventListener(LoaderEvent.ON_LOADER_PROGRESS, _onMainFileLoadProgress,false,0,true);			_main.addEventListener(Event.COMPLETE, _onMainFileComplete,false,0,true);			_main.paramObj = paramObj;			this.addChild(_main);		}				private function _onMainFileLoadProgress($evt:LoaderEvent):void {			_currenTarget = $evt.name;						onLoadProgress(new ProgressEvent(ProgressEvent.PROGRESS, false, false, $evt.bytesLoaded, $evt.bytesTotal));		}				private function onLoadProgress($evt:ProgressEvent):void {			// the amount of bytes that came in this load			//trace(this, _currenTarget, $evt.bytesTotal);				var newBytes:Number = $evt.bytesLoaded - _loaded;						switch (_currenTarget)			{				case MAIN:					_loaded += newBytes;					break;				case XML:					_loaded += MAIN_LOAD_WEIGHT + newBytes;					break;				case ASSETS:					_loaded += MAIN_LOAD_WEIGHT + XML_LOAD_WEIGHT + newBytes;					break;			}						var percent:Number = _loaded / _totalBytes;			adjustLoader(percent);		}				protected function _onMainFileComplete($evt:Event):void		{			if (loaderView) TweenNano.to(loaderView, .5, {alpha:0, ease:Strong.easeOut, overwrite:0, onComplete:killLoader});				_main.initAssetManager();		}				private function killLoader():void		{			try {			removeChild(loaderView);			loaderView = null;			} catch ($e:Error) { trace(this, "$e:error", $e.message);}			_loader = null		}				//loading hellper functions		private function httpStatusHandler(e:HTTPStatusEvent):void{			//trace("httpStatusHandler: " + e);		}		private function ioErrorHandler(e:IOErrorEvent):void{			trace("ioErrorHandler: " + e);		}			}}