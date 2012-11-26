package com.office365.view.ui.pickers.businesspicker
{
	import com.office365.view.ui.pickers.event.PickerEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public final class BusinessPickerAutoPlay extends BusinessPicker
	{
		private var _autoPlayTimer:Timer;
		private var _autoPlayCount:int = 0;
		private var _autoPlayObject:Object;
		
		public function BusinessPickerAutoPlay($mc:MovieClip, $xml:XML, $obj:Object)
		{
			_autoPlayObject = $obj;
			super($mc, $xml);
		}
		
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		override protected function _init($e:Event):void
		{
			_mc.mouseEnabled = _mc.mouseChildren = false;
			super._init($e);			
			_instructions.visible = false;
		}

		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
		public function play():void
		{
			_autoPlayTimer = new Timer(2000, 3);
			_autoPlayTimer.addEventListener(TimerEvent.TIMER, onAnimateTimerHandler);
			_autoPlayTimer.start();	
		}

		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		override protected function checkOver():void
		{
			//if ((_targetName.length != 0 && _businessName.length != 0) && AUTOPLAY == false) {
			//	_overlay.animateIn()
			//}
		}
		
		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		override protected function _kill($e:Event):void {
			_autoPlayTimer.stop();
			_autoPlayTimer.removeEventListener(TimerEvent.TIMER, onAnimateTimerHandler);
			_autoPlayTimer = null
			_autoPlayObject = null;
			super._kill($e);
		}
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		private function onAnimateTimerHandler($e:TimerEvent):void
		{
			switch (_autoPlayCount)
			{
				case 0:
					selectBusiness(_autoPlayObject.business);
					break;
				case 1:
					selectTarget(_autoPlayObject.target);
					break;
				case 2:
					var obj:Object = {}
					obj.target = _targetID;
					obj.business = _businessID;
					obj.color = _color;
					dispatchEvent(new PickerEvent(PickerEvent.SELECTION_FINISHED, obj));
					break;
			}
			_autoPlayCount++;
		}

	}
}