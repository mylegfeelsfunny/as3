package com.deepfocus.as3.display.widgets.videoPlayer.thumbnailViewer{

	
	import com.deepfocus.as3.events.ThumbnailEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class ThumbnailViewer extends EventDispatcher{
		
		private var _mc								:MovieClip
		private var _isIn							:Boolean;
		private var _urlList						:Array;
		private var _titleList						:Array;
		private var _thumbnailList					:Array;
		private var _currentPage					:int;
		private var _thumbLoadIndex					:int;
		private var _thumbLoadedIndex				:int;
		private var _thumbAnimatingIndex			:int;
		private var _loadingTimer					:Timer;
		private var _animatingTimer					:Timer;
		private var _lastPage						:MovieClip;
		private var _nextPage						:MovieClip;
		
		private static const IN						:String 		= 'IN';
		private static const OUT					:String 		= 'OUT';
		private static const OVER					:String 		= 'OVER';
		private static const NUM_PER_PAGE			:int			= 12;
		private static const LOAD_INTERVAL			:int			= 50;
		
		public function ThumbnailViewer($mc:MovieClip){
			_mc		= $mc;
			_isIn 	= false;
			_init();
		}
		private function _init():void{
			var v:MovieClip 			= _mc.tween.viewer;
			_currentPage				= 0;
			_thumbnailList				= [];
			for(var i:int = 0;i<NUM_PER_PAGE;i++){
				_thumbnailList.push(new ThumbNail(v['t'+i]));
				ThumbNail(_thumbnailList[_thumbnailList.length-1]).addEventListener(ThumbnailEvent.ITEM_CHOOSEN,_onThumbClicked,false,0,true);
				ThumbNail(_thumbnailList[_thumbnailList.length-1]).addEventListener(Event.COMPLETE,_onThumbLoadComplete,false,0,true);
				addEventListener(ThumbnailEvent.ITEM_CHOOSEN,ThumbNail(_thumbnailList[_thumbnailList.length-1]).setActiveState,false,0,true);
				addEventListener(ThumbnailEvent.ITEM_CHOOSEN_EXTERNALLY,ThumbNail(_thumbnailList[_thumbnailList.length-1]).setActiveState,false,0,true);
			}
			
			_lastPage 					= _mc.tween.viewer.lastPage;
			_nextPage 					= _mc.tween.viewer.nextPage;
			_lastPage.addEventListener(MouseEvent.CLICK,_onPageButtonClicked,false,0,true);
			_lastPage.addEventListener(MouseEvent.ROLL_OVER,_onPageButtonOver,false,0,true);
			_lastPage.addEventListener(MouseEvent.ROLL_OUT,_onPageButtonOut,false,0,true);
			_lastPage.buttonMode		= true;
			_lastPage.mouseChildren		= false;
			_nextPage.addEventListener(MouseEvent.CLICK,_onPageButtonClicked,false,0,true);
			_nextPage.addEventListener(MouseEvent.ROLL_OVER,_onPageButtonOver,false,0,true);
			_nextPage.addEventListener(MouseEvent.ROLL_OUT,_onPageButtonOut,false,0,true);
			_nextPage.buttonMode		= true;
			_nextPage.mouseChildren		= false;
						
			_loadingTimer				= new Timer(LOAD_INTERVAL,NUM_PER_PAGE);
			_loadingTimer.addEventListener(TimerEvent.TIMER,_loadThumb,false,0,true);
			_animatingTimer				= new Timer(LOAD_INTERVAL,NUM_PER_PAGE);
			_animatingTimer.addEventListener(TimerEvent.TIMER,_animateInThumb,false,0,true);
		}
		public function animateIn():void{
			_mc.tween.gotoAndPlay(IN);
			_isIn = true;
			_startNextPageLoad();
		}
		public function animateOut($changingPlayList:Boolean=false):void{
			_loadingTimer.stop();
			_mc.tween.gotoAndPlay(OUT);
			var l:int 		= _thumbnailList.length;
			for(var i:int=0;i<l;i++){
				ThumbNail(_thumbnailList[i]).resetThumb();
			}
			if($changingPlayList)_currentPage = 0;
			_isIn = false;
		}
		public function setURLs($urlList:Array):void{
			_urlList = $urlList;
		}
		public function setTitles($titleList:Array):void{
			_titleList = $titleList;
		}
		public function get isIn():Boolean{
			return _isIn;
		}
		//PAGECONTROL
		private function _startNextPageLoad():void{
 			_thumbLoadIndex			= -1;
 			_thumbLoadedIndex		= 0;
  			_loadingTimer.reset();
 			_loadingTimer.start(); 
 			
// 			_loadThumb();
		}
		private function _loadThumb($evt:Event=null):void{
			_thumbLoadIndex++;
			if(_urlList[(_currentPage * NUM_PER_PAGE)+_thumbLoadIndex]){
				ThumbNail(_thumbnailList[_thumbLoadIndex]).setThumbNail(_urlList[(_currentPage * NUM_PER_PAGE)+_thumbLoadIndex],_titleList[(_currentPage * NUM_PER_PAGE)+_thumbLoadIndex],(_currentPage * NUM_PER_PAGE)+_thumbLoadIndex);
			}else{
				ThumbNail(_thumbnailList[_thumbLoadIndex]).setThumbNail(null);
			}
		}
		private function _onThumbLoadComplete($evt:Event):void{
			_thumbLoadedIndex++		
			var numofThumbs:int
			if((NUM_PER_PAGE*(_currentPage+1)) > _urlList.length){
				//on last page
				numofThumbs = (_urlList.length % NUM_PER_PAGE);
			}else{
				//full page
				numofThumbs = NUM_PER_PAGE;
			}
			if(_thumbLoadedIndex == numofThumbs){
				_thumbAnimatingIndex = -1;
				_animatingTimer.reset();
				_animatingTimer.start();
			}
		}
		private function _animateInThumb($evt:Event=null):void{
			var max:int;
			_thumbAnimatingIndex++;
			if((NUM_PER_PAGE*(_currentPage+1)) > _urlList.length){
				max = (_urlList.length % NUM_PER_PAGE);
				if(_thumbAnimatingIndex<max)ThumbNail(_thumbnailList[_thumbAnimatingIndex]).animateIn();
			}else{
				ThumbNail(_thumbnailList[_thumbAnimatingIndex]).animateIn();
			}
				
				
		}
		private function _onThumbClicked($evt:ThumbnailEvent):void{
			animateOut();
			dispatchEvent($evt);
		}
		public function onAutoPlayChange($evt:ThumbnailEvent):void{
			$evt.id
			dispatchEvent(new ThumbnailEvent(ThumbnailEvent.ITEM_CHOOSEN_EXTERNALLY,$evt.id));
		}
		//PAGE BUTTONS
		private function _onPageButtonClicked($evt:MouseEvent):void{
			switch($evt.target){
				case _nextPage:
					_currentPage++;
					if(Number(NUM_PER_PAGE*_currentPage) > _urlList.length) _currentPage = 0;
				break;
				case _lastPage:
					_currentPage--;
					if(_currentPage < 0) _currentPage = Math.floor(_urlList.length/NUM_PER_PAGE);
				break;				
			}
			_startNextPageLoad();
		}
		private function _onPageButtonOver($evt:MouseEvent):void{
			MovieClip($evt.target).gotoAndStop(OVER);
		}
		private function _onPageButtonOut($evt:MouseEvent):void{
			MovieClip($evt.target).gotoAndStop(OUT);
		}
		//KILL
		public function kill():void{
			if(_urlList){
				for(var uIndex:int=0;uIndex < _urlList.length;uIndex++){_urlList[uIndex] = null};
				for(var titleIndex:int=0;titleIndex < _titleList.length;titleIndex++){_titleList[titleIndex] = null};				
			}
			for(var tIndex:int=0;tIndex < _thumbnailList.length;tIndex++){
				ThumbNail(_thumbnailList[tIndex]).removeEventListener(ThumbnailEvent.ITEM_CHOOSEN,_onThumbClicked);
				ThumbNail(_thumbnailList[_thumbnailList.length-1]).removeEventListener(Event.COMPLETE,_onThumbLoadComplete);
				removeEventListener(ThumbnailEvent.ITEM_CHOOSEN,ThumbNail(_thumbnailList[_thumbnailList.length-1]).setActiveState);
				removeEventListener(ThumbnailEvent.ITEM_CHOOSEN_EXTERNALLY,ThumbNail(_thumbnailList[_thumbnailList.length-1]).setActiveState);
				ThumbNail(_thumbnailList[tIndex]).kill();
				_thumbnailList[tIndex] 	= null
			};
			_loadingTimer.removeEventListener(TimerEvent.TIMER,_loadThumb);
			_animatingTimer.removeEventListener(TimerEvent.TIMER,_animateInThumb);
			_nextPage.removeEventListener(MouseEvent.CLICK,_onPageButtonClicked);
			_nextPage.removeEventListener(MouseEvent.ROLL_OVER,_onPageButtonOver);
			_nextPage.removeEventListener(MouseEvent.ROLL_OUT,_onPageButtonOut);
			_lastPage.removeEventListener(MouseEvent.CLICK,_onPageButtonClicked);
			_lastPage.removeEventListener(MouseEvent.ROLL_OVER,_onPageButtonOver);
			_lastPage.removeEventListener(MouseEvent.ROLL_OUT,_onPageButtonOut);
			_loadingTimer.stop();
			_loadingTimer				= null;
			_animatingTimer.stop();
			_animatingTimer				= null;
			_thumbnailList				= null;
			_urlList					= null;
			_titleList					= null;
			_thumbLoadIndex				= undefined;
			_thumbLoadedIndex			= undefined;
			_thumbAnimatingIndex		= undefined;
			_currentPage				= undefined;
			_isIn						= undefined;
			_lastPage.stop();
			_lastPage					= null;
			_nextPage.stop();
			_nextPage					= null;			
			_mc.stop();
			_mc							= null;
		}
	}
}