package com.egraphicsNY.as3.templates.richMedia{
	import com.egraphicsNY.as3.display.video.youtube.YouTubeChromelessVideoPlayer;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public final class RichMediaAssetManagerDemo extends RichMediaAssetManager{
				
		public function RichMediaAssetManagerDemo($mc:MovieClip, $contentXML:XML){
			super($mc, $contentXML);
		}
		override protected function _init($evt:Event):void{
			super._init($evt);
		}
	}
}