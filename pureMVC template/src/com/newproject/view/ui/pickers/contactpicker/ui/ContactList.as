package com.office365.view.ui.pickers.contactpicker.ui
{
	import com.deepfocus.as3.utils.LibraryAssetRetriever;
	import com.deepfocus.as3.utils.TextUtils;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import com.greensock.easing.Strong;
	import com.office365.view.ui.pickers.event.PickerEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class ContactList extends EventDispatcher
	{
		protected var _list:Array;
		protected var _mc:MovieClip;
		protected var _listContainerMC:MovieClip;
		protected var _mcArray:Vector.<MovieClip>;
		protected var _placeMCsArray:Vector.<MovieClip>;
		
		protected var _point_0:Number;
		protected var _point_1:Number;
		protected var _velocity:Number;
		protected var _mouse:Boolean;
		protected var _destY:Number;
		protected var MAX_PULLEDDOWN:int = 0;
		protected var MAX_PUSHEDUP:int = 0;
		protected var _indexToContact:Dictionary;

		public function ContactList($mc:MovieClip, $list:Array)
		{
			_mc = $mc;
			_list = $list;
			
			_init();
		}
		
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------
		public function get mc():MovieClip { return _mc; }

		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		protected function _init():void
		{
		//	trace(this, "_init");
			_mc.addEventListener(Event.REMOVED_FROM_STAGE, _kill, false, 0, true);
			
			_indexToContact = new Dictionary();
			_listContainerMC = _mc.contactlistcontainerMC.listContainerMC;
			createMCs();
			placeMCs();
			_listContainerMC.buttonMode = true;
			_listContainerMC.useHandCursor = true;
			MAX_PUSHEDUP = -(_listContainerMC.height -_mc.contactlistcontainerMC.maskMC.height);
			
			_listContainerMC.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, false, 0, true);
			_listContainerMC.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler, false, 0, true);
			_listContainerMC.addEventListener(MouseEvent.ROLL_OUT, onMouseUpHandler, false, 0, true);
		}
		
		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		public function animateIn():void
		{
			TweenNano.from(_listContainerMC, 1.5, {y:_mc.stage.stageWidth, ease:Strong.easeOut, overwrite:0, onComplete:function():void{
				dispatchEvent(new Event(Event.COMPLETE));
			}});
		}

		/** Populates scrollable Contact list MC.
		 * TODO: Alphabetization logic to mitigate errors outside Flash. */
		protected function createMCs():void{
			_mcArray = new Vector.<MovieClip>();
			var startLetter:String = "";
			var l:int =  _list.length;
			var i:int = 0;
			for ( i = 0; i < l; i++ )
			{
				var person:Object = _list[i];
				var fl:String = person["lastname"].toString().slice(0, 1).toLocaleLowerCase();
				if (fl != startLetter) {
					startLetter = fl;
					var letterBlock:MovieClip = MovieClip(LibraryAssetRetriever.getAsset("letter_row"));
					letterBlock.letterTxt.text = startLetter;

					_mcArray.push(letterBlock);
				} 
				var name:String = person["firstname"].toString() +" "+ person["lastname"].toString()
				var nameBlock:MovieClip = MovieClip(LibraryAssetRetriever.getAsset("name_row"));
				nameBlock.addEventListener(MouseEvent.CLICK, onContactNamedClickHander, false, 0,true);
				nameBlock.nameMC.txt.text = name;
				nameBlock.tweenNameMC.txt.text = name;
				TextUtils.enterBoundedText(nameBlock.nameMC.txt, name, {height:nameBlock.nameMC.txt.height, width:nameBlock.nameMC.txt.width}, null);
				TextUtils.enterBoundedText(nameBlock.tweenNameMC.txt, name, {height:nameBlock.tweenNameMC.txt.height, width:nameBlock.tweenNameMC.txt.width}, null);

				nameBlock.id = i;
				_mcArray.push(nameBlock);
				_indexToContact[i] = nameBlock;
			}	
		}
		
		protected function placeMCs():void
		{
			var l:int =  _mcArray.length;
			var i:int = 0;
			for ( i = 0; i < l; i++ )
			{
				var mc:MovieClip = MovieClip(_mcArray[i]);
				mc.x = 10;
				mc.y = (mc.height * i) + 70;
				_listContainerMC.addChild(mc);
			}	
			_listContainerMC.bkg.height = mc.y + mc.height;
		}
		

		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		protected function _kill($e:Event):void
		{
			//trace(this, "_kill");
			_mc.removeEventListener(Event.REMOVED_FROM_STAGE, _kill, false);
			var l:int = _listContainerMC.numChildren;
			var i:int;
			for ( i = 0; i < l; i++ )
			{
				var mc:DisplayObject = DisplayObject(_listContainerMC.getChildAt(0));
				mc.removeEventListener(MouseEvent.CLICK, onContactNamedClickHander, false);
				_listContainerMC.removeChild(mc);
				mc = null;
			}	
			
			_listContainerMC.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, false);
			_listContainerMC.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler, false);
			_listContainerMC.removeEventListener(MouseEvent.ROLL_OUT, onMouseUpHandler, false);
			_mc.stage.removeEventListener(Event.ENTER_FRAME, onMouseMoveHandler, false);
			_mc.contactlistcontainerMC.removeChild(_listContainerMC);
			_mc.removeChild(_mc.contactlistcontainerMC);
			_listContainerMC = null;
			_list = null;
			_mcArray = null;
			_placeMCsArray = null;
			_indexToContact = null;
		}
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		private function onContactNamedClickHander($e:MouseEvent):void
		{
			if (_velocity < .1 && _velocity > -.1) {
				var mc:MovieClip = MovieClip($e.currentTarget);
				var obj:Object = _list[mc.id];
				obj.index = mc.id;
				mc.gotoAndPlay(2);
				dispatchEvent(new PickerEvent(PickerEvent.SELECTED, obj));
			}
		}
		
		//--------------------------------------------------------------------------
		// USER DRAG ANIMATION 
		//--------------------------------------------------------------------------
		private function onMouseDownHandler($e:MouseEvent):void
		{			
			TweenLite.killTweensOf(_listContainerMC);
			_point_0 = _mc.stage.mouseY;
			
			_mouse = true;
			_mc.stage.addEventListener(Event.ENTER_FRAME, onMouseMoveHandler, false, 0, true);
		}
		
		private function onMouseUpHandler($e:MouseEvent=null):void
		{
			_mouse = false;
			_mc.stage.removeEventListener(Event.ENTER_FRAME, onMouseMoveHandler, false);
			
			if ( _listContainerMC.y > MAX_PULLEDDOWN ) { 
				getToWhereItNeedsToBe("up");
			} else if ( _listContainerMC.y < MAX_PUSHEDUP ) {
				getToWhereItNeedsToBe("down");
			} else {
				_mc.stage.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
		}
		
		private function onMouseMoveHandler($e:Event):void
		{
			_point_1 = _mc.stage.mouseY;
			_velocity = _point_1 - _point_0;			
			_destY = _listContainerMC.y + _velocity;
			_listContainerMC.y += (_destY - _listContainerMC.y)/2;
			_point_0 = _point_1;
		}
		
		private function onEnterFrameHandler($e:Event):void
		{
			_listContainerMC.y = _listContainerMC.y + _velocity;
			_velocity *= .8;
			check();
			if (_velocity < 1 && _velocity > -1) {
				onMouseUpHandler();
				_mc.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
		}
		
		private function getToWhereItNeedsToBe($direction:String):void
		{
			_mc.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			_velocity = 0;
			var destinationY:int =($direction == "down") ? MAX_PUSHEDUP : 0; 
			TweenLite.to(_listContainerMC, 1, {y:destinationY, ease:Strong.easeOut, overwrite:0});
		}
		
		private function check():void
		{
			if ( _listContainerMC.y > MAX_PULLEDDOWN ) { 
				getToWhereItNeedsToBe("up");
			} else if ( _mc.y < MAX_PUSHEDUP ) {
				getToWhereItNeedsToBe("down");
			}
		}
		
		
	}
}