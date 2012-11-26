package com.deepfocus.as3.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class AlgebraGeometryBitmap
	{
		public function AlgebraGeometryBitmap()
		{
		}
		
		public static function sizeAndPlace($pic:MovieClip, $bitmap:Bitmap, $mask:Boolean = true):void
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
			if ($mask)
			{
				diffW				= ($bitmap.width - picWidth) * .5;
				diffH				= ($bitmap.height - picHeight) * .5;
				$bitmap.y			= -diffH;
				$bitmap.x			= -diffW
				
				$pic.removeChildAt(0);
				tobeKilled = null;
				$pic.addChildAt($bitmap, 0);
				$bitmap.mask		= $pic.getChildAt(1);
			}
			else
			{
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
		
		public static function giveBackClone($value:Bitmap):Bitmap
		{
			if (!$value) return null;
			var newBitmapData:BitmapData = $value.bitmapData.clone();
			var bm:Bitmap = new Bitmap(newBitmapData);
			return bm;
		}
		
		public static function copyBitmap($rect:Rectangle, $mc:IBitmapDrawable):Bitmap {
			var bmd:BitmapData = new BitmapData($rect.width * 2, $rect.height * 2);
			bmd.draw($mc);
			var slicebmd:BitmapData = new BitmapData($rect.width, $rect.height);
			slicebmd.copyPixels(bmd, $rect, new Point());
			return new Bitmap(slicebmd);
		}
		

	}
}