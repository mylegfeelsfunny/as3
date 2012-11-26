package com.office365.view.ui.logocreator
{
	import com.deepfocus.as3.display.section.Section;
	import com.deepfocus.as3.utils.LibraryAssetRetriever;
	import com.greensock.TweenNano;
	import com.greensock.easing.Strong;
	import com.office365.view.ui.pickers.overlay.Overlay;
	import com.office365.view.ui.pickers.overlay.event.OverlayEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class LogoCreator extends Section
	{
		protected var _logo:MovieClip;
		protected var _smallLogo:MovieClip;
		protected var _smallLogoContainer:MovieClip;
		protected var _smallLogoPlacer:MovieClip;
		protected var _textfield:TextField;
		protected var _bkg:MovieClip;
		protected var _icon:MovieClip;
		protected var _name:String = "";
		protected var _username:String = "";
		protected var _overlay:Overlay;
		protected var _profanityOverlay:Overlay;
		protected var _exit:MovieClip;
		protected var _instructions:MovieClip;
		protected var _teamname:MovieClip;
		protected var _user:MovieClip;

		public function LogoCreator($mc:MovieClip, $username:String)
		{
			_username = $username
			super($mc)
		}
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		override protected function _init():void {
			
			_overlay = new Overlay(_mc.overlay);
			_overlay.addEventListener(OverlayEvent.OVERLAY_ACCEPTED, onContactSelectionDone, false, 0, true);
			_overlay.addEventListener(OverlayEvent.OVERLAY_DENIED, onContactSelectionRedo, false, 0, true);
			
			_profanityOverlay = new Overlay(_mc.profanityoverlay);
			_profanityOverlay.addEventListener(OverlayEvent.OVERLAY_ACCEPTED, onCheckProfanityDone, false, 0, true);
			
			_exit = _mc.base.exit;
			_smallLogoPlacer = _mc.base.smalllogoPlacer;
			_smallLogoContainer = _mc.base.smallLogoContainer;
			_instructions = _mc.base.instructions;
			
			_exit.visible = false;
			_exit.buttonMode = true;
			_exit.useHandCursor = true;
			_exit.addEventListener(MouseEvent.CLICK, onExitHandlerClick, false, 0, true);
			
			_teamname = _mc.base.teamname;
			_user = _mc.base.user;

			_teamname.txt.text = _username+ "'s";
			TextField(_teamname.txt).autoSize = TextFieldAutoSize.LEFT;
			_teamname.others.x = _teamname.txt.width + 5;
			
			_user.txt.text = _username;
			
			super._init();
		}

		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
		public function addLogo($name:String):void
		{
			trace(this, "$name", $name);
			_logo = LibraryAssetRetriever.getAsset($name);
			_smallLogo = LibraryAssetRetriever.getAsset($name);
			
			var scale:Number = 30 / _smallLogo.width;
			_smallLogo.scaleX = _smallLogo.scaleY = scale;
			//_smallLogo.x = _smallLogo.width * .5;
			//_smallLogo.y = 0;
			//_smallLogo.cursor.visible = false;

			_smallLogoContainer.addChild(_smallLogo);
			_smallLogoContainer.removeChildAt(0);
			_smallLogoContainer.x = (_smallLogoPlacer.x + (_smallLogoPlacer.width * .5))- (_smallLogoContainer.width * .5);
			_smallLogoContainer.y = (_smallLogoPlacer.y + (_smallLogoPlacer.height * .5))- (_smallLogoContainer.height * .5);
			
			_textfield = _logo.txt;
			
			_bkg = _logo.bkg;
			_icon = _logo.icon;
		//	_logo.cursor.visible = false;
			_mc.base.container.addChild(_logo);
			
			_textfield.addEventListener(MouseEvent.CLICK, onInputTextClickHandler, false, 0, true);
			_textfield.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler, false, 0, true);

			//_logo.stage.focus = _textfield;
			
			_logo.y = (_mc.base.container.bkg.height - _logo.height) * .5;
			positionAccordingly();
			_textfield.text = "";
		}
		
		public function returnLogo():MovieClip
		{
			return _logo;
		}
		
		public function returnName():String
		{
			return _name;
		}
		
		override public function resize(obj:Object):void {
			_mc.base.width = obj.width;
			_mc.base.height = obj.height;	
			_overlay.resize(obj);
			_profanityOverlay.resize(obj);
		}
		
		public function nameIsProfane():void
		{
			_overlay.animateOut();
			_profanityOverlay.animateIn();
		}
		
		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		protected function positionAccordingly():void
		{
			_textfield.autoSize = TextFieldAutoSize.CENTER;
			_textfield.wordWrap = false;
			_textfield.multiline = false
			_textfield.x = -(_textfield.width * .5);
			var w:Number = _textfield.width + 25;
			_textfield.height = 54;

			_bkg.width =(w<198) ? 198 : w;
			_bkg.x = -(_bkg.width * .5);
			_icon.x = -(_icon.width * .5);
			_logo.x = _mc.base.container.bkg.width * .5;
			//_logo.cursor.x = -(_textfield.width * .5) + 10;
		}

		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		override protected function _destroy():void {
			_textfield.removeEventListener(MouseEvent.CLICK, onInputTextClickHandler);
			_textfield.removeEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
			
			_overlay.removeEventListener(OverlayEvent.OVERLAY_ACCEPTED, onContactSelectionDone);
			_overlay.removeEventListener(OverlayEvent.OVERLAY_DENIED, onContactSelectionRedo);
			_profanityOverlay.removeEventListener(OverlayEvent.OVERLAY_ACCEPTED, onCheckProfanityDone);
			
			_exit.removeEventListener(MouseEvent.CLICK, onExitHandlerClick);
			
			_smallLogoContainer.removeChild(_smallLogo);
			_mc.base.removeChild(_smallLogoContainer);
			_mc.base.removeChild(_smallLogoPlacer);
			_smallLogoPlacer = null;
			_smallLogo = null;
			_smallLogoContainer = null;

			_logo = null;
			_textfield = null;
			_bkg = null;
			_icon = null;
			_name = undefined;
		}

		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		private function onExitHandlerClick($e:MouseEvent):void
		{
			if (_name == "") return;
			_overlay.animateIn();
		}
		
		private function onCheckProfanityDone($e:OverlayEvent):void
		{
			_textfield.text = "";
			_exit.visible = false;
			_profanityOverlay.animateOut();
			//_logo.stage.focus = _textfield;
			positionAccordingly();
		}

		private function onContactSelectionDone($e:OverlayEvent):void
		{
			//_textfield.stage.focus = null;

			dispatchEvent(new Event("finished"));
		}
		
		private function onContactSelectionRedo($e:OverlayEvent):void
		{
			_textfield.text = "";
			//_logo.stage.focus = _textfield;
			_exit.visible = false;

			positionAccordingly();
		}
		
		private function onKeyUpHandler($e:KeyboardEvent):void
		{
			if (_instructions.alpha > 0) {
				TweenNano.to(_instructions, .7, {alpha:0, ease:Strong.easeOut, overwrite:0});
			}

			_exit.visible = true;
			_mc.base.addChild(_exit);

			if (_textfield.text.length >= 18) {
				_textfield.text = _name.toUpperCase();
			} else {
				_name = _textfield.text.toUpperCase()
			}
			_textfield.text = _textfield.text.toUpperCase();
			
			positionAccordingly();
		}
		
		private function onInputTextClickHandler($e:MouseEvent):void
		{
			
			_exit.visible = false;
			_textfield.text = "";
		}
				

	}
}