package com.egraphicsNY.as3.demos.utils
{
	import com.egraphicsNY.as3.events.TimeUtilEvent;
	import com.egraphicsNY.as3.utils.TimeUtil;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TimeUtilDemo extends Sprite
	{
		private var _clock									:TextField;
		private var _singleUnitCoundown						:TextField;
		private var _countDown								:TextField;	
		private var _time									:TimeUtil;
					
		public function TimeUtilDemo()
		{
			_time = TimeUtil.getInstance();
   			
   			//--------------------------------------------------------------------------
        	//  For any of the functions there is a optional parameter fro your own date that 
        	//  will feed back the same ragged result. The default is the date now.
        	//--------------------------------------------------------------------------

 			var dummyDate:String 							= '04/01/2011 16:00:00 GMT-0500';
 			var defaultDate:Date 							= new Date(Date.parse(dummyDate));
			trace("var dummyDate:String = '04/01/2011 16:00:00 GMT-0500'\n");
			trace("TimeUtil.getYear()				:: " + _time.getYear());
			trace("TimeUtil.getMonth()				:: " + _time.getMonth());
			trace("TimeUtil.getDay()					:: " + _time.getDay());
			trace("TimeUtil.getHour()				:: " + _time.getHour());
			trace("TimeUtil.getMinutes()			:: " + _time.getMinutes());
			trace("TimeUtil.getSeconds()			:: " + _time.getSeconds());
			trace("TimeUtil.getDate()				:: " + _time.getDate());
			trace("TimeUtil.getTime()				:: " + _time.getTime());
			trace("TimeUtil.getTimeWithSecs()	:: " + _time.getTimeWithSecs());
			trace("TimeUtil.giveBackTime()		:: " + _time.giveBackTime());
			trace("TimeUtil.daysInMonth()		:: " + _time.daysInMonth("March", "2010"));
			trace("TimeUtil.daysInYear()			:: " + _time.daysInYear("2010"));
			trace("TimeUtil.getDayOfWeek()	:: " + _time.getDayOfWeek());
			trace("\nTimeUtil.getTimeLeft('04/01/2010 16:00:00 GMT-0500', 'minutes')	:: " + _time.getTimeLeft('04/01/2010 16:00:00 GMT-0500', 'minutes') );
   	 		
   	 		//--------------------------------------------------------------------------
       		//  This bit is textfields for a clock and two types of countdowns: 
        	//--------------------------------------------------------------------------
	
			var format:TextFormat 							= new TextFormat();
			format.font 									= "Verdana";
			format.size 									= 14;
			
			var clock										:TextField = new TextField();
			clock.text										= "clock:  with $secs set to true";
			clock.autoSize									= TextFieldAutoSize.LEFT;
			addChild(clock);
			_clock											= new TextField();
			_clock.defaultTextFormat						= format;
			_clock.autoSize									= TextFieldAutoSize.LEFT;
			_clock.selectable								= true;
			_clock.y										= 15;
			addChild(_clock);

			var singleUnitCoundown							:TextField = new TextField();
			singleUnitCoundown.text							= "singleUnitCountdown:     until " + _time.getDate(defaultDate) + " " + _time.getYear(defaultDate);
			singleUnitCoundown.autoSize						= TextFieldAutoSize.LEFT;
			singleUnitCoundown.y							= 70;
			addChild(singleUnitCoundown);
			
			_singleUnitCoundown								= new TextField();
			_singleUnitCoundown.defaultTextFormat			= format;
			_singleUnitCoundown.autoSize					= TextFieldAutoSize.LEFT;
			_singleUnitCoundown.selectable					= true;
			_singleUnitCoundown.y	  						= 85;
			addChild(_singleUnitCoundown);

			var counterClock								:TextField = new TextField();
			counterClock.text								= "counterClock:     until " + _time.getDate(defaultDate) + " " + _time.getYear(defaultDate);
			counterClock.autoSize							= TextFieldAutoSize.LEFT;
			counterClock.y									= 150;
			addChild(counterClock);
			
			_countDown										= new TextField();
			_countDown.defaultTextFormat					= format;
			_countDown.autoSize								= TextFieldAutoSize.LEFT;
			_countDown.selectable							= true;
			_countDown.y  									= 165;
			addChild(_countDown);
			
   	 		//--------------------------------------------------------------------------
       		//
       		//	countDownSingleUnit: counts down with whatever time unit is left till the requested date ("years", "minutes", "seconds", etc);
       		//	counterClock: counts down as a clock timer, theres a commented out example for time 'since", alternate the two off and on and you'll get the idea;
       		//	
        	//--------------------------------------------------------------------------
	
 			//--------------------------------------------------------------------------
	        //  clock
	        //--------------------------------------------------------------------------
				_time.addEventListener(TimeUtilEvent.CLOCK_UPDATE, onUpdateClockHandler);
	 			_time.clock(true); 		

 			//--------------------------------------------------------------------------
	        //  countDownSingleUnit
	        //--------------------------------------------------------------------------
				_time.addEventListener(TimeUtilEvent.COUNTDOWN_SINGLEUNIT_UPDATE, onUpdateCountDownSingleHandler);
				_time.addEventListener(TimeUtilEvent.COUNTDOWN_SINGLEUNIT_COMPLETE, onUpdateCountDownSingleCompleteHandler);
 				_time.countDownSingleUnit(dummyDate, "days");
 			
 			//--------------------------------------------------------------------------
	        //  counterClock
	        //--------------------------------------------------------------------------
				_time.addEventListener(TimeUtilEvent.COUNTDOWN_UPDATE, onUpdateCountDownHandler);
				_time.addEventListener(TimeUtilEvent.COUNTDOWN_COMPLETE, onUpdateCountDownCompleteHandler);
	 			_time.counterClock(dummyDate, "till", "milliseconds");
 				//_time.counterClock('03/22/2010 16:00:00 GMT-0500', "since", "milliseconds", '04/01/2010 16:00:00 GMT-0500');
 		}
		
		private function onUpdateClockHandler(e:TimeUtilEvent):void
		{
			_clock.text 									= _time.getTimeWithSecs();
		}
		
		private function onUpdateCountDownSingleHandler(e:TimeUtilEvent):void
		{
			_singleUnitCoundown.text 						= e.countDownValue;
		}
	
		private function onUpdateCountDownSingleCompleteHandler(e:TimeUtilEvent):void
		{
			_singleUnitCoundown.text 						= e.countDownValue;
		}
	
		private function onUpdateCountDownHandler(e:TimeUtilEvent):void
		{
			// TimeUtilEvent "countDownValueObject" is the returned object with info available from years to milliseconds
			var data:Object = e.countDownValueObject;
			_countDown.text = data.years + "." + data.months + "." + data.days + "." + data.hours + "." + data.minutes + "." + data.seconds + "." + data.milliseconds;
		}
	
		private function onUpdateCountDownCompleteHandler(e:TimeUtilEvent):void
		{
			_countDown.text 								= e.countDownValue;
		}
		
	}
}