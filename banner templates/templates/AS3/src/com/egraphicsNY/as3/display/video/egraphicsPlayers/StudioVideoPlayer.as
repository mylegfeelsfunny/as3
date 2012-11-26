/**
* @author: Won C. Lee
* @Contact: woncheol.lee@tbwachiat.com
* @version: TBD
* @Tech: Actionscript3
*/

package com.egraphicsNY.as3.display.video.egraphicsPlayers
{
	import com.bigspaceship.utils.Out;
	import com.egraphicsNY.as3.display.video.videocontrols.StudioVideoControls;
	import com.egraphicsNY.as3.events.StudioVideoControlsEvent;
	
	import flash.display.MovieClip;
	
	public class StudioVideoPlayer extends MovieClip
	{
		protected var vpcontrols:StudioVideoControls;
		protected var _controlMC:MovieClip;
		//public var player:Object;
		protected var playerW:Number;
		protected var playerH:Number;
		protected var _videoLink:String;
		//public var vidId:String;
		//public var loader:Loader;
		//public var loadComplete:Boolean;
		//public var controlURL:String;
		protected var controlHeight:Number;
		//public var _contextMenu:ContextMenu;
		
		public function StudioVideoPlayer($videoLink:String, $width:Number, $height:Number, $controlMC:MovieClip, $control_height:Number=30)
		{
			_videoLink = $videoLink;
			_controlMC = $controlMC;
			
			playerW = $width;
			playerH = $height;
			
			controlHeight = $control_height;
			//
			init();
		}
		protected function init():void
		{
			//vpcontrols = new VideoControls(controlURL, playerW, controlHeight);
			var vpcontrolsObject:Object = {mc:_controlMC, videoWidth:playerW, videoHeight:playerH, controlHeight:controlHeight} 
			vpcontrols = new StudioVideoControls(vpcontrolsObject);
			vpcontrols.addEventListener(StudioVideoControlsEvent.VIDEO_PLAY, studioVideoControlsHandler);
			vpcontrols.addEventListener(StudioVideoControlsEvent.VIDEO_PAUSE, studioVideoControlsHandler);
			vpcontrols.addEventListener(StudioVideoControlsEvent.VIDEO_RESUME, studioVideoControlsHandler);
			vpcontrols.addEventListener(StudioVideoControlsEvent.VIDEO_CLOSE, studioVideoControlsHandler);
			addChild(vpcontrols);
			//
			playVideo();
			//
		}
		protected function playVideo():void
		{
			vpcontrols.videoLink = _videoLink;
			vpcontrols.videoState = StudioVideoControls.VIDEO_PLAY;
		}
		
		public function studioVideoControlsHandler(e:StudioVideoControlsEvent=null):void
		{
			Out.debug(this, e.type);
			//trace("**studioVideoControlsHandler()",e.type);
		}
			

	}
}