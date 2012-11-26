package com.office365.view.ui.experience.scenes
{
	import com.deepfocus.as3.display.video.videoplayer.ChromelessVideoPlayer;
	import com.deepfocus.as3.display.video.videoplayer.events.VideoControllerEvent;
	import com.deepfocus.as3.templates.microsite.AbstractMain;
	import com.deepfocus.as3.utils.LibraryAssetRetriever;
	import com.office365.ApplicationFacade;
	import com.office365.model.DataCacheProxy;
	import com.office365.view.ui.experience.event.SceneEvent;
	import com.office365.view.ui.pickers.contactpicker.ContactPicker;
	import com.office365.view.ui.pickers.contactpicker.ContactPickerAutoPlay;
	import com.office365.view.ui.pickers.event.PickerEvent;
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public final class Scene3 extends FlashScene
	{
		private var _pickerMC:MovieClip;
		private var _endtimeline:MovieClip;
		private var _contactPicker:ContactPicker;
		private var _videoPlayer:ChromelessVideoPlayer;
		private var _dcProxy:DataCacheProxy;

		public function Scene3($linkedIn:Object, $classInfo:Object)
		{
			super($linkedIn, $classInfo);
		}
		
		override public function prepareBody():void
		{
			trace(this, "prepareBody" );

			_pickerMC = LibraryAssetRetriever.getAsset("contactpicker");
			if(_linkedIn["playmode"] >= 1){
				var autoList:Array= [ 
					getIndexForId(_linkedIn['chosencontacts'][0]), 
					getIndexForId(_linkedIn['chosencontacts'][1]), 
					getIndexForId(_linkedIn['chosencontacts'][2])
				];
				_contactPicker = new ContactPickerAutoPlay(_pickerMC, _linkedIn.connections, autoList);
			} else {
				_contactPicker = new ContactPicker(_pickerMC, _linkedIn.connections);
			}
			_contactPicker.addEventListener(PickerEvent.SELECTION_FINISHED, onContactsSelectionAcceptedHandler, false, 0, true);

			_videoPlayer = new ChromelessVideoPlayer(AbstractMain.PATH+_xml.video, _body.stage.stageWidth, _body.stage.stageHeight)
			_videoPlayer.addEventListener(VideoControllerEvent.CONNECTION_MADE, videoReadyHandler, false, 0);
			_videoPlayer.addEventListener(VideoControllerEvent.VIDEO_OVER, videoOverHandler, false, 0);
			
			_endtimeline = LibraryAssetRetriever.getAsset("end_timeline");
			_endtimeline.gotoAndStop(1);
			_endtimeline.header.animation.signature.txt.text = "- "+_linkedIn["firstname"].toString();
			
			_pickerMC.visible = false;
			_body.addChild(_pickerMC);
			_body.addChild(_videoPlayer);
			
			var facade:ApplicationFacade = ApplicationFacade.getInstance();
			_dcProxy = facade.retrieveProxy(DataCacheProxy.NAME) as DataCacheProxy;
			stage.dispatchEvent(new Event(Event.RESIZE));
			//super.prepareBody();
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
			trace(this, "playSection" );
			_videoPlayer.resume();
			
			var obj:Object = {}
			dispatchEvent(new SceneEvent(SceneEvent.SOUND_CUE_EVENT, obj));
			
			obj = {origin:"experience", scene:"3"}
			dispatchEvent(new SceneEvent(SceneEvent.TRACKING, obj));

			super.playSection();
			//_body.visible = false;
		}
		
		override public function resize(obj:Object):void
		{
			try {
			if (_contactPicker)_contactPicker.resize(obj);
			_videoPlayer.resize(obj.width, obj.height);
			_endtimeline.width = obj.width;
			_endtimeline.height = obj.height;
			_body.y = obj.offsetY;
			}catch($e:Error) {trace(this, "$e;Error", $e.message);}
		}
		
		override public function destroyBody($e:Event):void {
			_body.removeChild(_videoPlayer);
			_videoPlayer = null;
			//_body.removeChild(_endtimeline);
			//_endtimeline = null;
			super.destroyBody($e);
		}
		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		private function getIndexForId($id:String):int
		{
			var retunInt:int;
			var l:int =  _linkedIn['connections'].length;
			var i:int = 0;
			for ( i = 0; i < l; i++ )
			{
				var o:Object = _linkedIn['connections'][i];
				if (o['linkid'] == $id) {
					retunInt = i;
					break;
				}
			}	
			return retunInt;
		}
		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		private function videoReadyHandler($e:VideoControllerEvent):void
		{
			//_videoPlayer.volume(0);
			//_videoPlayer.resume();
			super.prepareBody();
		}
		
		private function videoOverHandler($e:VideoControllerEvent):void
		{
			_pickerMC.visible = true;
			_body.addChild(_pickerMC);
			//if(_linkedIn["play-mode"] >= 1){
				//_contactPicker.AUTOPLAY = true;
				//_contactPicker.startIndex = _linkedIn['chosen-contacts'][0];
			//	_contactPicker.setAutoPlayProperties(_linkedIn['chosen-contacts'] )
				//_pickerMC.mouseEnabled = _pickerMC.mouseChildren = false;
			//} 
			trace(this, "prepOutro");
			dispatchEvent(new SceneEvent(SceneEvent.PREP_OUTRO));
			_contactPicker.animateIn();
		}
		
		private function onContactsSelectionAcceptedHandler($e:PickerEvent):void
		{
			_body.removeChild(_pickerMC);
			_contactPicker = null;
			_dcProxy.teammateIndices = $e.data["chosencontacts"];
			var list:String = "";
			var l:int =  _dcProxy.teammates.length;
			var i:int = 0;
			for ( i = 0; i < l; i++ )
			{
				list += _dcProxy.teammates[i]["firstname"].toString();
				if (i <= l-2) list += ", ";
			}	
			_endtimeline.header.recipients.txt.text = list;
			
			bodyOverHandler(null);
			/*
			_endtimeline.addEventListener("flash_timeline_over", bodyOverHandler, false, 0, true);
			_body.addChild(_endtimeline);
			_endtimeline.header.animation.gotoAndPlay(2);
			*/
		}
		


	}
}