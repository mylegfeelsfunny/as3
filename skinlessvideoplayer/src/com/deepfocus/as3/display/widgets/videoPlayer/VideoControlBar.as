package com.deepfocus.as3.display.widgets.videoPlayer{


	import com.bigspaceship.utils.Out;
	import com.deepfocus.as3.events.SliderEvent;
	import com.egraphicsNY.events.VideoControlBarEvent;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;

	public class VideoControlBar extends EventDispatcher{
		private var _mc							:MovieClip;
		private var _playPause					:MovieClip;
//		private var _ff							:MovieClip;
		private var _loading					:MovieClip;
		private var _videoSlider_mc				:MovieClip;
		private var _progressbar				:MovieClip;
//		private var _soundSlider_mc				:MovieClip;
		private var _soundOnOff					:MovieClip;
//		private var _thumbnailButton			:MovieClip;
		private var _thumbnailIsOpen			:Boolean;
		private var _isPlaying					:Boolean;
		private var _soundIsOn					:Boolean;
		
		private var _videoSlider				:ControlerSlider;
				
		private var _percentLoaded				:Number;
		
		private var _sliderBorder				:MovieClip;
		
		public function VideoControlBar($mc:MovieClip){
			_mc	= $mc;
			_init();
			
		}
		private function _init():void{
			_playPause					= _mc.but_video_play;
			_progressbar				= _mc.videoSlider.progressBar;
			_progressbar.width			= 0;
			_loading					= _mc.videoSlider.loadingBar;
			_loading.width				= 0;
			_videoSlider_mc				= _mc.videoSlider;
			_soundOnOff					= _mc.sound_mov;
			_sliderBorder				= _mc.videoSlider.sliderBorder;
//			_thumbnailButton			= _mc.thumbNailButton;
			
			_videoSlider				= new ControlerSlider(_videoSlider_mc,_sliderBorder);
			_videoSlider.addEventListener(MouseEvent.MOUSE_DOWN,_onVideoSliderClicked,false,0,true);
			_videoSlider.addEventListener(MouseEvent.MOUSE_UP,_onVideoSliderClicked,false,0,true);
			
			_soundIsOn					= true;
			
			_playPause.addEventListener(MouseEvent.CLICK,_onPlayPauseClicked,false,0,true);
			_playPause.addEventListener(MouseEvent.ROLL_OVER,_onPlayPauseOver,false,0,true);
			_playPause.addEventListener(MouseEvent.ROLL_OUT,_onPlayPauseOut,false,0,true);
			_playPause.buttonMode		= true;
			_playPause.mouseChildren	= false;
					
			_soundOnOff.addEventListener(MouseEvent.CLICK,_onSoundOnOff,false,0,true);
			_soundOnOff.addEventListener(MouseEvent.ROLL_OVER,_onSoundOver,false,0,true);
			_soundOnOff.addEventListener(MouseEvent.ROLL_OUT,_onSoundOut,false,0,true);
			_soundOnOff.buttonMode		= true;
			_soundOnOff.mouseChildren	= false;
			
/* 			_thumbnailButton.addEventListener(MouseEvent.CLICK,_onThumbNailButtonEvent,false,0,true);
			_thumbnailButton.addEventListener(MouseEvent.ROLL_OVER,_onThumbNailButtonEvent,false,0,true);
			_thumbnailButton.addEventListener(MouseEvent.ROLL_OUT,_onThumbNailButtonEvent,false,0,true);
			_thumbnailButton.buttonMode		= true;
			_thumbnailButton.mouseChildren	= false; */			
		}
		//PLAY PAUSE
		private function _onPlayPauseClicked($evt:MouseEvent = null):void{
			if(_isPlaying){
				_playPause.gotoAndStop(TBWAVideoPlayerConstants.PLAY_OVER);
				_isPlaying 				= false;
				dispatchEvent(new VideoControlBarEvent(VideoControlBarEvent.PAUSE));
			}else{
				_playPause.gotoAndStop(TBWAVideoPlayerConstants.PAUSE_OVER);
				_isPlaying 				= true;	
				dispatchEvent(new VideoControlBarEvent(VideoControlBarEvent.PLAY));			
			}
		}
		private function _onVideoSliderClicked($evt:MouseEvent):void{
			Out.info(this, '_onVideoSliderClicked() $evt.type '+$evt.type);
			switch($evt.type){
				case MouseEvent.MOUSE_DOWN:
					_videoSlider.addEventListener(SliderEvent.ON_STEP,_onSliderStep,false,0,true);
					if(_isPlaying) dispatchEvent(new VideoControlBarEvent(VideoControlBarEvent.PAUSE));
				break;
				case MouseEvent.MOUSE_UP:
					_videoSlider.removeEventListener(SliderEvent.ON_STEP,_onSliderStep);
					if(_isPlaying) dispatchEvent(new VideoControlBarEvent(VideoControlBarEvent.PLAY));
				break;				
			}
		}
		private function _onPlayPauseOver($evt:MouseEvent):void{
			(_isPlaying) ? _playPause.gotoAndStop(TBWAVideoPlayerConstants.PAUSE_OVER) : _playPause.gotoAndStop(TBWAVideoPlayerConstants.PLAY_OVER);
		}
		private function _onPlayPauseOut($evt:MouseEvent):void{
			(_isPlaying) ? _playPause.gotoAndStop(TBWAVideoPlayerConstants.PAUSE_OUT) : _playPause.gotoAndStop(TBWAVideoPlayerConstants.PLAY_OUT);
		}

		//FthumbnailButton
/* 		private function _onThumbNailButtonEvent($evt:MouseEvent):void{
			switch($evt.type){
				case MouseEvent.ROLL_OVER:
					(_thumbnailIsOpen) ? _thumbnailButton.gotoAndStop('OPEN_OVER') : _thumbnailButton.gotoAndStop('CLOSE_OVER');
				break;
				case MouseEvent.ROLL_OUT:
					(_thumbnailIsOpen) ? _thumbnailButton.gotoAndStop('OPEN_OUT') : _thumbnailButton.gotoAndStop('CLOSE_OUT');
				break;
				case MouseEvent.CLICK:
					if(_thumbnailIsOpen){
						_thumbnailIsOpen = false;
						_thumbnailButton.gotoAndStop('CLOSE_OVER');
					}else{
						_thumbnailIsOpen = true;
						_thumbnailButton.gotoAndStop('OPEN_OVER');
					}
					dispatchEvent(new VideoControlBarEvent(VideoControlBarEvent.THUMBNAIL_VIEWER_BUTTON_CLICK));
				break;											
			}
		} */		
		//SOUND CONTROL
		private function _onSoundOnOff($evt:MouseEvent):void{
			if(_soundIsOn){
				_soundIsOn = false;
				_soundOnOff.gotoAndStop(TBWAVideoPlayerConstants.OFF_OVER);
				dispatchEvent(new VideoControlBarEvent(VideoControlBarEvent.SOUND_OFF));
//				_soundSlider.setPosition(0);
			}else{
				_soundIsOn = true;
				_soundOnOff.gotoAndStop(TBWAVideoPlayerConstants.ON_OVER);	
				dispatchEvent(new VideoControlBarEvent(VideoControlBarEvent.SOUND_ON));	
//				_soundSlider.setPosition(1);		
			}
		}
		private function _onSoundOver($evt:MouseEvent):void{
			(_soundIsOn) ? _soundOnOff.gotoAndStop(TBWAVideoPlayerConstants.ON_OVER) : _soundOnOff.gotoAndStop(TBWAVideoPlayerConstants.OFF_OVER);
		}
		private function _onSoundOut($evt:MouseEvent):void{
			(_soundIsOn) ? _soundOnOff.gotoAndStop(TBWAVideoPlayerConstants.ON_OUT) : _soundOnOff.gotoAndStop(TBWAVideoPlayerConstants.OFF_OUT);
		}
		//CONTROL EVENTS FROM VIDEO PLAYER
		public function onNetStatus($evt:NetStatusEvent):void{
//			Out.info(this,'_onNetStatus() '+$evt.info.code.toString());
 			switch($evt.info.code){
				case 'NetStream.Play.Start':
					_playPause.gotoAndStop(TBWAVideoPlayerConstants.PAUSE_OUT);
					_isPlaying 				= true;	
//					if(_soundIsOn) _soundSlider.setPosition(1);
				break;
				case 'NetStream.Play.Stop':
					_playPause.gotoAndStop(TBWAVideoPlayerConstants.PLAY_OUT);
					_isPlaying 				= false;				
				break;
			} 
		}	
		public function onLoadingEvent($evt:VideoControlBarEvent):void{
//			Out.info(this,'$evt.value '+$evt.value+' | _loading.currentFrame '+_loading.currentFrame);
			var pos:Number = $evt.value/100;
			if(pos > 1){
				pos = 1;
			}else if(pos < 0 || !pos){
				pos = 0;
			} 
			_loading.width = _sliderBorder.width*pos;
/* 			if($evt.value == 100){
				_loading.gotoAndStop(100);
			}else if(_loading.currentFrame < $evt.value){
				_loading.play();
			}else{
				_loading.stop();
			}
			_percentLoaded		= _loading.currentFrame/100;  *///useing frame instead of $evt.value cause the play head could potentially not be caought up to value, will cause a bug if loader in anything butt 100 frame long
		}		
		public function onVideoPositionEvent($evt:VideoControlBarEvent):void{
//			Out.info(this,'onVideoPositionEvent $evt.value '+$evt.value);
			var pos:Number  = $evt.value;
			if(pos > 1) pos = 1;
			_videoSlider.setPosition(pos);
			if(pos < 0 || !pos) pos = 0;
//			_progressbar.scaleX = pos;
			_progressbar.width = _sliderBorder.width*pos;
//			Out.info(this, 'p.w:' +_progressbar.width+' p.x:' +_progressbar.x+' s.w:' +_sliderBorder.width+' s.x:' +_sliderBorder.x+' pos:'+pos);
		}
		public function reset($evt:VideoControlBarEvent):void{
			_loading.gotoAndStop(1);
		}
		// SLIDER SOUND AND VIDEO
		private function _onSliderStep($evt:SliderEvent):void{
			switch($evt.target){
				case _videoSlider:
//					Out.info(this, $evt.target+' '+$evt.position);
					dispatchEvent(new VideoControlBarEvent(VideoControlBarEvent.VIDEO_SLIDER_POSITION,$evt.position));
				break;
			}
		}
		public function kill():void{
			_playPause.removeEventListener(MouseEvent.CLICK,_onPlayPauseClicked);
			_playPause.removeEventListener(MouseEvent.ROLL_OVER,_onPlayPauseOver);
			_playPause.removeEventListener(MouseEvent.ROLL_OUT,_onPlayPauseOut);

			_soundOnOff.removeEventListener(MouseEvent.CLICK,_onSoundOnOff);
			_soundOnOff.removeEventListener(MouseEvent.ROLL_OVER,_onSoundOver);
			_soundOnOff.removeEventListener(MouseEvent.ROLL_OUT,_onSoundOut);
			_videoSlider.removeEventListener(SliderEvent.ON_STEP,_onSliderStep);
			_videoSlider.removeEventListener(MouseEvent.MOUSE_DOWN,_onVideoSliderClicked);
			_videoSlider.removeEventListener(MouseEvent.MOUSE_UP,_onVideoSliderClicked);
/* 			_thumbnailButton.removeEventListener(MouseEvent.CLICK,_onThumbNailButtonEvent);
			_thumbnailButton.removeEventListener(MouseEvent.ROLL_OVER,_onThumbNailButtonEvent);
			_thumbnailButton.removeEventListener(MouseEvent.ROLL_OUT,_onThumbNailButtonEvent); */
			
			_videoSlider.kill();
			_videoSlider			= null;
			
			_isPlaying				= undefined;
			_soundIsOn				= false;
			_percentLoaded			= undefined;
			_playPause.stop();
			_loading.stop();
			_videoSlider_mc.stop();
			_soundOnOff.stop();
			_thumbnailIsOpen		= undefined;
			_playPause				= null;		
			_progressbar			= null;
			_loading				= null;
			_videoSlider_mc			= null;

			_soundOnOff				= null;
			_mc.stop();
			_mc						= null;
		}
	}
}