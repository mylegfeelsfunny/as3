﻿package com.newproject {		import com.deepfocus.as3.templates.microsite.AbstractAssetManager;	import com.deepfocus.as3.templates.microsite.AbstractMain;		import flash.display.MovieClip;	import flash.display.Sprite;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;		public final class AssetManager extends AbstractAssetManager{				public function AssetManager($mc:MovieClip,$contentXML:XML, $paramObj:Object=null){			super($mc, $contentXML, $paramObj);		}				public override function startSite():void{			//trace(this, "startSite() as AbstractAssetManagerSubclass");			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode  = StageScaleMode.NO_SCALE;						//trace(this, this.paramObj );			if (paramObj == null) {				this.paramObj = {};				//this.paramObj["startmode"] = 0;			}			ApplicationFacade.getInstance().startup(this);		}				//--------------------------------------------------------------------------		//  ACCESSORS		//--------------------------------------------------------------------------				//--------------------------------------------------------------------------		//  INIT		//--------------------------------------------------------------------------				//--------------------------------------------------------------------------		//  PUBLIC METHODS		//--------------------------------------------------------------------------		//--------------------------------------------------------------------------		// PRIVATE METHODS		//--------------------------------------------------------------------------				//--------------------------------------------------------------------------		//  CREATE / DESTROY		//--------------------------------------------------------------------------				//--------------------------------------------------------------------------		//  EVENT HANDLERS		//--------------------------------------------------------------------------			}}