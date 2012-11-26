package com.deepfocus.as3.display.volumeslider{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Slider extends EventDispatcher
	{
		private var _mc				:MovieClip;
		private var _bar			:MovieClip;
		private var _line			:MovieClip;
		private var _scrubTimer		:Timer;
		private var _value			:Number;
		private var _callBack		:Function;
		
		public function Slider($mc:MovieClip, $callBack:Function)
		{
			_mc = $mc;
			_callBack = $callBack;
			_line = _mc.line;
			_bar = _mc.bar;
			_init();
		}
		
		public function get maxY():Number { 
			return (_line.height + _line.y ) - _bar.height; 
		}
		
		public function get minY():Number { 
			return _line.y; 
		}
		
		public function set value($value:Number):void
		{
			_value =  1 - $value;
			_bar.y = (_value * maxY)+_line.y;
		}
		
		public function get value():Number { return _value; }
		public function get mc():MovieClip { return _mc; }
		
		private function _init():void
		{
			_bar.addEventListener(MouseEvent.MOUSE_DOWN, onBarMouseDown, false, 0, true);
		}
		
		private function onBarMouseDown($e:MouseEvent):void
		{
			//_bar.removeEventListener(MouseEvent.MOUSE_DOWN, onBarMouseDown, false);
			_mc.addEventListener(MouseEvent.MOUSE_UP, onBarMouseUp, false, 0, true);
			
			_scrubTimer = new Timer(100);
			_scrubTimer.addEventListener(TimerEvent.TIMER, onMoveSliderBar, false, 0, true);
			_scrubTimer.start();	
		}
		private function onMoveSliderBar($e:TimerEvent):void
		{
			var destY:Number = _mc.mouseY;
			if (destY < minY) destY = minY;
			else if (destY > maxY) destY = maxY;
			_bar.y = destY;
			
			var ratio:Number = 1 - (_bar.y / maxY);
			_value = ratio;
			_callBack(_value);
		}
		public function onBarMouseUp($e:MouseEvent=null):void
		{
			killTimer();
			_mc.removeEventListener(MouseEvent.MOUSE_UP, onBarMouseUp, false);
			//_bar.addEventListener(MouseEvent.MOUSE_DOWN, onBarMouseDown, false, 0, true);
		}
		
		public function killTimer():void
		{
			if(_scrubTimer){
				_scrubTimer.stop();	
				_scrubTimer.removeEventListener(TimerEvent.TIMER, onMoveSliderBar, false);
				_scrubTimer =null;
			}
		}
		
		public function kill():void
		{
			_mc.removeEventListener(MouseEvent.MOUSE_UP, onBarMouseUp, false);
			killTimer();
			_line = null;
			_bar = null;
			_mc = null;
			
		}
		
	}
}