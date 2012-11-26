package com.deepfocus.as3.display.widgets.videoPlayer{


	import com.bigspaceship.utils.Out;
	import com.deepfocus.as3.display.widgets.Slider;
	import com.deepfocus.as3.events.SliderEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class ControlerSlider extends Slider{
		
		protected var _position								:Number;
		
		public function ControlerSlider($mc:MovieClip,$background:MovieClip){
			super($mc,$background);
		}
		protected override function _init():void{
			super._init();
			_grabber.addEventListener(MouseEvent.ROLL_OVER,_onMouseOver,false,0,true);
			_grabber.addEventListener(MouseEvent.ROLL_OUT,_onMouseOut,false,0,true);
		}
		protected override function _onMouseDown($evt:MouseEvent):void{
			Out.status(this, '_onMouseDown()');
			var r:Rectangle = new Rectangle(_background.x,_grabber.y,_background.x+_background.width,0);
			_mc.stage.addEventListener(MouseEvent.MOUSE_UP,_onMouseUp,false,0,true);
			_mc.addEventListener(Event.ENTER_FRAME,_onSlide,false,0,true);
			_grabber.startDrag(true,r);
			dispatchEvent($evt);
		}
		protected function _onMouseOver($evt:MouseEvent):void{
			_grabber.gotoAndStop('OVER');
		}
		protected function _onMouseOut($evt:MouseEvent):void{
			_grabber.gotoAndStop('OUT');
		}
		protected override function _onSlide($evt:Event=null):void{
			_position = _grabber.x / _background.width;
			dispatchEvent(new SliderEvent(SliderEvent.ON_STEP,_position));
		}
		public function get position():Number{
			return _position;
		}
		public override function kill():void{
			_grabber.removeEventListener(MouseEvent.ROLL_OVER,_onMouseOver);
			_grabber.removeEventListener(MouseEvent.ROLL_OUT,_onMouseOut);
			_position					= undefined;
			super.kill();
		}	
	}
}