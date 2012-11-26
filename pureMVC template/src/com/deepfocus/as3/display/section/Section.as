package com.deepfocus.as3.display.section{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundTransform;
	
	public class Section extends Sprite {
		protected var _mc:MovieClip;
		protected var _volume:Number;
		
		public function Section($mc:MovieClip) {
			_mc = $mc;
			addEventListener(Event.ADDED_TO_STAGE, _onStage);
		}
		
		public function get volume():Number { return _volume; }
		public function set volume(value:Number):void { _volume = value;  }
		
		protected function _init():void {
			addChild(_mc);
		}
		
		protected function _destroy():void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function setVolume($ratio:Number):void
		{
			_volume = $ratio;
			var transform:SoundTransform = new SoundTransform();
			transform.volume = $ratio;
			_mc.soundTransform = transform;
		}

		public function animateIn():void {
			
		}

		public function animateOut():void {
			
		}

		public function resize(obj:Object):void
		{
		}
		
		protected function _offStage(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _offStage);
			_destroy();
		}

		protected function _onStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onStage);
			addEventListener(Event.REMOVED_FROM_STAGE, _offStage);			
			_init();
		}
	}
}