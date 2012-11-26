package com.deepfocus.as3.display.video.videocontrols
{
	import com.deepfocus.as3.events.VideoControlerEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	public class VideoControls extends MovieClip
	{
		public static var CONTROLS_READY											:String 	= "Controls Ready";
		public static var PLAYER_PLAY												:String 	= "Player Play";
		public static var PLAYER_PAUSE												:String 	= "Player Pause";
		public static var PLAYER_CLOSE												:String 	= "Player Close";
		public static var SOUND_OFF													:String 	= "Sound Off";
		public static var SOUND_ON													:String 	= "Sound On";
		
		private var _loader															:Loader;
		private var _maxProgressWidth												:uint;
		private var _controlAssets													:MovieClip;
		private var _controlWidth													:uint;
		private var _controlHeight													:uint;
		
		private var _playbutton														:MovieClip;
		private var _pausebutton													:MovieClip;
		private var _closebutton													:MovieClip;
		private var _fullbar														:MovieClip;
		private var _loadprogressbar												:MovieClip;
		private var _playprogressbar												:MovieClip;
		private var _background														:MovieClip;
		
		private var _scrubberX0														:Number;  //(int causes visible rounding errors)
		private var _scrubberY0														:Number;
		private var _scrubberMaxProgressWidth										:Number;
		private var _scrubber														:MovieClip;
		private var _isScrubbing													:Boolean;
		private var _mc																:MovieClip;
		private var _sound															:MovieClip;
		private var _soundBoo														:Boolean;	
				
		public function VideoControls(assets:String, width:uint=520, height:uint=30)
		{	
			_controlWidth 	= width;
			_controlHeight 	= height;
			
			_loader 		= new Loader();
			_loader.load(new URLRequest(assets));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onControlsLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
		}
		
		private function onControlsLoaded(e:Event):void
		{
			_controlAssets 	= MovieClip(_loader.content);
			dispatchEvent(new Event(CONTROLS_READY));
			addChild(_controlAssets);
			initAssets();
		}
		private function initAssets():void{
			
			_mc								= _controlAssets;

			_playbutton						= _controlAssets.playbutton;
			_pausebutton					= _controlAssets.pausebutton;
			_closebutton					= _controlAssets.closebutton;
			_fullbar						= _controlAssets.fullbar;
			_loadprogressbar				= _controlAssets.loadprogressbar;
			_playprogressbar				= _controlAssets.playprogressbar;
			_background						= _controlAssets.background;
			_scrubber						= _controlAssets.scrubber;
			_sound							= _controlAssets.sound;
			
			_mc.addEventListener(MouseEvent.CLICK,_onMcClicked,false,0,true);
			
			_playbutton.x 				= 5;
			_playbutton.y 				= (_controlHeight/2);
			_playbutton.buttonMode 		= true;
			_playbutton.addEventListener(MouseEvent.CLICK, _playbuttonClick);
			_playbutton.addEventListener(MouseEvent.MOUSE_OVER, buttonRollover);
			_playbutton.addEventListener(MouseEvent.MOUSE_OUT, buttonRollout);
			_playbutton.visible 			= false;
			
			_pausebutton.x 				= 5;
			_pausebutton.y 				= (_controlHeight/2);
			_pausebutton.buttonMode 		= true;
			_pausebutton.addEventListener(MouseEvent.CLICK, _pausebuttonClick);
			_pausebutton.addEventListener(MouseEvent.MOUSE_OVER, buttonRollover);
			_pausebutton.addEventListener(MouseEvent.MOUSE_OUT, buttonRollout);
			
			_closebutton.x 				= _controlWidth - _closebutton.width;
			_closebutton.y 				= (_controlHeight/2);
			_closebutton.buttonMode 		= true;
			_closebutton.addEventListener(MouseEvent.CLICK, _closebuttonClick);
			_closebutton.addEventListener(MouseEvent.MOUSE_OVER, buttonRollover);
			_closebutton.addEventListener(MouseEvent.MOUSE_OUT, buttonRollout);
			
			//HIDE CLOSE BUTTON
			_closebutton.visible 		= false;
			_closebutton.x 				= _controlWidth;				//df subtract pixels from here to make right indent (try 20px)
			// end hide close button

			_sound.x					= int(_controlWidth-(_sound.width + 6));
			_sound.slash.visible 		= false;
			_sound.addEventListener(MouseEvent.CLICK, _soundbuttonClick);
			//_sound.addEventListener(MouseEvent.MOUSE_OVER, buttonRollover);
			//_sound.addEventListener(MouseEvent.MOUSE_OUT, buttonRollout);
			addChild(_sound)
			
			_maxProgressWidth 			= _closebutton.x - (_playbutton.width + _sound.width  + 23 + 6);
			
			_fullbar.x 					= _playbutton.x + _playbutton.width + 5;
			_fullbar.y 					=  (_controlHeight/2);
			_fullbar.width 				= _maxProgressWidth;
			
			_loadprogressbar.x 			= _fullbar.x;
			_loadprogressbar.y 			=  _fullbar.y;			
			_loadprogressbar.width 		= 0;
			
			_playprogressbar.x 			= _fullbar.x
			_playprogressbar.y 			= _fullbar.y;
			_playprogressbar.width 		= 0;
			
			_background.x 				= _background.y = 0
			_background.width 			= _controlWidth;
			_background.height 			= _controlHeight;
			
			//scrubber
			_scrubberX0 = _scrubber.x	= _playprogressbar.x;
			_scrubberY0 = _scrubber.y	= _playprogressbar.y - _scrubber.height/2;
			_scrubberMaxProgressWidth	= _maxProgressWidth -  (_scrubber.width/2);
			_scrubber.addEventListener(MouseEvent.MOUSE_DOWN,_onScrubberMouseEvent,false,0,true)
			//mouse up is a stage listener, and is implomented on mouse down
			
			_scrubber.buttonMode			= true;
			_scrubber.mouseChildren			= false;
		}
		
		private function _soundbuttonClick(e:Event):void
		{
			if (_soundBoo == false)
			{
				_soundBoo = true;
				_sound.slash.visible = true;
				dispatchEvent(new Event(SOUND_OFF));
			}	
			else
			{
				_soundBoo = false;
				_sound.slash.visible = false;
				dispatchEvent(new Event(SOUND_ON));
			}
		}
		
		private function _playbuttonClick(e:Event):void
		{
			_playbutton.visible 		= false;
			_pausebutton.visible 		= true;
			dispatchEvent(new Event(PLAYER_PLAY));
		}
		
		private function _pausebuttonClick(e:Event):void
		{
			_playbutton.visible 		= true;
			_pausebutton.visible 		= false;
			dispatchEvent(new Event(PLAYER_PAUSE));
		}
		
		private function _closebuttonClick(e:Event):void
		{
			dispatchEvent(new Event(PLAYER_CLOSE));
		}
		
		private function buttonRollover(e:Event):void        
		{            
			TweenMax.to(e.currentTarget, .25, {alpha:.5});        
		}    
		           
		private function buttonRollout(e:Event):void{   
		 TweenMax.to(e.currentTarget, .25, {alpha:1});       
        }
	
		public function LoadProgress(dec:Number):void
		{
			_loadprogressbar.width 		= _maxProgressWidth * dec; 
		}
		
		public function PlayProgress(dec:Number):void
		{
			_playprogressbar.width 		= _maxProgressWidth * dec; 
			if(!_isScrubbing){
				if(dec > 0) _scrubber.x	= (_scrubberMaxProgressWidth * dec) + _scrubberX0; 
			} 
		}		
		
		//scrubbing
		private function _onScrubberMouseEvent($evt:MouseEvent):void{
			switch($evt.type){
				case MouseEvent.MOUSE_DOWN:
					dispatchEvent(new VideoControlerEvent(VideoControlerEvent.PAUSE_VIDEO));
					_initScrubbing();
				break;
				case MouseEvent.MOUSE_UP:
				case MouseEvent.ROLL_OUT:
					if(_pausebutton.visible == true) dispatchEvent(new VideoControlerEvent(VideoControlerEvent.RESUME_VIDEO));
					_stopScrubbing();
				break;				
			}
		}
		private function _initScrubbing():void{
			_isScrubbing	= true;
			_scrubber.startDrag(true,new Rectangle(_scrubberX0,_scrubberY0,_scrubberMaxProgressWidth,0));
			_scrubber.stage.addEventListener(MouseEvent.MOUSE_UP,_onScrubberMouseEvent,false,0,true);
			_mc.addEventListener(MouseEvent.ROLL_OUT,_onScrubberMouseEvent,false,0,true);
			_scrubber.addEventListener(Event.ENTER_FRAME,_onEnterFrame,false,0,true);
		}
		private function _stopScrubbing():void{
			_scrubber.stage.removeEventListener(MouseEvent.MOUSE_UP,_onScrubberMouseEvent);
			_mc.removeEventListener(MouseEvent.ROLL_OUT,_onScrubberMouseEvent);
			_scrubber.removeEventListener(Event.ENTER_FRAME,_onEnterFrame);
			_isScrubbing	= false;
			stopDrag();
		}		
		private function _onEnterFrame($evt:Event):void{
			var percent:Number = (_scrubber.x - _scrubberX0) / _scrubberMaxProgressWidth;
//			Out.info(this,'percent '+percent);
			if(percent < .002){
				percent = 0;
			}else if(percent > 1){
				percent = 1;
			}
			dispatchEvent(new VideoControlerEvent(VideoControlerEvent.SEEK,percent));
		}
		//jump ahead back by mouse press
		private function _onMcClicked($evt:MouseEvent):void{
			//Out.info(this,'_onMcClicked()');
			var percent:Number = (_mc.mouseX - _scrubberX0) / _scrubberMaxProgressWidth;
//			Out.info(this,'percent '+percent);
			if(percent < .002){
				percent = 0;
			}else if(percent > 1){
				percent = 1;
			}
			dispatchEvent(new VideoControlerEvent(VideoControlerEvent.SEEK,percent));			
		}
		
		private function onIOErrorHandler(e:IOErrorEvent):void
		{			
			trace(e);
		}
	}
}