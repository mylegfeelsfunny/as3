package com.office365.view.ui.pickers.contactpicker.ui
{
	import com.deepfocus.as3.utils.TextUtils;
	import com.office365.model.DataCacheProxy;
	import com.office365.view.ui.pickers.event.PickerEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	public class ContactSelection extends Sprite
	{
		private var _mc:MovieClip;
		private var _id:int;
		private var _data:Object;
		private var _loader:Loader;
		private var _bitmap:Bitmap;
		
		public function ContactSelection($mc:MovieClip, $data:Object)
		{
			_mc = $mc;
			_data = $data;
			_init();
		}
		
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------
		public function get mc():MovieClip { return _mc; }
		public function get id():int { return _id; }
		public function set id($value:int):void { _id = $value; }
		
		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		private function _init():void
		{
			//trace(this, "_init" );
			_mc.addEventListener(Event.REMOVED_FROM_STAGE, _kill, false, 0, true);
			this.addChild(_mc);
			
			TextUtils.enterBoundedText(_mc.firstNameTxt, _data["firstname"], {height:_mc.firstNameTxt.height, width:_mc.firstNameTxt.width}, null);
			TextUtils.enterBoundedText(_mc.lastNameTxt, _data["lastname"], {height:_mc.firstNameTxt.height, width:_mc.firstNameTxt.width}, null);
			
			//_mc.firstNameTxt.text = _data["first-name"];
			//_mc.lastNameTxt.text = _data["last-name"];

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoadComplete,false,0,true);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false,0,true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress,false,0,true);
			_loader.load(new URLRequest(DataCacheProxy.IMAGEPROXY+_data["pictureurl"]));
			
			_mc.closebtn.buttonMode = true;
			_mc.closebtn.useHandCursor = true;
			_mc.closebtn.addEventListener(MouseEvent.CLICK, onRemoveSelectionHandler, false, 0, true);
		}
		
		private function _kill($e:Event):void
		{
			//trace(this, "_kill");
			try {
			_mc.removeEventListener(Event.REMOVED_FROM_STAGE, _kill, false);
			_mc.imgMC.removeChild(_bitmap);
			_mc.removeChild(_mc.imgMC)
			_mc.removeChild(_mc.firstNameTxt)
			_mc.removeChild(_mc.lastNameTxt)
			_bitmap = null;
			_loader = null;
			}catch ($e:Error) {
			
			} 
		}
		
		private function onAssetLoadComplete($e:Event):void{
			//remove xml listeners, init asset manager and pass it asset mc and xml
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onAssetLoadComplete,false);
			_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress,false);
			
			_bitmap = Bitmap(_loader.content); 
			sizeAndPlace(_mc.imgMC, _bitmap);
			
		}
		//loading hellper functions
		private function httpStatusHandler($e:HTTPStatusEvent):void{
			//trace("httpStatusHandler: " + $e);
		}
		private function ioErrorHandler($e:IOErrorEvent):void{
			//trace("ioErrorHandler: " + $e);
		}
		private function onLoadProgress($e:ProgressEvent):void{
			//trace("progressHandler: bytesLoaded=" + $e.bytesLoaded + " bytesTotal=" + $e.bytesTotal);
		}		

		private function onRemoveSelectionHandler($e:MouseEvent):void
		{
			dispatchEvent(new PickerEvent(PickerEvent.REMOVE_SELECTED))
		}

		
		
		//--------------------------------------------------------------------------
		//  Replace movieclip child0 with image of same height and width
		//--------------------------------------------------------------------------
		protected function sizeAndPlace($pic:MovieClip, $bitmap:Bitmap):void
		{
			$bitmap.smoothing						= true;
			var picWidth			:Number			= $pic.getChildAt(0).width;
			var picHeight			:Number			= $pic.getChildAt(0).height;
			var picArea				:Number			= picWidth * picHeight;
			var bitmapArea			:Number			= $bitmap.width * $bitmap.height;
			var scale				:Number;
			var tobeKilled			:DisplayObject 	= $pic.getChildAt(0);
			
			var w					:Number;
			var h					:Number;
			var scaleDir			:String
			var directionH			:String
			var directionW			:String
			if (($bitmap.width - picWidth) > 0) { w = picWidth/$bitmap.width; }
			else { w = $bitmap.width/picWidth; }
			if (($bitmap.height - picHeight) > 0) { h = picHeight/$bitmap.height; }
			else { h = $bitmap.height/picHeight; }
			
			w = picWidth/$bitmap.width;
			h = picHeight/$bitmap.height;
			scale =(h > w) ? h : w;
			
			$bitmap.width = scale * $bitmap.width;
			$bitmap.height = scale * $bitmap.height;
			
			var diffW				:Number;
			var diffH				:Number;

			var sprite			:Sprite			= new Sprite();
			sprite.graphics.beginFill(0x000000);
			sprite.graphics.drawRect(0,0,picWidth,picHeight);
			sprite.graphics.endFill();
			
			
			$pic.removeChildAt(0);
			tobeKilled = null;
			$pic.addChild($bitmap);
			$pic.addChild(sprite);
			
			$bitmap.mask		= sprite;
			diffW				= ($bitmap.width - picWidth) * .5;
			diffH				= ($bitmap.height - picHeight) * .5;
			$bitmap.y = -diffH;
			$bitmap.x = -diffW;
		}
		
	}
}