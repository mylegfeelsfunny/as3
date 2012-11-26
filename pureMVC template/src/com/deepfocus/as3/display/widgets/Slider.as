package com.deepfocus.as3.display.widgets{
	
	import com.bigspaceship.utils.Out;
	import com.deepfocus.as3.events.SliderEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class Slider extends EventDispatcher{
		protected var _mc  						:MovieClip; 
		protected var _grabber 					:MovieClip;
		protected var _background				:MovieClip;
		
		public function Slider($mc:MovieClip,$background:MovieClip){
			super();
			Out.status(this, 'Slider()');
			_mc  		= $mc
			_grabber 	= _mc.grabber;
			_background	= $background;
			_init();
		}
		protected function _init():void{
			_grabber.addEventListener(MouseEvent.MOUSE_DOWN,_onMouseDown,false,0,true);
			_grabber.mouseChildren  = false;
			_grabber.buttonMode		= true;
		}
		protected function _onMouseDown($evt:MouseEvent):void{
			Out.status(this, '_onMouseDown()');
			var r:Rectangle = new Rectangle(_background.x,_grabber.y,_background.x+_background.width,_grabber.y);
			_mc.stage.addEventListener(MouseEvent.MOUSE_UP,_onMouseUp,false,0,true);
			_mc.addEventListener(Event.ENTER_FRAME,_onSlide,false,0,true);
			_grabber.startDrag(true,r);
			dispatchEvent($evt);
		}
		protected function _onMouseUp($evt:MouseEvent):void{
			Out.status(this, '_onMouseUp()');
			_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,_onMouseUp);
			_mc.removeEventListener(Event.ENTER_FRAME,_onSlide);
			_grabber.stopDrag();
			dispatchEvent($evt);
		}
		protected function _onSlide($evt:Event=null):void{
			var pos:Number = _grabber.x / _background.width;
//			Out.status(this, '_onSlide() pos '+pos);
			dispatchEvent(new SliderEvent(SliderEvent.ON_STEP,pos));
		}
		public function setPosition($pos:Number):void{
			_grabber.x = $pos * _background.width;
//			Out.info(this, '_grabber.x '+_grabber.x);
			_onSlide();
		}
		public function kill():void{
			_grabber.removeEventListener(MouseEvent.MOUSE_DOWN,_onMouseDown);
			_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,_onMouseUp);
			_mc.removeEventListener(Event.ENTER_FRAME,_onSlide);
			_grabber 	= null;
			_background = null;
			_mc			= null;
		}
	}
}