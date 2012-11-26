package com.ui
{
	import com.greensock.TweenNano;
	import com.greensock.easing.Quad;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class EndOverlay extends EventDispatcher
	{
		private var _mc					:MovieClip;
	
		public function EndOverlay($mc:MovieClip)
		{
			_mc = $mc;
			_mc.addEventListener(Event.ADDED_TO_STAGE, _init, false, 0, true);
			_mc.addEventListener(Event.REMOVED_FROM_STAGE, _kill, false, 0, true);
		}
		
		public function get mc():MovieClip { return _mc; }

		private function _init($e:Event):void
		{
			_mc.removeEventListener(Event.ADDED_TO_STAGE, _init, false);
			
			_mc.replayBtn.addEventListener(MouseEvent.CLICK, onReplayBtnClicked, false, 0, true);
			
			_mc.facebookBtn.addEventListener(MouseEvent.CLICK, onShareBtnClick, false, 0, true);
			_mc.twitterBtn.addEventListener(MouseEvent.CLICK, onShareBtnClick, false, 0, true);
			//_mc.mailBtn.addEventListener(MouseEvent.CLICK, onShareBtnClick, false, 0, true);
			
			_mc.facebookBtn.addEventListener(MouseEvent.ROLL_OVER, onShareBtnRollOver, false, 0, true);
			_mc.twitterBtn.addEventListener(MouseEvent.ROLL_OVER, onShareBtnRollOver, false, 0, true);
			//_mc.mailBtn.addEventListener(MouseEvent.ROLL_OVER, onShareBtnRollOver, false, 0, true);
			
			_mc.facebookBtn.addEventListener(MouseEvent.ROLL_OUT, onShareBtnRollOut, false, 0, true);
			_mc.twitterBtn.addEventListener(MouseEvent.ROLL_OUT, onShareBtnRollOut, false, 0, true);
			//_mc.mailBtn.addEventListener(MouseEvent.ROLL_OUT, onShareBtnRollOut, false, 0, true);
			
			_mc.facebookBtn.buttonMode = true;
			_mc.twitterBtn.buttonMode = true;
			//_mc.mailBtn.buttonMode = true;
			
			_mc.facebookBtn.useHandCursor = true;
			_mc.twitterBtn.useHandCursor = true;
			//_mc.mailBtn.useHandCursor = true;
		}
		
		private function _kill($e:Event):void
		{
			_mc.facebookBtn.removeEventListener(MouseEvent.CLICK, onShareBtnClick, false);
			_mc.twitterBtn.removeEventListener(MouseEvent.CLICK, onShareBtnClick, false);
			//_mc.mailBtn.removeEventListener(MouseEvent.CLICK, onShareBtnClick, false);
			
			_mc.facebookBtn.removeEventListener(MouseEvent.ROLL_OVER, onShareBtnRollOver, false);
			_mc.twitterBtn.removeEventListener(MouseEvent.ROLL_OVER, onShareBtnRollOver, false);
			//_mc.mailBtn.removeEventListener(MouseEvent.ROLL_OVER, onShareBtnRollOver, false);
			
			_mc.facebookBtn.removeEventListener(MouseEvent.ROLL_OUT, onShareBtnRollOut, false);
			_mc.twitterBtn.removeEventListener(MouseEvent.ROLL_OUT, onShareBtnRollOut, false);
			//_mc.mailBtn.removeEventListener(MouseEvent.ROLL_OUT, onShareBtnRollOut, false);
		
			_mc.replayBtn.removeEventListener(MouseEvent.CLICK, onReplayBtnClicked, false);
			_mc.removeEventListener(Event.REMOVED_FROM_STAGE, _kill, false);
			_mc.removeChild(_mc.twitterBtn);
			//_mc.removeChild(_mc.mailBtn);
			_mc.removeChild(_mc.facebookBtn);
			_mc.removeChild(_mc.replayBtn);
		}

		private function onReplayBtnClicked($e:MouseEvent):void
		{
			dispatchEvent(new Event("replayBtn_clicked"));
		}

		private function onShareBtnClick($e:MouseEvent):void
		{//window.open ('http://www.facebook.com/sharer/sharer.php?u=http%3A%2F%2Fdev.thelongkhan.com?1','mywindow','menubar=1,resizable=1,width=500,height=400');
			trace($e.currentTarget.name)
			switch ($e.currentTarget.name)
			{
				case "twitterBtn":
					var request:URLRequest = new URLRequest("http://twitter.com/?status=I%20just%20took%20part%20in%20the%20longest%20%22KHAAAN!%22%20scream%20in%20history.%20Check%20it%20out%3A%20http%3A%2F%2Fwww.thelongkhan.com%20%40EpixHD%20%23TheLongKhan%20%23StarTrek2");
					//request.data = variables;
					try {            
						navigateToURL(request);
					}
					catch (e:Error) {
						// handle error here
					}

					break;
				case "facebookBtn":
					try {            
						ExternalInterface.call("window.open", 'http://www.facebook.com/sharer/sharer.php?u=http%3A%2F%2Fwww.thelongkhan.com','mywindow','menubar=1,resizable=1,width=500,height=400');
					}
					catch (e:Error) {
						// handle error here
					}
					break;
				case "mailBtn":
					
					break;
			}

		}
		
		private function onShareBtnRollOver($e:MouseEvent):void
		{
			TweenNano.to($e.currentTarget, .2, {alpha:.8, ease:Quad.easeOut, overwrite:0});
		}
		
		private function onShareBtnRollOut($e:MouseEvent):void
		{
			TweenNano.to($e.currentTarget, .2, {alpha:1, ease:Quad.easeOut, overwrite:0});
		}
	}
}