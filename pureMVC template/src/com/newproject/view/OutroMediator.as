package com.office365.view
{
	import com.deepfocus.as3.utils.LibraryAssetRetriever;
	import com.greensock.TweenNano;
	import com.greensock.easing.Strong;
	import com.office365.ApplicationFacade;
	import com.office365.AssetManager;
	import com.office365.view.ui.outro.OutroSection;
	import com.office365.view.ui.outro.event.OutroEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public final class OutroMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "OutroMediator";
		private var _outroSection:OutroSection;
		private var _mc:MovieClip;
		private var _volume:Number;
		
		public function OutroMediator(viewComponent:Object=null)
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
			_mc = MovieClip(LibraryAssetRetriever.getAsset("outroscene"));
		}
		
		//--------------------------------------------------------------------------
		// PUREMVC METHODS
		//--------------------------------------------------------------------------
		override public function listNotificationInterests():Array 
		{
			return [
				ApplicationFacade.RESIZE,
				ApplicationFacade.ADD_OUTRO,
				ApplicationFacade.PLAY_OUTRO,
				ApplicationFacade.REMOVE_OUTRO,
				ApplicationFacade.VOLUME
			];
		}
		
		override public function handleNotification( notification:INotification ):void {
			super.handleNotification(notification);
			var name:String = notification.getName();
			var body:Object = notification.getBody();
			
			switch (name)
			{
				case ApplicationFacade.ADD_OUTRO:
					_outroSection = new OutroSection(_mc, body);
					_outroSection.addEventListener(OutroEvent.ANIMATION_FINISHED, onOutroFinishedHandler, false, 0, true);
					//_outroSection.addEventListener(OutroEvent.SOUNDBUTTON, onMoveSoundButton, false, 0, true);
					_outroSection.volume = _volume;
					am.addChild(_outroSection);
					_outroSection.visible = false;
					var sm:SoundMediator = facade.retrieveMediator(SoundMediator.NAME) as SoundMediator;
					am.addChild(sm.muteButton);
					am.stage.dispatchEvent(new Event(Event.RESIZE));
					break;
				
				case ApplicationFacade.PLAY_OUTRO:
					_outroSection.visible = true;
					_outroSection.beginAnimation(body);
					break;
				
				case ApplicationFacade.REMOVE_OUTRO:
					_outroSection.removeEventListener(OutroEvent.LOADED, onOutroFinishedHandler);
					break;
				
				case ApplicationFacade.VOLUME:
					_volume = Number(body);
					if (_outroSection) _outroSection.setVolume(_volume);
					break;
				
				case ApplicationFacade.RESIZE:
					if (_outroSection) _outroSection.resize(body);
					break;
			}
		}
		
		//--------------------------------------------------------------------------
		// EVENT HANDLERS 
		//--------------------------------------------------------------------------
		private function onOutroFinishedHandler($e:OutroEvent):void
		{
			sendNotification(ApplicationFacade.SLIDE_END_IN);
			var sm:SoundMediator = facade.retrieveMediator(SoundMediator.NAME) as SoundMediator;
			sm.muteButton.alpha = 0;
			sm.muteButton.x = 5;
			TweenNano.to(sm.muteButton, .7, {alpha:1, delay:1, ease:Strong.easeOut, overwrite:0});
		}
		
		private function onMoveSoundButton($e:OutroEvent):void
		{
/*			var sm:SoundMediator = facade.retrieveMediator(SoundMediator.NAME) as SoundMediator;
			sm.muteButton.alpha = 0;
			sm.muteButton.x = 5;
			TweenNano.to(sm.muteButton, .7, {alpha:1, delay:1, ease:Strong.easeOut, overwrite:0});
*/		}
		
	}
}