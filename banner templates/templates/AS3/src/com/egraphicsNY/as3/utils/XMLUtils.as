﻿package com.egraphicsNY.as3.utils{	/* was a singleton but i think its just better to got for the functions as static entities*/	import flash.events.EventDispatcher;	import flash.events.IEventDispatcher;	public final class XMLUtils extends EventDispatcher{		//		private static var _instance							:XMLUtils = new XMLUtils();				public function XMLUtils(target:IEventDispatcher=null){			//if( _instance ) throw new Error("XMLUtils and can only be accessed through XMLUtils.getInstance()"); 		}/* 		public static function getInstance():XMLUtils {			return _instance;		} */		public static function xmlTagsToLowerCase ($xml:XML):XML {  			// Convert the root tag to lowercase  			$xml.setName($xml.name().toString().toLowerCase());  			for each (var attribute:XML in $xml.@*) {    			attribute.setName(attribute.name().toString().toLowerCase());  			}  			// Convert all descendant tags to lowercase  			for each (var child:XML in $xml..*) {    			// If the node is an element...    			if (child.nodeKind() == "element") {      				// ...change its name to uppercase.      				child.setName(child.name().toString().toLowerCase());      				// If the node has any attributes, change their names to uppercase.      				for each (attribute in child.@*) {        				attribute.setName(attribute.name().toString().toLowerCase());      				}    			}  			}  			return $xml;		}		public static function reverseXMLList($xmlList:XMLList):XMLList{			var tA:Array 						= [];			var xl:XMLList 						= $xmlList;			for each(var cXML:XML in xl){				tA.unshift(cXML);			}			var l:int 							= tA.length;				xl								= null;				xl								= new XMLList();								for(var i:int=0;i<l;i++){				xl += XML(tA[i]);			}						return xl;		}	}}