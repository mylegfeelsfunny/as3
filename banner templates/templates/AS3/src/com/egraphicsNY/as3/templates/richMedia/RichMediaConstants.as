package com.egraphicsNY.as3.templates.richMedia{
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;

	public class RichMediaConstants extends EventDispatcher{
		
		protected static var _instance								:RichMediaConstants;
		
		public static var PATH										:String;
		
		public function RichMediaConstants($enforcer:SingletonEnforcer){}
		
		public static function getInstance():RichMediaConstants{
			if(RichMediaConstants._instance==null){
				RichMediaConstants._instance = new RichMediaConstants(new SingletonEnforcer());
			}
			return RichMediaConstants._instance;	
		}	
	}
}

class SingletonEnforcer{}