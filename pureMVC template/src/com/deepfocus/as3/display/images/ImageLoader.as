
package com.deepfocus.as3.display.images{
	
		/*-------------------------------IMPORTS-------------------------------*/
	import com.greensock.TweenLite;
	import com.deepfocus.as3.display.layout.Orientation;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	
	/**
	 * ImageLoader allows the developer to load an image by passing a URL either in the constructor or in the loadImage method.
	 * One can also set maximum values for height and width that, if exceeded, will cause the loaded image to auto-resize.
	 * **/ 
	public class ImageLoader extends Sprite{
		
		
		/*-------------------------------VARS-------------------------------*/
		
		/** If greater than 0, will fade image/SWF in. Otherwise, image/SWF will appear once loaded. */
		private var _fadeTime:Number;
		protected var _fileUrl:String;	//path to image/SWF to be loaded
		
		/** The path to image/SWF to be loaded */
		protected var _percentLoaded:Number;
		
		//POSITIONING VARS
		/** img will scale down if larger */
		private var _maxWidth:Number;
		/** img will scale down if larger */
		private var _maxHeight:Number;
		/** The maximum allowable difference between dimension and maxDimension.
		 * <p>That is, where edgePad == 5., a _loadr with a width of over 
		 * (_maxWidth - 5) would be scaled down. </p>*/
		private var edgePad:Number;
		/** Boolean value representing whether asset will be centered after scaling to fit max bounds. */
		protected var _autoCenter:Boolean = false;
		
		/** Boolean value representing whether file loaded is a SWF or (presumably) an image */
		protected var _isSWF:Boolean;
		
		//DISPLAY LIST
		/** The loader that will house the image/SWF */
		protected var _loadr:Loader;
		/** The Bitmap that will house a dupe of the original loaded file -- only if it's not a SWF. */
		protected var _loaderBt:Bitmap;
		/** A reference to the preloader associated with this ImageLoader, where applicable. */
		protected var _preloader:AbstractPreloader;
		
		//ORIENTATION VARS
		protected var _orientation:String;
		
		public function get bitmap():Bitmap {
			return 	Bitmap(_loadr.content); 
		}

		
		//EVENTS
		public static const LOAD_ERROR:String = 'loadError';
		
		/*-------------------------------CONSTRUCTOR-------------------------------*/
		public function ImageLoader(url:String=null, time:Number=0){
			_loadr = new Loader();
			_loaderBt = new Bitmap();
			_fadeTime = time;
			
			if(url != null)		loadImage(url, time);	//load image/swf
		}
		
		
		/*-------------------------------FUNC-------------------------------*/
		
		/*Sets the image load in motion, if the URL wasn't supplied in the constructor.*/
		public function loadImage(url:String, time:Number=0, context:LoaderContext=null):void{
			var req:URLRequest = new URLRequest(url);
			_fileUrl = url;
			if(isNaN(_fadeTime))		_fadeTime = time;
			
			//are we loading a SWF?
			//approach is kinda inelegant, I know...
			if(_fileUrl.toLowerCase().indexOf('.swf') > -1)		_isSWF = true;
			else												_isSWF = false;
			
			//if _fadeTime == 0, image appears immediately onLoad.
			//otherwise, it fades in
			_loaderBt.smoothing = true;
			if(_fadeTime < 0)		throw new Error("ImgLoad cannot have negative fade-in time");
			else if(_fadeTime != 0)	asset.alpha = 0;
			
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = true;
			
			_loadr.contentLoaderInfo.addEventListener(Event.OPEN, onStartLoad, false, 0, true);
			_loadr.contentLoaderInfo.addEventListener(Event.INIT, onLoadInit, false, 0, true);
			_loadr.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoaded, false, 0, true);
			_loadr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProg, false, 0, true);
			_loadr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			_loadr.load(req, loaderContext);
		}
		
		
		/*Triggered once image load is complete.*/
		protected function afterImgLoad():void{
			//overrided by subclasses;
		}
		
		
		/*Handle any image resizes necessitated by _maxWidth or _maxHeight.*/
		protected function formatImg():void{
			//resize, if necessary
			asset.scaleY = asset.scaleX = 1;
			
			
			//DEFINE ORIENTATION
			if(asset.width > asset.height)			_orientation = Orientation.LANDSCAPE;
			else if(asset.height == asset.width)	_orientation = Orientation.SQUARE;
			else if(asset.height > asset.width)		_orientation = Orientation.PORTRAIT;
			
			
			//if edgePad is undefined, set to 0
			if(isNaN(edgePad))		edgePad = 0;
			
			//adjust sizing, as defined by maxBounds
			scaleToHeight();
			scaleToWidth();
			if(!_isSWF)		setBitmap(_loaderBt.width, _loaderBt.height);
			
			
			if(!_autoCenter)			return;
			
			//now, position img
			if(!isNaN(_maxWidth))		asset.x = (_maxWidth - asset.width)/2;
			if(!isNaN(_maxHeight))		asset.y = (_maxHeight - asset.height)/2;
		}
		
		
		/** Draws a bitmap duplicate of the image.*/
		public function setBitmap(wid:Number=NaN, ht:Number=NaN):void{
			var matrix:Matrix = new Matrix(1,0,0,1);
			var btWidth:Number = _loadr.width;
			var btHeight:Number = _loadr.height;
			var bt:BitmapData;
			
			if(!isNaN(wid + ht)){
				matrix.a = wid / _loadr.width;
				matrix.d = ht / _loadr.height;
				btWidth = wid;
				btHeight = ht;
			}
			
			bt = new BitmapData(btWidth, btHeight, true, 0xff0000);
			_loaderBt.scaleX = _loaderBt.scaleY = 1;
			
			if(_loaderBt.bitmapData){
				_loaderBt.bitmapData.dispose();
				_loaderBt.bitmapData = null;
			}
			_loaderBt.bitmapData = bt;
			_loaderBt.smoothing = true;
			
			bt.draw(_loadr, matrix);
		}
		
		/** Clears the current asset from view. */
		public function clear():void{
			asset.alpha = 0.5;
			if(_isSWF)		unload();
			else{
				if(_loaderBt.bitmapData)	_loaderBt.bitmapData.dispose();
				_loaderBt.bitmapData = null;
			}
		}
		
		
		/** Scales the image to accomodate the _maxWidth value provided.
		 * <p>Resizes the image with respect to width, and makes a corresponding change to
		 * height. However, this is executed only if _maxWidth is greater than the image's original width.
		 * The image is only ever scaled down -- it is never enlarged.*/
		private function scaleToWidth():void{
			if(_maxWidth < asset.width){
				asset.width = _maxWidth - edgePad;
				asset.scaleY = asset.scaleX;
			}
		}
		
		/** Scales the image to accomodate the _maxHeight value provided.
		 * <p>Resizes the image with respect to height, and makes a corresponding change to
		 * width. However, this is executed only if _maxWidth is greater than the image's original height.
		 * The image is only ever scaled down -- it is never enlarged.*/
		private function scaleToHeight():void{
			if(_maxHeight < asset.height){
				asset.height = _maxHeight - edgePad;
				asset.scaleX = asset.scaleY;
			}
		}
		
		/** Unloads image/SWF.*/
		public function unload():void{
			try{_loadr.unloadAndStop()}
			catch(e:*){	};
		}
		
		
		/** Interrupts any loads in progress.*/
		public function stopLoad():void{
			try{_loadr.close();}
			catch(e:*){	}
		}
		
		
		private function postLoad():void{
			if(! _isSWF)	setBitmap();
			
			formatImg(); //scale & position img
			
			addChild(asset);
			_loadr.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImgLoaded, false);
			_loadr.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProg, false);
			_loadr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError, false);
			
			if(_fadeTime > 0){
				asset.alpha = 0;
				TweenLite.to(asset, _fadeTime, {alpha:1});
			}else{
				asset.alpha = 1;
			}
		}
		
		public function destroy():void{
			try{
				_loadr.contentLoaderInfo.removeEventListener(Event.OPEN, onStartLoad, false);
				_loadr.contentLoaderInfo.removeEventListener(Event.INIT, onLoadInit, false);
				_loadr.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImgLoaded, false);
				_loadr.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProg, false);
				_loadr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError, false);
			}
			catch(e:*){	}
			
			try{_loadr.close();}
			catch(e:*){	}
			
			try{
				_loaderBt.bitmapData.dispose();
				_loaderBt.bitmapData = null;
			}
			catch(e:*){	}
			
			clear();
			this.mask = null;
			_preloader = null;
		}
		
		
		
		//GET AND SET
		
		/** Sets the dimentional bounds within which a loaded asset must fit. */
		public function set maxBounds(bnds:Object):void{
			//handle crazy padding
			if((bnds.padding > bnds.width/2) || (bnds.padding > bnds.height/2)){
				throw new Error("Padding cannot be greater than _maxWidth/2 or _maxHeight/2");
			}
			
			_maxWidth = _maxHeight = NaN;
			
			_maxWidth = bnds.width;
			_maxHeight = bnds.height;
			edgePad = bnds.padding;
			if(_percentLoaded >= 100)	formatImg();
		}
		/** @private */
		public function get maxBounds():Object{
			return {width:_maxWidth, height:_maxHeight, padding:edgePad};
		}
		
		/** Sets an association with an AbstractPreloader object. */
		public function set preloader(mc:AbstractPreloader):void{
			_preloader = mc;
		}		
		/** Returns a reference to any AbstractPreloader object associated with this ImageLoader object. */
		public function get preloader():AbstractPreloader{
			return _preloader;
		}
		
		/** Determines whether asset will be centered after scaling to fit max bounds. */
		public function set autoCenter(val:Boolean):void{
			_autoCenter = val;
			formatImg();
		}
		
		/** Returns the asset's load progress as a percentage. */
		public function get percentLoaded():Number{
			return _percentLoaded;
		}
		
		/** Returns the url from which asset was loaded. */
		public function get url():String{
			return _fileUrl;
		}
		
		/** Returns the asset's orientation. */
		public function get orientation():String{
			return _orientation;
		}
		
		/** Returns the horizontal offset applied to a resized asset durring maxBounds application. */
		public function get xOffset():Number{
			return asset.x;
		}
		
		/** Returns the vertical offset applied to a resized asset durring maxBounds application. */
		public function get yOffset():Number{
			return asset.y;
		}
		
		/** Returns a Boolean value stating whether asset being loaded is a SWF. */
		public function get isSWF():Boolean{
			return _isSWF;
		}
		
		/** Returns the the DisplayObject used (_loadr for SWFS, _loaderBt for images. */
		public function get asset():*{
			var img:DisplayObject;
			if(_isSWF)			img = _loadr;
			else				img = _loaderBt;
			
			return img;
		}
		
		/** Returns the the SWF being loaded, giving direct access to its timeline, classes, etc. */
		public function get assetSWF():*{
			if(_isSWF)			return asset.content;
			else 				return null;
		}
		
		
		
		/*-------------------------------EVENT-------------------------------*/
		
		protected function onStartLoad(e:Event):void{
			_percentLoaded = 0;
			if(_preloader)		_preloader.initFormat();
			dispatchEvent(new Event(Event.OPEN));
			_loadr.contentLoaderInfo.removeEventListener(Event.OPEN, onStartLoad, false);
		}
		
		protected function onLoadProg(e:ProgressEvent):void{
			var pct:Number = Math.round(e.target.bytesLoaded/e.target.bytesTotal * 100);
			_percentLoaded = pct;
			if(_preloader)		_preloader.updateFormat(pct);
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}
		
		protected function onLoadInit(e:Event):void{
			dispatchEvent(new Event(Event.INIT));
			_loadr.contentLoaderInfo.removeEventListener(Event.INIT, onStartLoad, false);
		}
		
		protected function onImgLoaded(e:Event):void{
			postLoad();
			
			dispatchEvent(new Event(Event.COMPLETE));
			afterImgLoad();
			if(_preloader)		_preloader.completeFormat();
		}
		
		protected function onError(e:IOErrorEvent):void{
			trace("Image Loader eRRROR "+e);
			
			/*if(e.text.indexOf('#2124') > -1){
				afterImgLoad();
				if(_preloader)		_preloader.completeFormat();
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else{
				dispatchEvent(new Event(LOAD_ERROR));
			}*/
			dispatchEvent(new Event(LOAD_ERROR));
		}
	}
}