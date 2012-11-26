package com.deepfocus.as3.display.widgets.videoPlayer.thumbnailViewer{

	import com.egraphicsNY.events.AnimationEvent;
	import com.deepfocus.as3.events.ThumbnailEvent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	public class ThumbNail extends Sprite{
		private var _mc								:MovieClip;
		private var _loader							:Loader;
		private var _index							:int;
		private var _currentIndex					:int;
		private var _url							:String;
		private var _title							:String;
		
		private static const IN						:String		= 'IN';
		private static const OUT					:String		= 'OUT';
		private static const NON_CURRENT			:String		= 'NON_CURRENT';
		private static const CURRENT				:String		= 'CURRENT';
		private static const OVER					:String		= 'OVER';
		
		public function ThumbNail($mc:MovieClip){
			_mc							= $mc;
			_loader						= new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,_onLoadComplete,false,0,true);
			_mc.anchor.addChild(_loader);
			_index						= -1;  // undefined ==0 and messed up first thumbload;
		}
		public function animateIn():void{
			_mc.gotoAndPlay(IN);
		}
		public function animateOut():void{
			if(_mc.currentLabel==IN)_mc.gotoAndPlay(OUT);
		}
		public function setThumbNail($url:String=null,$title:String=null,$index:int=undefined):void{
			if($url){ 									//if not url make inactive
				if(_index != $index){					//if index are same; correct page is in and do nothing
					_index				= $index;
					_url				= $url;
					_title				= $title;
					setActiveState();
					if(_mc.currentLabel==IN){			// if thumbin the animate out befor you load in the next one
						_mc.addEventListener(AnimationEvent.ANIMATE_OUT_FINISHED,_loadThumb,false,0,true);
						animateOut();
					}else{
						_loadThumb();
					}
				}
			}else{
				_index = undefined;
				_mc.removeEventListener(MouseEvent.CLICK,_onMouseEvent);
				_mc.buttonMode		= false;
				_mc.mouseChildren	= true;	
				animateOut();
			}
		}
		public function setActiveState($evt:ThumbnailEvent=null):void{
			if($evt)_currentIndex	= $evt.id;
			( _currentIndex == _index) ? MovieClip(_mc.frame).gotoAndStop(CURRENT) : MovieClip(_mc.frame).gotoAndStop(NON_CURRENT); 
		}
		private function _loadThumb($evt:AnimationEvent=null):void{
			_mc.removeEventListener(AnimationEvent.ANIMATE_OUT_FINISHED,_loadThumb);
			_loader.load(new URLRequest(_url));
			_mc.addEventListener(MouseEvent.CLICK,_onMouseEvent,false,0,true);
			_mc.addEventListener(MouseEvent.ROLL_OVER,_onMouseEvent,false,0,true);
			_mc.addEventListener(MouseEvent.ROLL_OUT,_onMouseEvent,false,0,true);
			_mc.buttonMode		= true;
			_mc.mouseChildren	= false;
			_mc.frame.copy.text	= _title;			
		}
		private function _onMouseEvent($evt:Event):void{
			switch($evt.type){
				case MouseEvent.CLICK:
					dispatchEvent(new ThumbnailEvent(ThumbnailEvent.ITEM_CHOOSEN,_index));	
				break;
				case MouseEvent.ROLL_OVER:	
					MovieClip(_mc.frame).gotoAndStop(OVER);
				break;
				case MouseEvent.ROLL_OUT:
					( _currentIndex == _index) ? MovieClip(_mc.frame).gotoAndStop(CURRENT) : MovieClip(_mc.frame).gotoAndStop(NON_CURRENT);
				break;								
			}
		}
		private function _onLoadComplete($evt:Event):void{
//			animateIn();
			dispatchEvent($evt);
		}
		public function resetThumb():void{
			_index = -1;
//			animateOut(); 
  			_mc.removeEventListener(MouseEvent.CLICK,_onMouseEvent);
			_mc.buttonMode		= false;
			_mc.mouseChildren	= true;	 
			animateOut(); 
		}
		public function kill():void{
			_mc.removeEventListener(MouseEvent.CLICK,_onMouseEvent);
			_mc.removeEventListener(AnimationEvent.ANIMATE_OUT_FINISHED,_loadThumb);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,_onLoadComplete);
//			_loader.close();
			_loader.unload();
			_mc.anchor.removeChild(_loader);
			_loader					= null;
			_url					= null;
			_title					= null;
			_index					= undefined;
			_currentIndex			= undefined;
			_mc.stop();
			_mc						= null;
		}
	}
}