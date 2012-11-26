package com.office365.view.ui.pickers.contactpicker
{
	import com.adobe.utils.ArrayUtil;
	import com.deepfocus.as3.utils.LibraryAssetRetriever;
	import com.greensock.TweenNano;
	import com.greensock.easing.Strong;
	import com.office365.ApplicationFacade;
	import com.office365.model.DataCacheProxy;
	import com.office365.view.ui.pickers.contactpicker.ui.ContactList;
	import com.office365.view.ui.pickers.contactpicker.ui.ContactSelection;
	import com.office365.view.ui.pickers.event.PickerEvent;
	import com.office365.view.ui.pickers.overlay.Overlay;
	import com.office365.view.ui.pickers.overlay.event.OverlayEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class ContactPicker extends EventDispatcher
	{
		protected var _contactList:ContactList;
		protected var _mc:MovieClip;
		protected var _selectedContactContainer:MovieClip;
		protected var _overlay:Overlay;
		protected var _instructions:MovieClip;

		protected var _list:Array;
		protected var _pickerLoc:Point
		protected var _listLoc:Point;
		protected var _instructionsLoc:Point;
		protected var _startIndex:int;
		
		/** Mostly useful in autoPlay mode, the index (in the teammates array) of the last highlighted contact. */
//		private var AUTOPLAY:Boolean;
//		private var _teammateIndex:int;
//		private var _autoPlayArray:Array;
//		private var _timer:Timer;
		
		//private var _dcProxy:DataCacheProxy;

		public function ContactPicker($mc:MovieClip, $list:Array){
			var facade:ApplicationFacade = ApplicationFacade.getInstance();
			_mc = $mc;
			_list = $list;
			//_dcProxy = facade.retrieveProxy(DataCacheProxy.NAME) as DataCacheProxy;
			_mc.addEventListener(Event.ADDED_TO_STAGE, _init, false, 0, true);
		}
		
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------
		public function get mc():MovieClip { return _mc; }
//		public function get autoPlayArray():Array { return _autoPlayArray; }
//		public function set autoPlayArray(value:Array):void { _autoPlayArray = value;  }


		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		protected function _init($e:Event):void
		{
			_mc.removeEventListener(Event.ADDED_TO_STAGE, _init, false);
			_mc.addEventListener(Event.REMOVED_FROM_STAGE, _kill, false, 0, true);
			
			_selectedContactContainer = _mc.selectedContactContainer;
			_instructions = _mc.instructions;
			
			_overlay = new Overlay(_mc.overlay);
			_overlay.addEventListener(OverlayEvent.OVERLAY_ACCEPTED, onContactSelectionDone, false, 0, true);
			_overlay.addEventListener(OverlayEvent.OVERLAY_DENIED, onContactSelectionRedo, false, 0, true);
			
			_contactList = new ContactList(_mc, _list);
			_contactList.addEventListener(PickerEvent.SELECTED, onContactSelectedHandler, false, 0, true);
			
			_pickerLoc = new Point(_mc.contactlistcontainerMC.x, _mc.contactlistcontainerMC.y);
			_listLoc = new Point(_selectedContactContainer.x, _selectedContactContainer.y);
			_instructionsLoc = new Point(_instructions.x, _instructions.y);
		}

		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
		public function resize(obj:Object):void {
			_mc.bkg.width = obj.width;
			_mc.bkg.height = obj.height;
			_mc.bkg.list.cover.visible = false;
			
			var scale:Number = obj.width/960
			_mc.contactlistcontainerMC.scaleX = _mc.contactlistcontainerMC.scaleY = scale;
			_mc.selectedContactContainer.scaleX = _mc.selectedContactContainer.scaleY = scale;
			_instructions.scaleX = _instructions.scaleY = scale;
			
			_mc.contactlistcontainerMC.x = _pickerLoc.x * scale;
			_mc.contactlistcontainerMC.y = _pickerLoc.y * scale;
			_mc.selectedContactContainer.x = _listLoc.x * scale;
			_mc.selectedContactContainer.y = _listLoc.y * scale;
			_instructions.x = _instructionsLoc.x * scale;
			_instructions.y = _instructionsLoc.y * scale;
			//_mc.contactlistcontainerMC.x = obj.width * .2;
			//_mc.selectedContactContainer.x = obj.width * .5;
			
			_overlay.resize(obj);
		}
		
		public function animateIn():void
		{
			_contactList.addEventListener(Event.COMPLETE, onAnimateInCompleteHandler, false, 0, true);
			_contactList.animateIn();
		}
		
		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		protected function onAnimateInCompleteHandler($e:Event):void
		{
			_mc.bkg.list.cover.visible = true;
		}

		protected function checkReady():Boolean{
			return (_selectedContactContainer.numChildren >=3);
		}
		
		protected function thereAlready($test:int):Boolean
		{
			var hereAlready:Boolean = false;
			var l:int = _selectedContactContainer.numChildren;
			var i:int = 0;
			for ( i = 0; i < l; i++ ) {
				var mc:ContactSelection = ContactSelection(_selectedContactContainer.getChildAt(i));
				if (int(mc.id) == $test) hereAlready = true;
			}
			return hereAlready;
		}
		
		protected function reframe():void
		{
			var l:int = _selectedContactContainer.numChildren;
			var i:int = 0;
			for ( i = 0; i < l; i++ )
			{
				//trace(this, "i", _selectedContactContainer.getChildAt(i));
				var mc:ContactSelection = ContactSelection(_selectedContactContainer.getChildAt(i));
				mc.y = (mc.height + 10) * i;
			}	
		}

		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		protected function _kill($e:Event):void
		{
			_mc.removeEventListener(Event.REMOVED_FROM_STAGE, _kill, false);
			_overlay.removeEventListener(OverlayEvent.OVERLAY_ACCEPTED, onContactSelectionDone);
			_overlay.removeEventListener(OverlayEvent.OVERLAY_DENIED, onContactSelectionRedo);
			_contactList.removeEventListener(PickerEvent.SELECTED, onContactSelectedHandler);
			
			removeSelectedChildren();
			_mc.removeChild(_selectedContactContainer);
			_mc.removeChild(_overlay.mc);
			_overlay = null;
			
			_pickerLoc = null;
			_listLoc = null;
			_contactList = null;
		}
		
		private function removeSelectedChildren():void
		{
			var l:int = _selectedContactContainer.numChildren;
			var i:int = 0;
			for(i = 0; i < l; i++){
				var mc:ContactSelection = ContactSelection(_selectedContactContainer.getChildAt(0));
				mc.removeEventListener(PickerEvent.REMOVE_SELECTED, onSelectedRemoveHandler, false);
				_selectedContactContainer.removeChild(mc);
				mc = null;
			}	
		}

		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		protected function onContactSelectionDone($e:*):void
		{
			var arr:Array = [];
			var l:int = _selectedContactContainer.numChildren;
			var i:int = 0;
			for ( i = 0; i < l; i++ )
			{
				//trace(this, "i", _selectedContactContainer.getChildAt(i));
				var mc:ContactSelection = ContactSelection(_selectedContactContainer.getChildAt(i));
				arr.push(mc.id);
			}	
			var obj:Object = {}
			obj["chosencontacts"] = arr;

			dispatchEvent(new PickerEvent(PickerEvent.SELECTION_FINISHED, obj));
		}
		
		protected function onContactSelectionRedo($e:OverlayEvent):void
		{
			removeSelectedChildren();
		}

		private function onSelectedRemoveHandler($e:PickerEvent):void
		{
			//trace(this, "e.currentTarget", $e.currentTarget );
			var killed:ContactSelection = ContactSelection($e.currentTarget)
			_mc.selectedContactContainer.removeChild(killed);
			
			killed = null;
			reframe();
		}

		protected function onContactSelectedHandler($e:PickerEvent):void{
			if (_instructions.alpha > 0) {
				TweenNano.to(_instructions, .7, {alpha:0, ease:Strong.easeOut, overwrite:0});
			}

			if (thereAlready($e.data.index))		return;
			var selectedcontactMC:MovieClip = MovieClip(LibraryAssetRetriever.getAsset("selectedcontact"));
			var contact:ContactSelection = new ContactSelection(selectedcontactMC, $e.data);
			contact.id = $e.data.index;
			contact.addEventListener(PickerEvent.REMOVE_SELECTED, onSelectedRemoveHandler, false, 0, true);
			_mc.selectedContactContainer.addChild(contact);
			reframe();
			
			if (checkReady()) {
				_overlay.animateIn();
			} 
		}

		
	}
}