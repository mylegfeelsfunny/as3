package com.office365.view
{
	import com.deepfocus.as3.display.section.Section;
	import com.deepfocus.as3.utils.LibraryAssetRetriever;
	import com.office365.ApplicationFacade;
	import com.office365.AssetManager;
	import com.office365.view.ui.experience.event.SceneEvent;
	import com.office365.view.ui.intro.IntroSection;
	import com.office365.view.ui.intro.event.IntroEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public final class IntroMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "IntroMediator";
		private var _introSection:IntroSection;
		private var _mc:MovieClip;
		private var _volume:Number;
		
		public function IntroMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------
		
		public function get am():AssetManager { return viewComponent as AssetManager; }
		
		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		override public function onRegister():void {
			trace(this, "onRegister");
			_mc = MovieClip(LibraryAssetRetriever.getAsset("introscene"));
		}
		
		//--------------------------------------------------------------------------
		// PUREMVC METHODS
		//--------------------------------------------------------------------------
		override public function listNotificationInterests():Array 
		{
			return [
				ApplicationFacade.RESIZE,
				ApplicationFacade.ADD_INTRO,
				ApplicationFacade.REMOVE_INTRO,
				ApplicationFacade.VOLUME
			];
		}
		
		override public function handleNotification( notification:INotification ):void {
			super.handleNotification(notification);
			var name:String = notification.getName();
			var body:Object = notification.getBody();
			
			switch (name)
			{
				case ApplicationFacade.ADD_INTRO:
				/*
					sendNotification(ApplicationFacade.CALL_LINKEDIN);
					break;
				*/
					_introSection = new IntroSection(_mc, body, int(am.paramObj['startmode']));
					_introSection.addEventListener(IntroEvent.INTRO_OVER, onIntroCompleteHandler, false, 0, true);
					_introSection.addEventListener(IntroEvent.LINK_OUT, onIntroLinkOutHandler, false, 0, true);
					_introSection.addEventListener(IntroEvent.LOADED, onIntroVideoReadyHandler, false, 0, true);
					_introSection.addEventListener(IntroEvent.SOUND_CUE, onSoundtrackStart, false, 0, true);
					_introSection.addEventListener(IntroEvent.TRACKING, trackingEventHandler, false, 0, true);
					_introSection.volume = _volume;
					
					am.addChild(_introSection);
					sendNotification(ApplicationFacade.ADD_LOADER);
					sendNotification(ApplicationFacade.VOLUME, 1);
					
					am.stage.dispatchEvent(new Event(Event.RESIZE));
					break;
				
				case ApplicationFacade.REMOVE_INTRO:
					_introSection.removeEventListener(IntroEvent.INTRO_OVER, onIntroCompleteHandler, false);
					_introSection.removeEventListener(IntroEvent.LINK_OUT, onIntroLinkOutHandler, false);
					_introSection.removeEventListener(IntroEvent.LINK_OUT, onIntroVideoReadyHandler, false);
					_introSection.removeEventListener(IntroEvent.SOUND_CUE, onSoundtrackStart, false);
					_introSection.removeEventListener(IntroEvent.TRACKING, trackingEventHandler, false);
					am.removeChild(_introSection);
					_introSection = null;
					break;
				
				case ApplicationFacade.VOLUME:
					_volume = Number(body);
					if (_introSection) _introSection.setVolume(_volume);
					break;
				
				case ApplicationFacade.RESIZE:
					if (_introSection) _introSection.resize(body);
					break;

			}
			
		}
		
		//--------------------------------------------------------------------------
		// EVENT HANDLERS 
		//--------------------------------------------------------------------------
		private function onIntroCompleteHandler($e:IntroEvent):void
		{
			sendNotification(ApplicationFacade.CALL_LINKEDIN);
		}
		
		private function onIntroLinkOutHandler($e:IntroEvent):void
		{
			
		}
		
		private function onIntroVideoReadyHandler($e:IntroEvent):void
		{
			//trace(this, "onIntroVideoReadyHandler::REMOVE_LOADER" );

			sendNotification(ApplicationFacade.REMOVE_LOADER);
		}

		private function onSoundtrackStart($e:IntroEvent):void
		{
			sendNotification(ApplicationFacade.SOUNDTRACK_CUE, "intro");
		}
		
		private function trackingEventHandler($e:SceneEvent):void
		{
			//trace(this, "trackingEventHandler" );
			sendNotification(ApplicationFacade.TRACK, $e.data)
		}
	}
}