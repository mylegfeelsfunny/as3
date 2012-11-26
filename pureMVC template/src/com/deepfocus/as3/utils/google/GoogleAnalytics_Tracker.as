﻿package com.deepfocus.as3.utils.google{	import com.google.analytics.AnalyticsTracker; 	import com.google.analytics.GATracker; 	import flash.display.DisplayObject;		public class GoogleAnalytics_Tracker	{				private static var _tracker:AnalyticsTracker;		public static var _instance:GoogleAnalytics_Tracker;				public function GoogleAnalytics_Tracker()		{		}				public static function getInstance( $mc:DisplayObject = null ):GoogleAnalytics_Tracker		{			if (_instance == null)			{				_instance = new GoogleAnalytics_Tracker();				_tracker = new GATracker( $mc, "UA-1619956-62", "AS3", false );			}						return _instance as GoogleAnalytics_Tracker;		}				public function trackPageview( $string:String = null ):void		{			trace("GoogleAnalytics_Tracker :: trackPageview :: " + $string);						_tracker.trackPageview($string);		}				/*		The GATracker.trackEvent method is responsible for sending tracking events. The method takes four parameters:				category: a string representing groups of events.		action: a string that is paired with each category and is typically used to track activities.		label: an optional string that provides additional scoping to the category/action pairing.		value: an optional non-negative integer that associates numerical data with a tracking event.			*/					public function trackEvent($category:String, $action:String, $label:String ):void		{			trace("GoogleAnalytics_Tracker :: trackEvent :: " + $category, $action, $label);			_tracker.trackEvent($category, $action, $label);		}				}}