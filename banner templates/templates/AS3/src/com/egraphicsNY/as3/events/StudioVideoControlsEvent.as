/**
* @author: Won C. Lee
* @Contact: woncheol.lee@tbwachiat.com
* @version: TBD
* @Tech: Actionscript3
*/

package com.egraphicsNY.as3.events
{
	import flash.events.Event;
	
	public class StudioVideoControlsEvent extends Event
	{
		public static  const PLAYER_INIT							:String = "playerInit";
		public static  const VIDEO_PLAY							:String = "videoPlay";
		public static  const VIDEO_PAUSE						:String = "videoPause";
		public static  const VIDEO_RESUME					:String = "videoResume";
		public static  const VIDEO_SEEK							:String = "videoSeek";
		public static  const VIDEO_CLOSE						:String = "videoClose";
		public static  const VIDEO_COMPLETE				:String = "videoComplete";
		
		public static  const VOLUME:String = "volume";
		//
		public static var value										:Number = 3;
		
		public function StudioVideoControlsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event{
			return new StudioVideoControlsEvent(type, bubbles, cancelable);
		}
		public override function toString():String{
			return formatToString('StudioVideoControlsEvent', 'type', 'bubbles', 'cancelable');
		}

	}
}