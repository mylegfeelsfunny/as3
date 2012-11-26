package com.office365.view
{
	import com.office365.ApplicationFacade;
	import com.office365.AssetManager;
	import com.office365.view.ui.experience.SceneManager;
	import com.office365.view.ui.experience.event.SceneEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public final class ExperienceMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ExperienceMediator";
		
		/** Default width of the application -- useful when scaling scenes with masks overflows that
		 * distort reported dimensions. */
		public static var DEFAULT_WIDTH:int;
		/** Default height of the application -- useful when scaling scenes with masks overflows that
		 * distort reported dimensions. */
		public static var DEFAULT_HEIGHT:int;
		/** The scale of the stage as a product of its default width. */
		public static var STAGE_SCALEX:Number;
		/** The scale of the stage as a product of its default height. */
		public static var STAGE_SCALEY:Number;
		
		private var _experience:SceneManager;
		private var _volume:Number;
		
		public function ExperienceMediator(viewComponent:Object=null)
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
			//trace(this, "onRegister");
			
			
		}
		
		//--------------------------------------------------------------------------
		// PUREMVC METHODS
		//--------------------------------------------------------------------------
		override public function listNotificationInterests():Array 
		{
			return [
				ApplicationFacade.RESIZE,
				ApplicationFacade.ADD_EXPERIENCE,
				ApplicationFacade.REMOVE_EXPERIENCE,
				ApplicationFacade.VOLUME,
				ApplicationFacade.PROFANITY_RESPONSE
			];
		}
		
		override public function handleNotification( notification:INotification ):void {
			super.handleNotification(notification);
			var name:String = notification.getName();
			var body:Object = notification.getBody();
			
			switch (name)
			{
				case ApplicationFacade.ADD_EXPERIENCE:
					_experience = new SceneManager(body, am);
					_experience.addEventListener(SceneEvent.SAVE_DATA_EVENT, onSaveDataEventHandler, false, 0, true);
					_experience.addEventListener(SceneEvent.SOUND_CUE_EVENT, onSoundCueEventHanler, false, 0, true);
					_experience.addEventListener(SceneEvent.EXPERIENCE_OVER, onExperienceOverHandeler, false, 0, true);
					_experience.addEventListener(SceneEvent.FADE_IN_OUTRO, onFadeOutroOver, false, 0, true);
					_experience.addEventListener(SceneEvent.ADD_LOADER, onBodyStartLoadHandler, false, 0, true);
					_experience.addEventListener(SceneEvent.REMOVE_LOADER, onBodyLoadedHandler, false, 0, true);
					_experience.addEventListener(SceneEvent.PROFANITY_CHECK, onBodyProfanityHandler, false, 0, true);
					_experience.addEventListener(SceneEvent.TRACKING, trackingEventHandler, false, 0, true);
					_experience.addEventListener(SceneEvent.PREP_OUTRO, onPrepOutroHandler, false, 0, true);
				
					_experience.volume = _volume;
					_experience.start();
					//trace(this, "_experience.volume", _experience.volume);
					break;
				case ApplicationFacade.REMOVE_EXPERIENCE:
					break;
				case ApplicationFacade.RESIZE:
					if (_experience) _experience.resize(body);
					/*something curious happening here -- height changes are ignored,
					while width changes affect both body.width and body.height. Revisit*/
					STAGE_SCALEX = body.width / DEFAULT_WIDTH;
					STAGE_SCALEY = body.height / DEFAULT_HEIGHT;
					break;
				
				case ApplicationFacade.VOLUME:
					//trace(this, "ApplicationFacade.VOLUME: body", body);
					_volume = Number(body);
					if (_experience != null) _experience.setVolume(_volume);
					break;
				case ApplicationFacade.PROFANITY_RESPONSE:
					_experience.profanityResponse(body);
					break;
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//  
		//--------------------------------------------------------------------------
		private function onBodyStartLoadHandler($e:SceneEvent):void {
			sendNotification(ApplicationFacade.ADD_LOADER);	
		}
		
		private function onBodyLoadedHandler($e:SceneEvent):void {
			sendNotification(ApplicationFacade.REMOVE_LOADER);	
		}
		
		private function onSaveDataEventHandler($e:SceneEvent):void {
			
		}
		
		private function onSoundCueEventHanler($e:SceneEvent):void {
			if ($e.data.type == 'vo') {
				sendNotification(ApplicationFacade.VOICEOVER_CUE, $e.data.index);
			} else {
				sendNotification(ApplicationFacade.SWITCH_SOUNDTRACK_CUE);
			}
		}
		
		private function onExperienceOverHandeler($e:SceneEvent):void {
			
			_experience.removeEventListener(SceneEvent.SAVE_DATA_EVENT, onSaveDataEventHandler, false);
			_experience.removeEventListener(SceneEvent.SOUND_CUE_EVENT, onSoundCueEventHanler, false);
			_experience.removeEventListener(SceneEvent.EXPERIENCE_OVER, onExperienceOverHandeler, false);
			_experience.removeEventListener(SceneEvent.FADE_IN_OUTRO, onFadeOutroOver, false);
			_experience.removeEventListener(SceneEvent.ADD_LOADER, onBodyStartLoadHandler, false);
			_experience.removeEventListener(SceneEvent.REMOVE_LOADER, onBodyLoadedHandler, false);
			_experience.removeEventListener(SceneEvent.TRACKING, trackingEventHandler, false);
			_experience.removeEventListener(SceneEvent.PREP_OUTRO, onPrepOutroHandler, false);
			_experience.kill();
			_experience = null;
			
		}
		
		private function onPrepOutroHandler($e:SceneEvent):void
		{
			trace(this, "prepOutro");
			sendNotification(ApplicationFacade.PREP_OUTRO);
		}

		private function onFadeOutroOver($e:SceneEvent):void {

			sendNotification(ApplicationFacade.SAVE_DATA);
		}
		
		private function onBodyProfanityHandler($e:SceneEvent):void
		{
			sendNotification(ApplicationFacade.CHECK_FOR_PROFANITY, $e.data.name);
		}
		
		private function trackingEventHandler($e:SceneEvent):void
		{
			sendNotification(ApplicationFacade.TRACK, $e.data)
		}


		
	}
}