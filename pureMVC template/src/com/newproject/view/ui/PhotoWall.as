package com.office365.view.ui{
	
	import com.deepfocus.as3.display.images.ImageLoader;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class PhotoWall extends Sprite{
		
		
		/*-------------------------------VARS-------------------------------*/
		
		/** Loads image. */
		private var _img:ImageLoader;
		/** The width of the tile wall. */
		private var _width:Number;
		/** The height of the tile wall. */
		private var _height:Number;
		
		
		/*-------------------------------CONSTRUCTOR-------------------------------*/
		public function PhotoWall(wid:Number, ht:Number, src:String=null){
			_img = new ImageLoader();
			_width = wid;
			_height = ht;
			
			_img.maxBounds = {width:77, height:77};
			
			_img.addEventListener(Event.COMPLETE, onImgLoaded, false, 0, true);
			
			if(src)		loadImage(src);
		}
		
		
		private function loadImage(src:String):void{
			_img.loadImage(src);
		}
		
		public function destroy():void{
			_img.destroy();
		}
		
		
		/*-------------------------------EVENT-------------------------------*/
		
		/** Triggered on image load. Creates image tile. */
		private function onImgLoaded(e:Event):void{
			var grafx:Graphics = graphics;
			
			
			grafx.beginBitmapFill(Bitmap(_img.asset).bitmapData);
			grafx.drawRect(0, 0, _width, _height);
			grafx.endFill();
		}
	}
}