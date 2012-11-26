package com.office365.view
{
	import com.deepfocus.as3.templates.microsite.AbstractMain;
	import com.deepfocus.as3.utils.LibraryAssetRetriever;
	import com.office365.ApplicationFacade;
	import com.office365.AssetManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public final class SoundMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "SoundMediator";
		private var _voMC:MovieClip;
		private var _muteButton:MovieClip;
		private var _introSound:Sound;
		private var _phoneSound:Sound;
		private var _currentSoundTrack:Sound;
		private var _channel:SoundChannel;
		private var _muted:Boolean = false;
		private var _volume:Number;

		public function SoundMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------
		public function get am():AssetManager { return viewComponent as AssetManager; }
		public function get muteButton():MovieClip { return _muteButton as MovieClip; }
		
		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		override public function onRegister():void {
			//trace(this, "onRegister");
			
			_voMC = MovieClip(LibraryAssetRetriever.getAsset("voice_overs_mc"));
			_introSound = new Sound();
			_introSound.load(new URLRequest(AbstractMain.PATH+am.xml.audio.intro));
			_phoneSound = new Sound();
			_phoneSound.load(new URLRequest(AbstractMain.PATH+am.xml.audio.phone));
			
			_muteButton = MovieClip(LibraryAssetRetriever.getAsset("mute_button"));
			_muteButton.useHandCursor = true;
			_muteButton.buttonMode = true;
			_muteButton.addEventListener(MouseEvent.CLICK, onToggleMuteHandler, false, 0, true);
			_volume = 1;
			sendNotification(ApplicationFacade.VOLUME, 1);
		}
		
		//--------------------------------------------------------------------------
		// PUREMVC METHODS
		//--------------------------------------------------------------------------
		override public function listNotificationInterests():Array 
		{
			return [
				ApplicationFacade.VOICEOVER_CUE,
				ApplicationFacade.SOUNDTRACK_CUE,
				ApplicationFacade.SWITCH_SOUNDTRACK_CUE,
				ApplicationFacade.RESIZE
			];
		}
		
		override public function handleNotification( notification:INotification ):void {
			super.handleNotification(notification);
			var name:String = notification.getName();
			var body:Object = notification.getBody();
			
			switch (name)
			{
				case ApplicationFacade.VOICEOVER_CUE:
					var vo:MovieClip = getVO(int(body));
					vo.gotoAndPlay(2);
					break;
				
				case ApplicationFacade.SOUNDTRACK_CUE:
					_channel = _introSound.play();
					_channel.addEventListener(Event.SOUND_COMPLETE, onIntroSoundtrackCompleteHandler, false, 0, true);
					break;
				case ApplicationFacade.SWITCH_SOUNDTRACK_CUE:
					// fade out introsound later
					//trace(this, ApplicationFacade.SWITCH_SOUNDTRACK_CUE );
					try	{
						_channel.stop();
						_introSound.close();
					} catch($e:Error) {
						trace(this, "$e:Error", $e.message );
					}
					_channel.removeEventListener(Event.SOUND_COMPLETE, onIntroSoundtrackCompleteHandler, false);
					//_channel = _phoneSound.play(170000);
					_channel = _phoneSound.play();
					_channel.addEventListener(Event.SOUND_COMPLETE, onPhoneSoundtrackCompleteHandler);

					setVolume(_volume);
					
					
					break;
								
				case ApplicationFacade.RESIZE:
					_muteButton.x = (body.width - _muteButton.width) - 5;
					_muteButton.y = body.offsetY + 6;
					break;
				
			}
		}
		
		//--------------------------------------------------------------------------
		// PRIVATE METHODS 
		//--------------------------------------------------------------------------
		private function setVolume($val:int):void
		{
			try	{
				var transform:SoundTransform = new SoundTransform();
				transform.volume = $val;
				_channel.soundTransform = transform;
				_voMC.soundTransform = transform;
				_volume = $val;
			} catch($e:Error) {
				trace(this, "$e:Error", $e.message );
			}
		}

		private function getVO($val:int):MovieClip
		{
			return MovieClip(_voMC["vo_"+$val]);
		}
		
		private function getSoundtrack($val:int):MovieClip
		{
			return MovieClip(_voMC["soundtrack_"+$val]);
		}
		
		private function onIntroSoundtrackCompleteHandler($e:Event):void
		{
			_channel = _introSound.play(5756);
			setVolume(_volume);
		}
		
		private function onPhoneSoundtrackCompleteHandler($e:Event):void
		{
			trace(this, "onPhoneSoundtrackCompleteHandler" );
			_channel.removeEventListener(Event.SOUND_COMPLETE, onPhoneSoundtrackCompleteHandler);
			_channel = _phoneSound.play();
			_channel.addEventListener(Event.SOUND_COMPLETE, onPhoneSoundtrackCompleteHandler);
			setVolume(_volume);
		}

		private function onToggleMuteHandler($e:MouseEvent):void
		{
			if (_muted) {
				setVolume(1);
				_muteButton.gotoAndStop(1);
				sendNotification(ApplicationFacade.VOLUME, 1);
			} else {
				setVolume(0);
				_muteButton.gotoAndStop(2);
				sendNotification(ApplicationFacade.VOLUME, 0);
			}
			
			_muted = !_muted;
		}

	}
}