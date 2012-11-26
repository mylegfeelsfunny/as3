package com.office365.view.ui.logocreator
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public final class LogoCreatorAutoPlay extends LogoCreator
	{
		private var _autoPlayTimer:Timer;
		private var _autoPlayCount:int = 0;
		private var _buildString:String = "";

		public function LogoCreatorAutoPlay($mc:MovieClip, $username:String)
		{
			_username = $username
			super($mc, _username);
		}
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		override protected function _init():void
		{
			_mc.mouseEnabled = _mc.mouseChildren = false;
			super._init();			
			_instructions.visible = false;
		}

		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
/*		public function addLogoAndName($name:String, $value:String):void {
			_name = $value;
			
			_autoPlayTimer = new Timer(500, _name.length+1);
			_autoPlayTimer.addEventListener(TimerEvent.TIMER, onAnimateTimerHandler);
			_autoPlayTimer.start();	
		}
*/		
		public function addName($value:String):void {
			_name = $value.toUpperCase();
			//trace(this, "_name.substr(0,1)", _name.substr(0,1));
			if (_name.substr(0,1) == "I") {
				_name = "i"+ _name.substr(1, _name.length-1);
				//trace(this, "_name", _name);
			}
			
			_autoPlayTimer = new Timer(300, _name.length+1);
			_autoPlayTimer.addEventListener(TimerEvent.TIMER, onAnimateTimerHandler);
			_autoPlayTimer.start();	
			
		}

		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		override protected function _destroy():void {
			//_autoPlayTimer.stop();
			//_autoPlayTimer.removeEventListener(TimerEvent.TIMER, onAnimateTimerHandler);
			//_autoPlayTimer = null

			super._destroy();
		}
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		private function onAnimateTimerHandler($e:TimerEvent):void
		{
			if (_autoPlayCount >= _name.length) {
				_autoPlayTimer.stop();
				_autoPlayTimer.removeEventListener(TimerEvent.TIMER, onAnimateTimerHandler);
				_autoPlayTimer = null;
					
				function delayOver($e:TimerEvent):void {
					_autoPlayTimer.stop();
					_autoPlayTimer.removeEventListener(TimerEvent.TIMER, delayOver);
					_autoPlayTimer = null;
					dispatchEvent(new Event("finished"));
				}
					
				_autoPlayTimer = new Timer(600);
				_autoPlayTimer.addEventListener(TimerEvent.TIMER, delayOver);
				_autoPlayTimer.start();	

			} else {
				_buildString += _name.charAt(_autoPlayCount);
				_textfield.text = _buildString;
				positionAccordingly();
			}

			_autoPlayCount++;
		}
		


	}
}