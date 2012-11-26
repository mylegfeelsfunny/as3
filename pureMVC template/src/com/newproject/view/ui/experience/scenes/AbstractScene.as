package com.office365.view.ui.experience.scenes
{
	import com.office365.ApplicationFacade;
	import com.office365.view.ui.experience.event.SceneEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	public class AbstractScene extends MovieClip implements IScene
	{
		protected var _linkedIn:Object;
		protected var _stageInfo:Object;
		protected var _path:String;
		protected var _classInfo:*;
		protected var _body:MovieClip;
		protected var _loaded:Boolean;
		protected var _over:Boolean;
		protected var _xml:XML;
		protected var _volume:Number;
		
		public function AbstractScene($linkedIn:Object, $classInfo:Object)
		{
			_linkedIn = $linkedIn;
			//_path = $path;
			_classInfo = $classInfo;
			addEventListener(Event.ADDED_TO_STAGE, _init, false, 0, true);
		}
		
		//--------------------------------------------------------------------------
		//  ACCESSORS
		//--------------------------------------------------------------------------
		public function get body():MovieClip { return _body; }
		public function get loaded():Boolean { return _loaded; }
		public function set loaded(value:Boolean):void { _loaded = value;  }
		public function get over():Boolean { return _over; }
		public function set over(value:Boolean):void { _over = value;  }
		public function get volume():Number { return _volume; }
		public function set volume(value:Number):void { _volume = value;  }

		//--------------------------------------------------------------------------
		//  INIT
		//--------------------------------------------------------------------------
		protected function _init($e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroyBody, false, 0, true);
			_xml = XML(_classInfo.xml);
			_over = false;
			createBody();
		}
		
		//--------------------------------------------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------------------------------------------
		public function playSection():void {
			resize(ApplicationFacade.returnStageObject());
			//setVolume(1);
			_body.visible = true;
		}
		
		public function resize(obj:Object):void
		{
			_body.width = obj.width;
			_body.height = obj.height;
			_body.y = obj.offsetY;
			
			var offY:Number = (stage.stageHeight - obj.height) * .5;
			//trace("stage", stage.stageWidth, stage.stageHeight, offY);
			//trace("obj", obj.width, obj.height, obj.offsetY);
		}
		
		public function setVolume($ratio:Number):void
		{
			_volume = $ratio;
			var transform:SoundTransform = new SoundTransform();
			transform.volume = $ratio;
			_body.soundTransform = transform;
		}

		//--------------------------------------------------------------------------
		// PRIVATE METHODS
		//--------------------------------------------------------------------------
		public function prepareBody():void
		{
			// JSON MS STUFF
			setVolume(_volume);
			_body.visible = false;
			dispatchEvent(new SceneEvent(SceneEvent.BODY_LOADED));
		}
		
		public function dispatchFinished():void {
			_over = true;
			dispatchEvent(new SceneEvent(SceneEvent.BODY_OVER));
		}

		private function killAllChildren($mc:* = null):void
		{
			//trace(this, "killAllTimelines");
			if (!$mc) $mc = _body;
			if ($mc is MovieClip) $mc.gotoAndStop(1);
			if ($mc.numChildren > 0)
			{
				var l:int = $mc.numChildren-1;
				for ( var i:int = l; i > 0; i-- )
				{
					//trace(this, "i", i);
					if ($mc.getChildAt(i) is DisplayObjectContainer)
					{
						killAllChildren(DisplayObjectContainer($mc.getChildAt(i)));
					}
				}	
			} else {
				$mc.parent.removeChild($mc);
				$mc = null;
			}
		}

		//--------------------------------------------------------------------------
		//  CREATE / DESTROY
		//--------------------------------------------------------------------------
		public function createBody():void {}
		public function destroyBody($e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, destroyBody, false);
			killAllChildren()
			_linkedIn = null;
		}

		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		protected function bodyOverHandler($e:Event):void
		{
			dispatchFinished();
		}

		
	}
}