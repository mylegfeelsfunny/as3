package com.office365.view.ui.pickers.businesspicker
{
	import com.deepfocus.as3.utils.LibraryAssetRetriever;
	import com.greensock.TweenNano;
	import com.greensock.easing.Strong;
	import com.office365.view.ui.pickers.event.PickerEvent;
	import com.office365.view.ui.pickers.overlay.Overlay;
	import com.office365.view.ui.pickers.overlay.event.OverlayEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	public class BusinessPicker extends EventDispatcher
	{
		protected var _mc:MovieClip;
		private var _xml:XML;
		private var _businesses:MovieClip;
		private var _targets:MovieClip;
		private var _overlay:Overlay;
		private var _businessesLoc:Point
		private var _targetsLoc:Point;
		protected var _instructionsLoc:Point;
		protected var _instructions:MovieClip;
		
		private var _targetName:String = "";
		private var _businessName:String = "";
		protected var _targetID:int = 999;
		protected var _businessID:int = 999;
		protected var _color:String;
		
		private var _autoPlayTimer:Timer;
		private var _autoPlayCount:int = 0;
		private var _autoPlayObject:Object;
		private var AUTOPLAY:Boolean;

		public function BusinessPicker($mc:MovieClip, $xml:XML)
		{
			_mc = $mc;
			_xml = $xml;
			_mc.addEventListener(Event.ADDED_TO_STAGE, _init, false, 0, true);
		}
		//--------------------------------------------------------------------------
		// INIT 
		//--------------------------------------------------------------------------
		protected function _init($e:Event):void
		{
			_mc.removeEventListener(Event.ADDED_TO_STAGE, _init, false);
			_mc.addEventListener(Event.REMOVED_FROM_STAGE, _kill, false, 0, true);

			_businesses = _mc.businessesContainer;
			_targets = _mc.targetsContainer;
			_instructions = _mc.instructions;
			
			var l:int =  _xml.lists.businesses.length();
			var i:int = 0;
			for ( i = 0; i < l; i++ )
			{
				var mc:MovieClip = MovieClip(LibraryAssetRetriever.getAsset("picker_node_large"));
				mc.y = (mc.height + 8) * i;
				mc.tc.txt.multiline = true;
				mc.tc.txt.autoSize = TextFieldAutoSize.LEFT;
				mc.tc.txt.text = _xml.lists.businesses[i];
				mc.tc.y = (mc.height * .5) - (mc.tc.height * .5);
/*				mc.id = _xml.lists.businesses[i].@name;
				mc.name = _xml.lists.businesses[i].@name;
*/				mc.id = i;
				mc.name = _xml.lists.businesses[i].@name;
				mc.useHandCursor = true;
				mc.buttonMode = true;
				mc.addEventListener(MouseEvent.CLICK, onBusinessClickHandler, false, 0, true);
				_businesses.addChild(mc);
			}	
			
	 		l =  _xml.lists.targets.length();
			i = 0;
			for ( i = 0; i < l; i++ )
			{
				mc = MovieClip(LibraryAssetRetriever.getAsset("picker_node_small"));
				mc.y = (mc.height + 12) * i;
				mc.txt.text = _xml.lists.targets[i];
				mc.id = i;
				mc.name = _xml.lists.targets[i].@name;
				mc.color = _xml.lists.targets[i].@color;
				mc.useHandCursor = true;
				mc.buttonMode = true;
				mc.addEventListener(MouseEvent.CLICK, onTargetClickHandler, false, 0, false);
				_targets.addChild(mc);
			}	
			
			_businessesLoc = new Point(_businesses.x, _businesses.y);
			_targetsLoc = new Point(_targets.x, _targets.y);
			_instructionsLoc = new Point(_instructions.x, _instructions.y);
			
			_overlay = new Overlay(_mc.overlay);
			_overlay.addEventListener(OverlayEvent.OVERLAY_ACCEPTED, onBusinessSelectionDone, false, 0, true);
			_overlay.addEventListener(OverlayEvent.OVERLAY_DENIED, onBusinessSelectionRedo, false, 0, true);
			
		}
	
		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		protected function _kill($e:Event):void
		{
			_mc.removeEventListener(Event.REMOVED_FROM_STAGE, _kill, false);
			//trace(this, "_kill");
			
			clearChildren(_businesses);
			clearChildren(_targets);
			_mc.removeChild(_mc.bkg);
			_mc.removeChild(_overlay.mc);
			_mc.bkg = null;
			_overlay = null;
			_targetsLoc = null;
			_businessesLoc = null;
			_xml = null;
			
		}

		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
		public function resize(obj:Object):void {
			_mc.bkg.width = obj.width;
			_mc.bkg.height = obj.height;
			
			var scale:Number = obj.width/960;
			_businesses.scaleX = _businesses.scaleY = scale;
			_targets.scaleX = _targets.scaleY = scale;
			_instructions.scaleX = _instructions.scaleY = scale;
			
			_businesses.x = _businessesLoc.x * scale;
			_businesses.y = _businessesLoc.y * scale;
			_targets.x = _targetsLoc.x * scale;
			_targets.y = _targetsLoc.y * scale;
			_instructions.x = _instructionsLoc.x * scale;
			_instructions.y = _instructionsLoc.y * scale;

			_overlay.resize(obj);
		}
		
		public function selectBusiness($id:int):void
		{
			clearBtn(_businesses);
			select(_businesses, $id);
			_businessID = $id;
			checkOver();
		}
		
		public function selectTarget($id:int):void
		{
			clearBtn(_targets);
			select(_targets, $id);
			_targetID = $id;
			_color = _xml.lists.targets[$id].@color;

			checkOver();
		}
		
		private function select($parent:MovieClip, $child:int):void
		{
			var l:int = $parent.numChildren;
			var i:int = 0;
			for ( i = 0; i < l; i++ )
			{
				var mc:MovieClip = MovieClip($parent.getChildAt(i));
				if (mc.id == $child) {
					mc.gotoAndStop(2);
					break;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------------------------------------------
		private function clearChildren($mc:MovieClip):void
		{
			var l:int =  $mc.numChildren;
			var i:int = 0;
			for ( i = 0; i < l; i++ )
			{
				var mc:MovieClip = MovieClip($mc.getChildAt(0));
				$mc.removeChild(mc);
				mc = null;
			}
			$mc = null;
		}
		
		private function clearBtn($mc:MovieClip):void
		{
			var l:int =  $mc.numChildren;
			var i:int = 0;
			for ( i = 0; i < l; i++ )
			{
				var mc:MovieClip = MovieClip($mc.getChildAt(i));
				mc.gotoAndStop(1);
			}
		}
		
		protected function checkOver():void
		{
			//trace(this, _targetID, _businessID);
			if (( _targetID != 999 && _businessID != 999 ) && AUTOPLAY == false) {
				_overlay.animateIn()
			}
			if (_instructions.alpha > 0) {
				TweenNano.to(_instructions, .7, {alpha:0, ease:Strong.easeOut, overwrite:0});
			}
		}
		

		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		private function onBusinessSelectionDone($e:OverlayEvent):void
		{
			var obj:Object = {}
			obj.target = _targetID;
			obj.business = _businessID;
			obj.color = _color;
			dispatchEvent(new PickerEvent(PickerEvent.SELECTION_FINISHED, obj));
		}
		
		private function onBusinessSelectionRedo($e:OverlayEvent):void
		{
			_targetID = 999;
			_businessID = 999;
			clearBtn(_businesses);
			clearBtn(_targets);

		}
		
		private function onBusinessClickHandler($e:MouseEvent):void
		{
			var b:MovieClip = MovieClip($e.currentTarget);
			selectBusiness(b.id);
		}
		
		private function onTargetClickHandler($e:MouseEvent):void
		{
			var t:MovieClip = MovieClip($e.currentTarget);
			selectTarget(t.id);
		}
		
		
	}
}