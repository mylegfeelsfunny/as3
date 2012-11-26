//AUTHOR: REMI

package com.deepfocus.as3.display.images{
	
/*------------------------------IMPORTS------------------------------*/
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	
	/** Framework that allows child classes (visual representations of preloaders) to
	 * work within a set structure.*/
	public class AbstractPreloader extends Sprite{

/*------------------------------VARS------------------------------*/
			
		//EVENTS
		public static var HIDE_COMPLETE:String = "hideComplete";
		
		
/*--------------------------CONSTRUCTOR------------------------------*/
		public function AbstractPreloader(){
		}
		

/*------------------------------FUNC------------------------------*/
		/** Appearance on initial load (i.e., before load count begins).*/
		public function initFormat():void{
			
		}
		
		
		/** Appearance on load increment.*/
		public function updateFormat(num:Number):void{
			throw new Error("Must be overridden");
		}
		
		
		/** Appearance on completion of load.*/
		public function completeFormat():void{
			throw new Error("Must be overridden");
		}
		
		
		protected function hidePreloaderUI():void{
			dispatchEvent(new Event(HIDE_COMPLETE));
		}
	}
}