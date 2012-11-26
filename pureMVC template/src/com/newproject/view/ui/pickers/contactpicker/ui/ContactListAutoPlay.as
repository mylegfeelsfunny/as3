package com.office365.view.ui.pickers.contactpicker.ui
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public final class ContactListAutoPlay extends ContactList
	{
		
		public function ContactListAutoPlay($mc:MovieClip, $list:Array)
		{
			super($mc, $list);
		}
		
		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		override protected function _init():void
		{
			_mc.addEventListener(Event.REMOVED_FROM_STAGE, _kill, false, 0, true);
			_velocity = 0;
			_indexToContact = new Dictionary();
			_listContainerMC = _mc.contactlistcontainerMC.listContainerMC;
			
			
			createMCs();
			placeMCs();
			_listContainerMC.buttonMode = true;
			_listContainerMC.useHandCursor = true;
			MAX_PUSHEDUP = -(_listContainerMC.height -_mc.contactlistcontainerMC.maskMC.height);
		}
		
		/** Auto-scrolls list container MC to show a specific contact at or near the top of the viewport.
		 * @num The index of the contact to be highlighted. */
		public function scrollToIndex(num:int):void{
			var destY:int = _mc.contactlistcontainerMC.maskMC.y;
			var dur:Number = 1;
			var targetMC:DisplayObject;
			
			if(num < 0)	num = 0;
			else if(num > _listContainerMC.numChildren - 1)		num = _listContainerMC.numChildren - 1;
			
			trace('SCROLL TO CONTACT: '+num);
			targetMC = _indexToContact[num];
			destY -= targetMC.y;
			if(destY < MAX_PUSHEDUP)		destY = MAX_PUSHEDUP;
			
			TweenLite.to(_listContainerMC, dur, {y:destY, ease:Strong.easeOut, overwrite:0, delay:.75, onComplete:postAutoScroll, onCompleteParams:[targetMC]});
		}
		
		
		//--------------------------------------------------------------------------
		// PRIVATE 
		//--------------------------------------------------------------------------

		/** Triggered after autoScroll action is completed. Triggers click action. */
		private function postAutoScroll(mc:DisplayObject):void{
			MovieClip(mc).gotoAndPlay(2);
			mc.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

	}
}