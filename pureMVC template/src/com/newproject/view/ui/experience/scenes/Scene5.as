package com.office365.view.ui.experience.scenes
{
	import com.deepfocus.as3.utils.LibraryAssetRetriever;
	import com.deepfocus.as3.utils.TextUtils;
	import com.greensock.TweenNano;
	import com.greensock.easing.Strong;
	import com.office365.ApplicationFacade;
	import com.office365.model.DataCacheProxy;
	import com.office365.view.ui.experience.event.SceneEvent;
	import com.office365.view.ui.logocreator.LogoCreator;
	import com.office365.view.ui.logocreator.LogoCreatorAutoPlay;
	import com.office365.view.ui.pickers.businesspicker.BusinessPicker;
	import com.office365.view.ui.pickers.businesspicker.BusinessPickerAutoPlay;
	import com.office365.view.ui.pickers.event.PickerEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public final class Scene5 extends FlashScene
	{
		private var _buinessPickerMC:MovieClip;
		private var _businessPicker:*;
		private var _logoCreator:LogoCreator;
		private var _sharepoint:MovieClip;
		private var _logoObj:Object;
		private var _dcProxy:DataCacheProxy
		protected var _teamname:MovieClip;
		protected var _user:MovieClip;

		public function Scene5($linkedIn:Object, $classInfo:Object)
		{
			super($linkedIn, $classInfo);
		}
		
		override public function prepareBody():void
		{
			var facade:ApplicationFacade = ApplicationFacade.getInstance();
			_dcProxy = facade.retrieveProxy(DataCacheProxy.NAME) as DataCacheProxy;

			trace(this, "prepareBody", _linkedIn );
			_logoObj = {};
			_buinessPickerMC = LibraryAssetRetriever.getAsset("buisnesspicker");
			var logoCreatorMC:MovieClip = LibraryAssetRetriever.getAsset("logo_creator_mc");
			if (_linkedIn["playmode"] >= 1) {
				_businessPicker = new BusinessPickerAutoPlay(_buinessPickerMC, _xml, _linkedIn["chosenlogo"]);
				_logoCreator = new LogoCreatorAutoPlay(logoCreatorMC, _linkedIn["firstname"]+ " "+_linkedIn["lastname"]);
			} else {
				_businessPicker = new BusinessPicker(_buinessPickerMC, _xml);
				//_logoCreator = new LogoCreator(logoCreatorMC, _linkedIn["first-name"]+ " "+_linkedIn["last-name"]);
				_logoCreator = new LogoCreatorAutoPlay(logoCreatorMC, _linkedIn["firstname"]+ " "+_linkedIn["lastname"]);
			}
			

			_businessPicker.addEventListener(PickerEvent.SELECTION_FINISHED, onBusinessSelectionCompleteHandler, false, 0, true);
			_body.addChild(_buinessPickerMC);
			
			_logoCreator.visible = false;
			_body.addChild(_logoCreator);
			
			_sharepoint = LibraryAssetRetriever.getAsset("sharepoint_mc");
			_sharepoint.visible = false;
			_body.addChild(_sharepoint);
			
			
			super.prepareBody();
		}

		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
		override public function playSection():void { 
			if (_linkedIn["playmode"] >= 1) {
				BusinessPickerAutoPlay(_businessPicker).play();
			}
			
			var obj:Object = {origin:"experience", scene:"5"}
			dispatchEvent(new SceneEvent(SceneEvent.TRACKING, obj));

			super.playSection();
		}
		
		override public function resize(obj:Object):void
		{
			try	{
			_businessPicker.resize(obj);
			_logoCreator.resize(obj);

			_logoCreator.width = obj.width;
			_logoCreator.height = obj.height;
		
			_sharepoint.width = obj.width;
			_sharepoint.height = obj.height;
			
			_body.y = obj.offsetY;
			} catch($e:Error) {trace(this, "$e;Error", $e.message);}
		}
		
		public function profanityResponse($isProfane:Boolean):void
		{
/*			if ($isProfane==true) {
				_logoCreator.nameIsProfane();
			} else {
				_logoObj.name = _logoCreator.returnName();
				_dcProxy.logoData = _logoObj;
				_dcProxy.logo = _logoCreator.returnLogo();
				dispatchEvent(new SceneEvent(SceneEvent.SAVE_DATA_EVENT, _logoObj));
				dispatchFinished();
			}
*/		}

		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		override public function destroyBody($e:Event):void {
			_body.removeChild(_buinessPickerMC);
			_businessPicker = null;
			
			_body.removeChild(_logoCreator);
			_logoCreator = null;
			
			_body.removeChild(_sharepoint);
			_sharepoint = null;
			super.destroyBody($e);
		}

		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		private function onBusinessSelectionCompleteHandler($e:PickerEvent):void
		{
			_logoObj.business = $e.data.business;
			_logoObj.target = $e.data.target;
			_logoObj.color = $e.data.color;
			_logoObj.targetText = _xml.lists.targets[int($e.data.target)];
			_logoObj.businessText = _xml.lists.businesses[int($e.data.business)];
			_logoObj.frame = _xml.lists.targets[int($e.data.target)].@name;
			_logoCreator.addLogo("logo_"+$e.data.target);
			
			var nameString:String = "_"+_logoObj.business+"|"+_logoObj.target;
			_logoObj.name = _xml.dictionary.item.(@id == nameString);
			
			trace(this, "nameString				:: ", nameString);
			trace(this, "_logoObj.business		:: ", _logoObj.business);
			trace(this, "_logoObj.target		:: ", _logoObj.target);
			trace(this, "_logoObj.color			:: ", _logoObj.color);
			trace(this, "_logoObj.name			:: ", _logoObj.name);
			trace(this, "_logoObj.targetText	:: ", _logoObj.targetText);
			trace(this, "_logoObj.businessText	:: ", _logoObj.businessText);
			trace(this, "_logoObj.frame			:: ", _logoObj.frame);
			
			var friends:Array = _dcProxy.teammates;
			var friend0:String = friends[0]["firstname"] + " " + friends[0]["lastname"];
			var friend1:String = friends[1]["firstname"] + " " + friends[1]["lastname"];
			var friend2:String = friends[2]["firstname"] + " " + friends[2]["lastname"];

			//_sharepoint.name_0TXT.text = friends[0]["first-name"] + " " + friends[0]["last-name"];
			TextUtils.enterBoundedText(_sharepoint.name_0TXT, friend0, {height:_sharepoint.name_0TXT.height, width:_sharepoint.name_0TXT.width}, null);

			//_sharepoint.name_1TXT.text = friends[1]["first-name"] + " " + friends[1]["last-name"];
			TextUtils.enterBoundedText(_sharepoint.name_1TXT, friend1, {height:_sharepoint.name_1TXT.height, width:_sharepoint.name_1TXT.width}, null);

			//_sharepoint.name_2TXT.text = friends[0]["first-name"] + " " + friends[0]["last-name"];
			TextUtils.enterBoundedText(_sharepoint.name_2TXT, friend0, {height:_sharepoint.name_2TXT.height, width:_sharepoint.name_2TXT.width}, null);

			//_sharepoint.name_3TXT.text = friends[2]["first-name"] + " " + friends[2]["last-name"];
			TextUtils.enterBoundedText(_sharepoint.name_3TXT, friend2, {height:_sharepoint.name_3TXT.height, width:_sharepoint.name_3TXT.width}, null);

			//_sharepoint.name_4TXT.text = friends[1]["first-name"] + " " + friends[1]["last-name"];
			TextUtils.enterBoundedText(_sharepoint.name_4TXT, friend1, {height:_sharepoint.name_4TXT.height, width:_sharepoint.name_4TXT.width}, null);

			
			_teamname = _sharepoint.teamname;
			_user = _sharepoint.user;
			
			_teamname.txt.text = _linkedIn["firstname"]+ " "+_linkedIn["lastname"]+ "'s";
			TextField(_teamname.txt).autoSize = TextFieldAutoSize.LEFT;
			_teamname.others.x = _teamname.txt.width + 5;
			_user.txt.text = _linkedIn["firstname"]+ " "+_linkedIn["lastname"];
			
			_buinessPickerMC.visible = false;
			_sharepoint.visible = true;
			
			TweenNano.to(_sharepoint.highlight, 1, {delay:2, alpha:1, ease:Strong.easeOut, onComplete:bringInLogoCreator, overwrite:0});
		}
		
		private function bringInLogoCreator():void
		{
			//if(_linkedIn["play-mode"] >= 1){
			//	LogoCreatorAutoPlay(_logoCreator).addName(_linkedIn["chosen-logo"]["name"]);
			//} else {
			
			LogoCreatorAutoPlay(_logoCreator).addName(_logoObj.name);
			//}
			
			_logoCreator.addEventListener("finished", onLogoFinishedHandler, false, 0, true);
			_sharepoint.visible = false;
			_logoCreator.visible = true;
		}

		private function onLogoFinishedHandler($e:Event):void
		{	
			//var obj:Object = {name:_logoCreator.returnName()}
			//dispatchEvent(new SceneEvent(SceneEvent.PROFANITY_CHECK, obj));
			//trace(this, "onLogoFinishedHandler" );
			
			_logoObj.name = _logoCreator.returnName();
			_dcProxy.logoData = _logoObj;
			_dcProxy.logo = _logoCreator.returnLogo();
			trace(this, "_logoObj.targetText", _logoObj.targetText);
			trace(this, "_logoObj.businessText", _logoObj.businessText);
			trace(this, "_logoObj.name", _logoObj.name);
			trace(this, "_dcProxy.logoData", _dcProxy.logoData);
			trace(this, "_dcProxy.logo", _dcProxy.logo);
			
			dispatchEvent(new SceneEvent(SceneEvent.SAVE_DATA_EVENT, _logoObj));
			dispatchFinished();
		}
		
	}
}