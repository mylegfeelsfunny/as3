package com.deepfocus.as3.templates.microsite{
	/*
	* This class; 
	* loads main, 
	* adds itLoaderas a movieclip, 
	* listens for loadeLoaderrom main, 
	* display loading indicator, 
	* calls function on main to start site
	
	*/	
	import com.deepfocus.as3.events.AnimationEvent;
	import com.deepfocus.as3.templates.microsite.events.LoaderCompleteEvent;
	import com.deepfocus.as3.templates.microsite.events.LoaderEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	public class AbstractLoader extends MovieClip{
		protected var _loader 										:Loader;	
		public var loaderView										:MovieClip;
		protected var _totalp										:Number		= 0; 
		protected var _percentLoaded								:Number		= 0; 
		
		private var MAIN_LOAD_WEIGHT								:Number		= 0;
		private var ASSET_LOAD_WEIGHT								:Number		= 0;
		private var XML_LOAD_WEIGHT									:Number		= 0;
		private var MAIN_SWF_NAME									:String;									
		
		public function AbstractLoader($MAIN_SWF_NAME:String,$MAIN_LOAD_WEIGHT:Number,$ASSET_LOAD_WEIGHT:Number,$XML_LOAD_WEIGHT:Number){
			MAIN_SWF_NAME		= $MAIN_SWF_NAME;
			MAIN_LOAD_WEIGHT	= $MAIN_LOAD_WEIGHT;
			ASSET_LOAD_WEIGHT	= $ASSET_LOAD_WEIGHT;
			XML_LOAD_WEIGHT		= $XML_LOAD_WEIGHT;
			_init();
		}
		
		public function get percentLoaded():Number { return _percentLoaded; }
		
		private function _init():void{
			_loader= new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoadComplete,false,0,true);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false,0,true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress,false,0,true);
			
			loaderView.addEventListener(AnimationEvent.ANIMATE_OUT_FINISHED, _onSiteLoaded, false, 0, true);	
			
			var loaderURL:Array = this.loaderInfo.loaderURL.split("/");
			var flexFlag:String	= loaderURL[loaderURL.length-2];	
			
			var path:String		= (flexFlag =="bin-debug") ? "../deploy/" : "";
			
			_loader.load(new URLRequest(path+MAIN_SWF_NAME));
		}
		
		protected function onAssetLoadComplete(e:Event):void{
			//remove xml listeners, init asset manager and pass it asset mc and xml
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onAssetLoadComplete,false);
			_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress,false);
			
			var main:MovieClip	= MovieClip(_loader.content);
			_totalp				+= MAIN_LOAD_WEIGHT;
			main.addEventListener(LoaderEvent.ON_LOADER_PROGRESS,_onExternalLoadProgress,false,0,true);
			main.addEventListener(LoaderCompleteEvent.ON_LOADER_FILE_COMPLETE,_onSingleFileLoadComplete,false,0,true);
			
			this.addChild(MovieClip(_loader.content));
		}
		private function _onSingleFileLoadComplete($evt:LoaderCompleteEvent):void{
			switch($evt.file){
				case LoaderCompleteEvent.ASSETS_FILE:
					_totalp	+= ASSET_LOAD_WEIGHT;
					trace(this, "_onSingleFileLoadComplete-"+LoaderCompleteEvent.ASSETS_FILE,_totalp);	
					break;
				case LoaderCompleteEvent.XML_FILE:
					_totalp	+= XML_LOAD_WEIGHT;
					trace(this, "_onSingleFileLoadComplete-"+LoaderCompleteEvent.XML_FILE,_totalp);	
					break;
			}
		}
		
		//loading hellper functions
		private function httpStatusHandler(e:HTTPStatusEvent):void{
			trace("httpStatusHandler: " + e);
		}
		private function ioErrorHandler(e:IOErrorEvent):void{
			trace("ioErrorHandler: " + e);
		}
		private function onLoadProgress($evt:ProgressEvent):void{
			//			listening to main load
			_onExternalLoadProgress(new LoaderEvent(LoaderEvent.ON_LOADER_PROGRESS,$evt.bytesLoaded,$evt.bytesTotal,MAIN_LOAD_WEIGHT))
		}	
		protected function _onExternalLoadProgress($evt:LoaderEvent):void{
			trace("_onExternalLoadProgress: bytesLoaded=" + $evt.bytesLoaded + " bytesTotal=" + $evt.bytesTotal);
			var l:Number			= $evt.bytesLoaded;
			var t:Number			= $evt.bytesTotal;
			var p:Number			= l/t;
			var ft:uint				= loaderView.totalFrames;
			var fc:uint				= loaderView.currentFrame;  // frame complete %
			var fp:Number			= fc/ft;
			
			_percentLoaded			= _totalp +	p * $evt.loadPercent;			
			trace(this, "l",l,"t",t,"p",p,"_totalp",_totalp,"newTotalP",_percentLoaded,"fp",fp);	
			
			if(_percentLoaded > fp){ 	//	p==0 means all loaded
				if (_percentLoaded >= 1) { removeTime(); }
				loaderView.play();
				trace(this, "play");	
			}else{
				loaderView.stop();
				trace(this, "stop");
			}	
			trace("");
		}
		private function _onSiteLoaded($evt:AnimationEvent):void{
			var main:MovieClip	= MovieClip(_loader.content);
			main.removeEventListener(LoaderEvent.ON_LOADER_PROGRESS,_onExternalLoadProgress);
			main.removeEventListener(LoaderCompleteEvent.ON_LOADER_FILE_COMPLETE,_onSingleFileLoadComplete);
			
			_loader 				= null;
			loaderView.removeEventListener(AnimationEvent.ANIMATE_OUT_FINISHED, _onSiteLoaded);
			loaderView.stop();
			loaderView				= null;
			_percentLoaded			= undefined;	
			MAIN_SWF_NAME			= null;
			MAIN_LOAD_WEIGHT		= undefined;
			ASSET_LOAD_WEIGHT		= undefined;
			XML_LOAD_WEIGHT			= undefined;
			
			dispatchEvent(new Event(Event.COMPLETE));
			stage.addChild(MovieClip(main)); //_loader.content == main()
			this.parent.removeChild(this);
		}
		
		protected function removeTime():void{
			// override in super
		}
		
	}
}