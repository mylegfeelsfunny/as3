package com.deepfocus.as3.events{
	import flash.events.Event;

	public class ImageLoaderEvent extends Event{

		public static const	IMAGE_LOADED						:String = 'imageLoaded';
		public static const	ALL_IMAGES_LOADED					:String = 'allImagesLoaed';
		
		public var totalImages									:int;
		public var currentImage									:int;		
	
		public function ImageLoaderEvent(type:String, $totalImages:int=undefined, $currentImage:int=undefined, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			totalImages 	= $totalImages;
			currentImage	= $currentImage;
		}
		public override function clone():Event{
			return new ImageLoaderEvent(type, totalImages,currentImage,bubbles, cancelable);
		}	
		public override function toString():String{
			return formatToString('ImageLoaderEvent','type','totalImages','currentImage','bubbles', 'cancelable');
		}
	}
}