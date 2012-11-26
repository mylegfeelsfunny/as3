package com.office365.view.ui.experience.scenes{
	import com.adobe.utils.StringUtil;
	import com.deepfocus.as3.apps.mapviewer.MapLoader;
	import com.deepfocus.as3.utils.LibraryAssetRetriever;
	import com.greensock.TweenLite;
	import com.office365.model.DataCacheProxy;
	import com.office365.view.ExperienceMediator;
	import com.office365.view.ui.PhotoWall;
	import com.office365.view.ui.experience.event.SceneEvent;
	import com.office365.view.ui.pickers.contactpicker.ContactPicker;
	import com.office365.view.ui.pickers.event.PickerEvent;
	import com.deepfocus.as3.utils.StringUtils;
	import com.deepfocus.as3.utils.TextUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	public final class Scene2 extends FlashScene{
		
		
		private var _monitorUI:MovieClip;
		private var _map:MapLoader;
		private var _imgWall:PhotoWall;
		private var _mapDupe:Bitmap;
		
		/** The default width and height of the map object. Relevant for scaling. */
		private var _defMapDimensions:Point;
		
		public function Scene2($linkedIn:Object, $classInfo:Object){
			super($linkedIn, $classInfo);
			_defMapDimensions = new Point(426, 300);
		}
		
		override public function prepareBody():void{
			_map = new MapLoader(LibraryAssetRetriever.getAsset("mapContainer"));
			_monitorUI = LibraryAssetRetriever.getAsset("monitorUI");
			var nameLarge:MovieClip = _monitorUI.browserWin.siteContent.mainHeadline;
			var caption1:TextField = _monitorUI.browserWin.siteContent.page1Caption;
			var visionaryTf:TextField = _monitorUI.browserWin.siteContent.visionaryName;
			var graphKeyTf:TextField = _monitorUI.browserWin.sitePage2.graphLegend;
			var graphCaption:TextField = _monitorUI.browserWin.sitePage2.graphCaption;
			var purpleBar:MovieClip = _monitorUI.browserWin.siteContent.purpleBar;
			var buffer:int = 7;
			
			var fName:String = StringUtils.toTitleCase(_linkedIn['firstname']);
			var lName:String = StringUtils.toTitleCase(_linkedIn['lastname']);
			var fullName:String = fName +' '+ lName;
			var imgUrl:String = _linkedIn['pictureurl'];
			var blurb1:String = 'See how '+fullName+' changed the world with his start up on this week’s episode of The Future of Business Tommorrow';
			var blurb2:String = 'a scan shows '+fullName +"'s ";
			_imgWall = new PhotoWall(457, 260, DataCacheProxy.IMAGEPROXY+ _linkedIn['pictureurl']);
			
			//rework possessive for words with a terminal 'S'
			if(fullName.charAt(fullName.length - 1).toLowerCase() == 's'){
				blurb2 = 'a scan shows '+fullName +"' ";
			}
			blurb2 = String(blurb2 + 'mind is brilliant and truly ahead of the times').toUpperCase();
			
			_monitorUI.browserWin.stop();
			trace(this, "prepareBody", _linkedIn );
			
			//TextUtils.enterTextAndSizeToFit(nameLarge, fName.toLowerCase()+'\n '+lName.toLowerCase(), {width:nameLarge.width, height:nameLarge.height}/*, [1]*/);
			//TextUtils.enterTextAndSizeToFit(nameLarge, fName.toLowerCase()+'\n'+lName.toLowerCase(), {width:nameLarge.width, height:nameLarge.height});
			TextUtils.enterTextAndSizeToFit(caption1, blurb1, {width:caption1.width, height:caption1.height});
			TextUtils.enterTextAndSizeToFit(visionaryTf, fullName.toUpperCase(), {width:purpleBar.width* 1.25, height:purpleBar.height});
			TextUtils.enterTextAndSizeToFit(graphKeyTf, fullName, {width:110, height:13});
			TextUtils.enterTextAndSizeToFit(graphCaption, blurb2, {width:graphCaption.width, height:graphCaption.height});
			
			
			TextField(nameLarge.fname).autoSize = TextFieldAutoSize.LEFT;
			TextField(nameLarge.lname).autoSize = TextFieldAutoSize.LEFT;
			TextField(nameLarge.fname).wordWrap = false;
			TextField(nameLarge.lname).wordWrap = false;
			TextField(nameLarge.fname).multiline = false;
			TextField(nameLarge.lname).multiline = false;
			nameLarge.fname.text = fName.toLowerCase() + " ";
			nameLarge.lname.text = lName.toLowerCase() + " ";
			nameLarge.x = 0;
			nameLarge.x = _monitorUI.browserWin.siteContent.width - nameLarge.width;
			
			//positioning
			visionaryTf.multiline = visionaryTf.wordWrap = false;
			nameLarge.y = _monitorUI.browserWin.siteContent.pictureWall.y;
			nameLarge.y += (caption1.y - _monitorUI.browserWin.siteContent.pictureWall.y - nameLarge.height)/2; 
			visionaryTf.y = purpleBar.y + (purpleBar.height - visionaryTf.height)* .5;
			trace('visionaryTf.tWidth '+visionaryTf.textWidth, 'visionaryTf.width '+visionaryTf.width, 'PURPLE WID '+purpleBar.width);
			trace('TLM '+TextUtils.getLineWidth(visionaryTf, 0));
			purpleBar.width = Math.max(purpleBar.width, visionaryTf.width + buffer);
			trace('PURPLE WID '+purpleBar.width);
			
			trace('POST visionaryTf.x '+visionaryTf.x);
			
			_body.addChild(_monitorUI);
			_monitorUI.browserWin.siteContent.pictureWall.addChild(_imgWall);
			
			_monitorUI.addEventListener(Event.COMPLETE, onSiteComplete, true, 0, true);
			prepMap();
			
			super.prepareBody();
		}
		
		private function prepMap():void{
			_map.mapWidth = stage.stageWidth * 2;
			_map.mapHeight = stage.stageHeight * 2;
			_map.scale = .5;
			_map.container.x = stage.stageWidth * .5;
			_map.container.y = stage.stageHeight * .5;
			_map.setCoords(_linkedIn['location'].latitude, _linkedIn['location'].longitude);
			_map.addMarker(_linkedIn['location'].latitude, _linkedIn['location'].longitude);
		}
		
		private function updateMapView():void{
			/*_mapDupe.x = (stage.stageWidth - _mapDupe.width)* .5;
			_mapDupe.y = (stage.stageHeight - _mapDupe.height)* .5;*/
			_map.container.x = stage.stageWidth * .5;
			_map.container.y = stage.stageHeight * .5;
		}
		
		override public function playSection():void { 
			super.playSection();
			trace('PLAY SECTION '+this);
			_monitorUI.browserWin.gotoAndPlay(1);
			
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, dispatchSound);
			timer.start();	
			
			var obj:Object = {origin:"experience", scene:"2"}
			dispatchEvent(new SceneEvent(SceneEvent.TRACKING, obj));

		}
		
		private function dispatchSound($e:TimerEvent):void
		{
			Timer($e.currentTarget).stop();
			Timer($e.currentTarget).addEventListener(TimerEvent.TIMER, dispatchSound);
			var obj:Object = {index:1, type:'vo'};
			dispatchEvent(new SceneEvent(SceneEvent.SOUND_CUE_EVENT, obj))
		}

		override public function resize(obj:Object):void{
			_body.y = obj.offsetY;
			/*if(_mapDupe)		updateMapView();
			else{*/
				_map.container.x = stage.stageWidth * .5;
				_map.container.y = stage.stageHeight * .5;
				_map.mapWidth = stage.stageWidth * 2;
				_map.mapHeight = stage.stageHeight * 2;
			//}
			if(_body.contains(_monitorUI))	_monitorUI.scaleX = _monitorUI.scaleY = obj.scale;
		}
		
		override public function destroyBody($e:Event):void{
			/*_mapDupe.bitmapData.dispose();
			_mapDupe.bitmapData = null;*/
			_map.destroy();
			_imgWall.destroy();
			
			_monitorUI.removeEventListener(Event.COMPLETE, onSiteComplete, true);
			super.destroyBody($e);
		}
		
		private function zoomMap():void{
			/*var bt:BitmapData = new BitmapData(_map.mapWidth, _map.mapHeight, false);
			
			_mapDupe = new Bitmap(bt, 'auto', true);
			bt.draw(_map.container, new Matrix(1, 0, 0, 1, _map.mapWidth/2, _map.mapHeight/2));
			
			_body.addChild(_mapDupe);
			if(_body.contains(_map.container))	_body.removeChild(_map.container);
			if(_body.contains(_monitorUI))		_body.removeChild(_monitorUI);
			
			TweenLite.to(_mapDupe, 4, { scaleX:2, scaleY:2, onUpdate:updateMapView, overwrite:0 });*/
			_map.container.cacheAsBitmap = true;
			
			TweenLite.to(_map, 4, { scale:1, onUpdate:updateMapView, overwrite:0, onComplete:fadeMap });
		}
		
		private function fadeMap():void{
			trace(this, "fadeMap");
			_monitorUI.visible = false;

			TweenLite.to(_body, 2, { alpha:0, delay:1, overwrite:0, onComplete:dispatchFinished });
		}
		
		/** Triggered when site animation is complete. Loads map view. */
		public function onSiteComplete($e:Event):void{ 
			_body.addChild(_map.container);
			
			var obj:Object = {index:2, type:'vo'};
			dispatchEvent(new SceneEvent(SceneEvent.SOUND_CUE_EVENT, obj));
			
			TweenLite.delayedCall(1, zoomMap);
			//TweenLite.delayedCall(6.5, dispatchFinished);
			_monitorUI.visible = false;
			_monitorUI.removeEventListener(Event.COMPLETE, onSiteComplete, true);
		}

		
		
		/** Resizes the map, receiving standard pixel values and taking into consideration
		 * the map object's default dimensions. */ 
		private function set mapWidth(num:Number):void{
			_map.container.width = num/_defMapDimensions.x* 100;
			_map.container.scaleY = _map.container.scaleX;
		}
		/** Resizes the map, receiving standard pixel values and taking into consideration
		 * the map object's default dimensions. */ 
		private function set mapHeight(num:Number):void{
			_map.container.height = num/_defMapDimensions.y* 100;
			_map.container.scaleX = _map.container.scaleY;
		}
		
	}
}