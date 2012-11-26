package com.office365.view.ui.outro
{
	import com.deepfocus.as3.display.section.Section;
	import com.deepfocus.as3.display.video.videoplayer.ChromelessVideoPlayer;
	import com.deepfocus.as3.display.video.videoplayer.events.VideoControllerEvent;
	import com.deepfocus.as3.templates.microsite.AbstractMain;
	import com.greensock.TweenNano;
	import com.greensock.easing.Strong;
	import com.office365.ApplicationFacade;
	import com.office365.view.ui.outro.event.OutroEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.sampler.NewObjectSample;
	
	public final class OutroSection extends Section
	{
		private var _data:Object;
		private var _stage:Object;
		private var _videoPlayer:ChromelessVideoPlayer;
		private var _buttonsOverlay:MovieClip;
		private var _heroButton:MovieClip;
		private var _replayButton:MovieClip;
		private var _bkg:MovieClip;
		private var _titles:MovieClip;

		public function OutroSection($mc:MovieClip, $data:Object)
		{
			_data = $data;
			super($mc);
		}
		
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		override protected function _init():void
		{
			super._init();
			_mc.alpha = 0;
			_stage = ApplicationFacade.returnStageObject();
			_bkg = _mc.bkg;
			_titles = _mc.titles;
			
			
			_videoPlayer = new ChromelessVideoPlayer(AbstractMain.PATH+_data.videopath, _bkg.width, _bkg.height);
			_videoPlayer.addEventListener(VideoControllerEvent.CONNECTION_MADE, videoReadyHandler, false, 0);
			_videoPlayer.addEventListener(VideoControllerEvent.VIDEO_OVER, videoOverHandler, false, 0);
			_videoPlayer.addEventListener(VideoControllerEvent.VIDEO_CUE_POINT, videoCuePointHandler, false, 0);
			_mc.addChildAt(_videoPlayer, 0);
			
		}
		
		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
		override public function setVolume($ratio:Number):void
		{
			super.setVolume($ratio);
			if (_videoPlayer) _videoPlayer.volume($ratio);
		}
		
		override public function resize(obj:Object):void
		{
			_mc.width = obj.width;
			_mc.height = obj.height;
			
			this.y = obj.offsetY;
		}
		
		public function beginAnimation($obj:Object):void
		{
			trace(this, "$obj['playmode']", $obj['playmode']);
		
			if (int($obj["playmode"]) == 0) {
				// watch your video
				// make a new video
				
				_buttonsOverlay = _mc.buttonsoverlay_0;
				_mc.buttonsoverlay_1.visible = false;
				_mc.buttonsoverlay_2.visible = false;
			} else if (int($obj["playmode"]) == 1) {
				// create your own
				// replay
				
				_buttonsOverlay = _mc.buttonsoverlay_1;
				_mc.buttonsoverlay_0.visible = false;
				_mc.buttonsoverlay_2.visible = false;
			} else {
				// see youself in this video
				// replay
				
				_buttonsOverlay = _mc.buttonsoverlay_2;
				_mc.buttonsoverlay_0.visible = false;
				_mc.buttonsoverlay_1.visible = false;
			}
			
			_heroButton = _buttonsOverlay.hero;
			_heroButton.buttonMode = true;
			_heroButton.userHandCursor = true;
			
			_replayButton = _buttonsOverlay.replay;
			_replayButton.buttonMode = true;
			_replayButton.userHandCursor = true;
			
			_buttonsOverlay.visible = false;
			_bkg.visible = false;
			_titles.visible = false;
			
			_buttonsOverlay.alpha = 0;
			_bkg.alpha = 0;
			_titles.alpha = 0;
			
			_heroButton.link = $obj["heropath"];
			_replayButton.link = $obj["replaypath"];
			_heroButton.addEventListener(MouseEvent.CLICK, onLinkClickHandler, false, 0, true);
			_replayButton.addEventListener(MouseEvent.CLICK, onLinkClickHandler, false, 0, true);
			animateIn();
		}

		override public function animateIn():void {
			
			_videoPlayer.resume();
			dispatchEvent(new OutroEvent(OutroEvent.ANIMATION_FINISHED));

			TweenNano.to(_mc, 2, {delay:0, alpha:1, ease:Strong.easeOut, overwrite:0});
		}
		
		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		private function link($value:String):void
		{
			var request:URLRequest = new URLRequest($value);
			//request.data = variables;
			try {            
				navigateToURL(request, "_self");
				//trace(this, "$url", $value);
			}
			catch (e:Error) {
				// handle error here
			}

		}

		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		private function onLinkClickHandler($e:MouseEvent):void
		{
			var mc:MovieClip = MovieClip($e.currentTarget);
			link(mc.link)
		}

		private function videoCuePointHandler($e:VideoControllerEvent):void
		{
			switch ($e.videoData.name)
			{
				case "start_fade":
					_bkg.visible = true;
					_buttonsOverlay.visible = true;
					_titles.visible = true;
					TweenNano.to(_bkg, 2, {alpha:1, ease:Strong.easeOut, overwrite:0});
					TweenNano.to(_titles, 1, {delay:1, alpha:1, ease:Strong.easeOut, overwrite:0});
					TweenNano.to(_buttonsOverlay, 1, {delay:1, alpha:1, ease:Strong.easeOut, overwrite:0});
					dispatchEvent(new OutroEvent(OutroEvent.SOUNDBUTTON));
					break;
			}
		}

		private function videoReadyHandler($e:VideoControllerEvent):void
		{
			resize(_stage);
			_videoPlayer.volume(_volume);
			dispatchEvent(new OutroEvent(OutroEvent.LOADED));
		}
		
		private function videoOverHandler($e:VideoControllerEvent):void
		{
			_mc.removeChild(_videoPlayer);
			_videoPlayer = null;
		}

	}
}