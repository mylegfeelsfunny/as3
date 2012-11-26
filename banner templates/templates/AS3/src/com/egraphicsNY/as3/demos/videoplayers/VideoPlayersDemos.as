package com.egraphicsNY.as3.demos.videoplayers
{
	import com.egraphicsNY.as3.display.video.youtube.YouTubeChromelessVideoPlayer;
	import com.egraphicsNY.as3.templates.richMedia.RichMediaConstants;
	
	import flash.display.MovieClip;

	public class VideoPlayersDemos extends MovieClip
	{
		//private var _videoPlayer				:YouTubeChromeVideoPlayer;
		private var _videoPlayer				:YouTubeChromelessVideoPlayer;

		public function VideoPlayersDemos()
		{
			super();
			
			//--------------------------------------------------------------------------
 			// players youtubeVideo through the youTube video skin
	        //--------------------------------------------------------------------------
	
 				//_videoPlayer						= new YouTubeChromeVideoPlayer('cqZJJ_3gDis',700,420); //GxJKqe82080 RaVF-3IZwtw liveID:cqZJJ_3gDis
 			
 			
 			//--------------------------------------------------------------------------
		    //	plays a youtubeVideo through the youtube api but your custom playerskin 
		    //
		    //	note: make sure the path to the VideoControls.swf is correct for its location and your application,
		    //		  hardcode it if you have to.
		    //--------------------------------------------------------------------------
 			
		 		_videoPlayer						= new YouTubeChromelessVideoPlayer('cqZJJ_3gDis',700,420, "VideoControls.swf", 30);
							
				addChild(_videoPlayer); 	
		}
			
	}
}