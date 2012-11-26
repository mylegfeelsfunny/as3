package com.office365.view.ui.experience
{
	import com.deepfocus.as3.templates.microsite.AbstractMain;
	import com.office365.view.ui.experience.event.SceneEvent;
	import com.office365.view.ui.experience.scenes.AbstractScene;
	import com.office365.view.ui.experience.scenes.FlashScene;
	import com.office365.view.ui.experience.scenes.Scene1;
	import com.office365.view.ui.experience.scenes.Scene2;
	import com.office365.view.ui.experience.scenes.Scene3;
	import com.office365.view.ui.experience.scenes.Scene4;
	import com.office365.view.ui.experience.scenes.Scene5;
	import com.office365.view.ui.experience.scenes.Scene6;
	import com.office365.view.ui.experience.scenes.Scene7;
	import com.office365.view.ui.experience.scenes.VideoScene;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName;
	
	public final class SceneManager extends EventDispatcher
	{
		private var _data:Object;
		private var _linkedIn:Object;
		private var _mc:Sprite;
		private var _sectionArray:Array;
		private var _currentSection:AbstractScene;
		private var _nextSection:AbstractScene;
		private var _index:int;
		private var _startOff:Boolean = true;
		public static const START:String = 'start';
		public static const RUN:String = 'run';
		public static const END:String = 'end';
		private var _currentState:String = START;
		
		// dynamic reference vars
		private var _fs:FlashScene = null;
		private var _vs:VideoScene = null;
		private var _s1:Scene1 = null;
		private var _s2:Scene2 = null;
		private var _s3:Scene3 = null;
		private var _s4:Scene4 = null;
		private var _s5:Scene5 = null;
		private var _s6:Scene6 = null;
		private var _s7:Scene7 = null;
		
		private var _volume:Number;
		
		public function SceneManager($data:Object, $mc:Sprite)
		{
			_data = $data;
			_mc = $mc;
			
			_init();
		}
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------
		public function get volume():Number { return _volume; }
		public function set volume(value:Number):void { _volume = value;  }

		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		private function _init():void
		{
			_sectionArray = [];
			_linkedIn = _data.linkedin;
			_index = 0;
			var l:int =  _data.scenes.count;
			var i:int = 0;
			for ( i = 0; i < l; i++ )
			{

				var node:Object = _data.scenes[i.toString()];
				var SpecificSectionClass:Class = getDefinitionByName("com.office365.view.ui.experience.scenes."+node.className) as Class;
				var section:AbstractScene = new SpecificSectionClass(_linkedIn, node);
				_sectionArray.push(section);
			}	
			
		}
		
		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
		public function resize(obj:Object):void
		{
			_currentSection.resize(obj);
		}
		
		public function kill():void
		{
			_data = null;
			_linkedIn = null;
			_sectionArray = [];
			_sectionArray = null;
			_currentSection = null;
			_nextSection = null;
			_index = undefined;
			_startOff = undefined;
		}
		
		public function start():void{
			trace(this, "start");
			_currentSection = createSection();
						
			_currentSection.removeEventListener(SceneEvent.BODY_LOADED, onSectionBodyLoaded, false);
			_currentSection.addEventListener(SceneEvent.BODY_LOADED, onFirstSectionBodyLoaded, false, 0, true);
			_mc.addChildAt(_currentSection, 0);
			

			dispatchEvent(new SceneEvent(SceneEvent.ADD_LOADER));
			
			var obj:Object = {origin:"experience", scene:"start"}
			dispatchEvent(new SceneEvent(SceneEvent.TRACKING, obj));
		}
		
		public function setVolume($val:Number):void
		{
			_volume = $val;
			_currentSection.setVolume(_volume);
		}
		
		public function profanityResponse($isProfane:Boolean):void
		{
			Scene5(_currentSection).profanityResponse($isProfane);
		}
		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		private function tryToPlayNext():void{
			trace(this, "_currentSection.over && _nextSection.loaded :: " + _currentSection.over +" & "+_nextSection.loaded);
			if (_currentSection.over && _nextSection.loaded ) {
				trace(this, "tryToPlayNext :: success");
				dispatchEvent(new SceneEvent(SceneEvent.REMOVE_LOADER));
				destroySection();
				_currentSection = _nextSection;
				
				if (_index >= _sectionArray.length) {
					_currentSection.removeEventListener(SceneEvent.BODY_OVER, onSectionBodyOver, false);
					_currentSection.addEventListener(SceneEvent.FADE_IN_OUTRO, onFadeOutroOver, false, 0, true);
					_currentSection.addEventListener(SceneEvent.BODY_OVER, onLastSectionBodyOver, false, 0, true);
					_currentSection.setVolume(_volume);
					trace(this, "_index >= _sectionArray.length :: says Play");
					_currentSection.playSection();
				} else {
					trace(this, "else :: says Play");
					_nextSection = createSection();
					_mc.addChildAt(_nextSection, 0);
					_currentSection.playSection();
				}
			}
		}

		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		private function createSection():AbstractScene{
			var section:AbstractScene = _sectionArray[_index];
			section.addEventListener(SceneEvent.BODY_LOADED, onSectionBodyLoaded, false, 0, true);
			section.addEventListener(SceneEvent.BODY_OVER, onSectionBodyOver, false, 0, true);
			section.addEventListener(SceneEvent.SOUND_CUE_EVENT, sendUpEvent, false, 0, true);
			section.addEventListener(SceneEvent.SAVE_DATA_EVENT, sendUpEvent, false, 0, true);
			section.addEventListener(SceneEvent.PROFANITY_CHECK, sendUpEvent, false, 0, true);
			section.addEventListener(SceneEvent.TRACKING, 		 sendUpEvent, false, 0, true);
			section.addEventListener(SceneEvent.PREP_OUTRO, 	 sendUpEvent, false, 0, true);
			_index++;
			//trace(this, "createSection", section, _index);
			return section;
		}
		
		private function destroySection():void{
			//trace(this, "destroySection", _currentSection );
			_mc.removeChild(_currentSection);
			_currentSection = null;
		}

		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		private function onSectionBodyLoaded($e:SceneEvent):void
		{
			_nextSection.removeEventListener(SceneEvent.BODY_LOADED, onSectionBodyLoaded, false);
			_nextSection.loaded = true;
			//_nextSection.setVolume(_volume);
			//_currentSection.setVolume(_volume);
			
			trace(this, "onSectionBodyLoaded", $e.currentTarget);
			dispatchEvent(new SceneEvent(SceneEvent.REMOVE_LOADER));
			_mc.stage.dispatchEvent(new Event(Event.RESIZE));
					
			tryToPlayNext();
		}
		
		private function onSectionBodyOver($e:SceneEvent):void{
			trace(this, "onSectionBodyOver", $e.currentTarget );
			_currentSection.removeEventListener(SceneEvent.BODY_OVER, onSectionBodyOver, false);
			_currentSection.removeEventListener(SceneEvent.SOUND_CUE_EVENT, sendUpEvent, false);
			_currentSection.removeEventListener(SceneEvent.SAVE_DATA_EVENT, sendUpEvent, false);
			_currentSection.removeEventListener(SceneEvent.PROFANITY_CHECK, sendUpEvent, false);
			_currentSection.removeEventListener(SceneEvent.TRACKING, 		sendUpEvent, false);
			_currentSection.removeEventListener(SceneEvent.PREP_OUTRO, 		sendUpEvent, false);
			_currentSection.over = true;
			
			dispatchEvent(new SceneEvent(SceneEvent.ADD_LOADER));
			tryToPlayNext();
		}
		
		private function onFirstSectionBodyLoaded($e:SceneEvent):void
		{
			trace(this, "onFirstSectionBodyLoaded", _currentSection);
			_currentSection.removeEventListener(SceneEvent.BODY_LOADED, onFirstSectionBodyLoaded);
			
			dispatchEvent(new SceneEvent(SceneEvent.REMOVE_LOADER));
			_mc.stage.dispatchEvent(new Event(Event.RESIZE));
			
			_nextSection = createSection();
			_mc.addChildAt(_nextSection, 0);
			_currentSection.setVolume(_volume);
			//trace(this, "onFirstSectionBodyLoaded :: says Play");
			_currentSection.playSection();
		}

		private function onLastSectionBodyOver($e:SceneEvent):void
		{
			trace(this, "onLastSectionBodyOver");
			_currentSection.removeEventListener(SceneEvent.BODY_OVER, onLastSectionBodyOver, false);
			_currentSection.removeEventListener(SceneEvent.SOUND_CUE_EVENT, sendUpEvent, false);
			_currentSection.removeEventListener(SceneEvent.SAVE_DATA_EVENT, sendUpEvent, false);
			_currentSection.removeEventListener(SceneEvent.PROFANITY_CHECK, sendUpEvent, false);
			_currentSection.removeEventListener(SceneEvent.TRACKING, 		sendUpEvent, false);
			_currentSection.removeEventListener(SceneEvent.PREP_OUTRO, 		sendUpEvent, false);
			destroySection();
			
			var obj:Object = {origin:"outro"}
			dispatchEvent(new SceneEvent(SceneEvent.TRACKING, obj));
			dispatchEvent(new SceneEvent(SceneEvent.EXPERIENCE_OVER));
		}
		
		private function onFadeOutroOver($e:SceneEvent):void
		{
			_currentSection.removeEventListener(SceneEvent.FADE_IN_OUTRO, onFadeOutroOver, false);
			dispatchEvent($e)
		}
/*		
		private function onSaveDataEventHandler($e:SceneEvent):void
		{
			dispatchEvent($e);
		}
		private function onSoundCueEventHandler($e:SceneEvent):void
		{
			dispatchEvent($e);
		}
*/		
		private function sendUpEvent($e:SceneEvent):void
		{
			dispatchEvent($e);
		}
		
/*		var obj:Object = {number:_index}
		dispatchEvent(new SceneEvent(SceneEvent.TRACKING, obj));
*/		


	}
}