package com.deepfocus.as3.display.volumeslider
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	public class VolumeSlider extends EventDispatcher
	{
		private var _soundSymbolMC:MovieClip;
		private var _sliderMC:MovieClip;
		private var _slider:Slider;
		private var _callback:Function;
		
		public function VolumeSlider($mc:MovieClip, $callback:Function)
		{
			_sliderMC = $mc.soundSlider;
			_soundSymbolMC = $mc.soundSymbol;
			_callback = $callback;
			_slider = new Slider(_sliderMC, onSliderValueChanged);
			_slider.value = 1;
			_init();
		}
		
		public function set volume($value:Number):void
		{
			_slider.value = $value;
			_callback($value);
		}
		
		private function _init():void
		{
			_sliderMC.visible = false;
			_sliderMC.buttonMode = true;
			_sliderMC.useHandCursor = true;
			_soundSymbolMC.buttonMode = true;
			_soundSymbolMC.useHandCursor = true;
			_soundSymbolMC.addEventListener(MouseEvent.ROLL_OVER, onSoundSymbolRollOver, false, 0, true);
		}
		
		private function onSoundSymbolRollOver($e:MouseEvent):void
		{
			_soundSymbolMC.removeEventListener(MouseEvent.ROLL_OVER, onSoundSymbolRollOver, false);

			_sliderMC.visible = true;
			_soundSymbolMC.visible = false;
			_sliderMC.addEventListener(MouseEvent.ROLL_OUT, onSliderMCRollOut, false, 0, true);
		}
		
		private function onSliderMCRollOut($e:MouseEvent):void
		{
			_soundSymbolMC.addEventListener(MouseEvent.ROLL_OVER, onSoundSymbolRollOver, false, 0, true);
			_sliderMC.removeEventListener(MouseEvent.ROLL_OUT, onSliderMCRollOut, false);
			_slider.onBarMouseUp();
			_sliderMC.visible = false;
			_soundSymbolMC.visible = true;
		}

		private function onSliderValueChanged($value:Number):void
		{
			if ($value < .01) {
				_soundSymbolMC.gotoAndStop(4)
			} else if ($value >= .01 && $value <.4) {
				_soundSymbolMC.gotoAndStop(3);
			} else if ($value >= .4 && $value <.7) {
				_soundSymbolMC.gotoAndStop(2);
			}  else {
				_soundSymbolMC.gotoAndStop(1);
			}
			_callback($value);
		}
	}
}