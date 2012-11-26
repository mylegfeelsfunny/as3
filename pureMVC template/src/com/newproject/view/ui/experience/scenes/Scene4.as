package com.office365.view.ui.experience.scenes{
	import com.deepfocus.as3.apps.mapviewer.MapLoader;
	import com.deepfocus.as3.display.images.ImageLoader;
	import com.deepfocus.as3.display.video.videoplayer.ChromelessVideoPlayer;
	import com.deepfocus.as3.display.video.videoplayer.events.VideoControllerEvent;
	import com.deepfocus.as3.templates.microsite.AbstractMain;
	import com.deepfocus.as3.utils.LibraryAssetRetriever;
	import com.deepfocus.as3.utils.StringUtils;
	import com.deepfocus.as3.utils.TextUtils;
	import com.deepfocus.as3.utils.TimeUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	import com.office365.ApplicationFacade;
	import com.office365.model.DataCacheProxy;
	import com.office365.view.ExperienceMediator;
	import com.office365.view.ui.PhotoWall;
	import com.office365.view.ui.experience.event.SceneEvent;
	import com.office365.view.ui.pickers.contactpicker.ContactPicker;
	import com.office365.view.ui.pickers.event.PickerEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public final class Scene4 extends FlashScene{
		
		
		private var _venture:MovieClip;
		private var _win8:MovieClip;
		private var _dcProxy:DataCacheProxy;
		private var _videoPlayer:ChromelessVideoPlayer;
		private var _userImage:ImageLoader;
		
		public function Scene4($linkedIn:Object, $classInfo:Object){
			super($linkedIn, $classInfo);
		}
		
		override public function prepareBody():void{
			trace(this, "prepareBody" );
			var facade:ApplicationFacade = ApplicationFacade.getInstance();
			_dcProxy = facade.retrieveProxy(DataCacheProxy.NAME) as DataCacheProxy;
			_venture = LibraryAssetRetriever.getAsset("ventureReview");
			_win8 = LibraryAssetRetriever.getAsset("win8sequence");
			
			var mainImg:MovieClip = _venture.screen.browser.sitePg1.pg1Content.mainImg;
			var userName:String = _linkedIn["firstname"] +' '+_linkedIn["lastname"];
			_userImage = new ImageLoader(DataCacheProxy.IMAGEPROXY+ _linkedIn["pictureurl"]);
			
			
			
			
			_win8.loginSeq.screen.userAccount.uName.text = userName;
			_win8.loginSeq.screen.startupAnim.uName.text = userName;
			_body.addChild(_venture);
			//_body.addChild(_win8);
			
			//_userImage.mask = mainImg.masker;
			//_userImage.maxBounds = {width:mainImg.masker.width, height:mainImg.masker.height};
			_userImage.addEventListener(Event.COMPLETE, onUserImgLoaded, false, 0, true);
			_venture.addEventListener('done', onSiteComplete, true, 0, true);
			//mainImg.addChild();
			
			_videoPlayer = new ChromelessVideoPlayer(AbstractMain.PATH+_xml.video, 960, 540)
			_videoPlayer.addEventListener(VideoControllerEvent.CONNECTION_MADE, videoReadyHandler, false, 0);
			_videoPlayer.addEventListener(VideoControllerEvent.VIDEO_OVER, videoOverHandler, false, 0);
			_videoPlayer.visible = false;
			_body.addChild(_videoPlayer);

		}
		
		/** Populates the team sidebar (Venture site) and IM window (Metro UI)
		 *  with info pertaining to the user's chosen teammates. */
		private function popTeammateInfo():void{
			var i:int = -1;
			var cNameTf:TextField;
			var cLocTf:TextField;
			var cPhoto:MovieClip;
			var cName:String;
			
			TextUtils.getProperties(cLocTf);
			
			while(++i < _dcProxy.teammates.length){
				var img:ImageLoader = new ImageLoader();
				cNameTf = _venture.screen.browser.sitePg1.pg1Content['cName'+(i+1)];
				cLocTf = _venture.screen.browser.sitePg1.pg1Content['cLoc'+(i+1)];
				cPhoto = _venture.screen.browser.sitePg1.pg1Content['cPhoto'+(i+1)];
				cName = String(_dcProxy.teammates[i]['firstname'] + '\n'+ _dcProxy.teammates[i]['lastname']).toUpperCase();
				
				_win8.IMseq.chatWin['sideName'+(i+1)].text = StringUtils.toTitleCase(_dcProxy.teammates[i]['firstname'] +' '+ _dcProxy.teammates[i]['lastname']);
				
				//trace('');
				//trace('teammate '+i, cName, _dcProxy.teammates[i]['location']);
				cNameTf.text = cName;
				cLocTf.text = _dcProxy.teammates[i]['location'];
				
				img.maxBounds = {width:47, height:47};
				img.mask = _venture.screen.browser.sitePg1.pg1Content['cPhoto'+(i+1)].masker;
				img.addEventListener(Event.COMPLETE, onProfileImgLoaded, false, 0, true);
				img.loadImage(DataCacheProxy.IMAGEPROXY+ _dcProxy.teammates[i]['pictureurl']);
				
				cPhoto.addChild(img);
			}
		}
		
		override public function playSection():void { 
			trace(this, "playSection" );
			

			////--------------------------------------------------------------------------
			// IM popoulation 
			//--------------------------------------------------------------------------
			var heroName:String = StringUtils.toTitleCase(_linkedIn["firstname"]);
			var f1Name:Object = {first:StringUtils.toTitleCase(_dcProxy.teammates[0]['firstname']), last:StringUtils.toTitleCase(_dcProxy.teammates[0]['lastname'])};
			var blurb1:String = "Hi all, Check out the PowerPoint I just created with "+ heroName + ".";
			//var blurb2:String = f1Name.first +", can you please save the Powerpoint to the Sharepoint Online team site?";
			var blurb3:String = "Yeah, sure thing "+StringUtils.toTitleCase(_linkedIn["firstname"]) +"! \nIt's looking awesome!";
			var friendName:Object = {first:StringUtils.toTitleCase(_dcProxy.teammates[0]['firstname']), last:StringUtils.toTitleCase(_dcProxy.teammates[0]['lastname'])};
			
			_win8.loginSeq.postit.text = 'call '+f1Name.first;
			//_win8.IMseq.chatWin.friendName.text = f1Name.first;
			_win8.IMseq.chatWin.comment1.comment.text = blurb1;
			_win8.IMseq.chatWin.comment1.username.text = friendName.first;
			_win8.IMseq.chatWin.comment2.username.text = heroName;
			_win8.IMseq.chatWin.comment3.comment.text = blurb3;
			_win8.IMseq.chatWin.comment3.username.text = friendName.first;
			
			
			//trace(this, "heroName", heroName);
			//trace(this, "friendName.first", friendName.first);
			
			//trace(this, "heroName", heroName);
			//trace(this, "_win8.IMseq.chatWin.comment1.username.text", _win8.IMseq.chatWin.comment1.username.text);
			//trace(this, "_win8.IMseq.chatWin.comment2.username.text", _win8.IMseq.chatWin.comment2.username.text);
			//trace(this, "_win8.IMseq.chatWin.comment3.username.text", _win8.IMseq.chatWin.comment3.username.text);
			
			//time
			var timeU:TimeUtil = TimeUtil.getInstance();
			var d:Date = new Date();
			_win8.IMseq.chatWin.comment3.time.text = timeU.getTime(d);
			d.setMinutes(d.getMinutes() - 8);
			_win8.IMseq.chatWin.comment2.time.text = timeU.getTime(d);
			d.setMinutes(d.getMinutes() - 6);
			_win8.IMseq.chatWin.comment1.time.text = timeU.getTime(d);
			
			var commentX:Number;
			_win8.IMseq.chatWin.comment1.username.autoSize = _win8.IMseq.chatWin.comment2.username.autoSize = _win8.IMseq.chatWin.comment3.username.autoSize = TextFieldAutoSize.LEFT;
			//commentX = _win8.IMseq.chatWin.heroName1.x + Math.max(_win8.IMseq.chatWin.heroName1.width, _win8.IMseq.chatWin.friendName.width);
			//_win8.IMseq.chatWin.comment1.x = _win8.IMseq.chatWin.comment2.x = _win8.IMseq.chatWin.comment3.x = commentX;
			
			_venture.screen.browser.sitePg1.quote1.cName.text = String(f1Name.first +' '+f1Name.last).toUpperCase();
			popTeammateInfo();

			_venture.screen.browser.sitePg1.gotoAndPlay(2);
			
			TweenMax.from(_body, 1, {alpha:0, ease:Strong.easeOut, overwrite:0});
			var obj:Object = {index:3, type:'vo'};
			dispatchEvent(new SceneEvent(SceneEvent.SOUND_CUE_EVENT, obj))

			obj = {origin:"experience", scene:"4"}
			dispatchEvent(new SceneEvent(SceneEvent.TRACKING, obj));

			super.playSection();
		}
		
		private function prepMetro():void{
			var miniMasker:MovieClip = _win8.loginSeq.screen.startupAnim.uImg.masker;
			var loginMasker:MovieClip = _win8.loginSeq.screen.userAccount.image.masker;
			var miniBtDat:BitmapData = Bitmap(_userImage.asset).bitmapData.clone();
			var miniImg:Bitmap = new Bitmap(miniBtDat, 'auto', true);
			
			//_win8.addEventListener('IMwindow', animateIMwindow, false, 0, true);

			_win8.addEventListener('cue_sound', onSoundCue);

			miniImg.width = miniMasker.width;
			miniImg.scaleY = miniImg.scaleX;			
			if(miniImg.height < miniMasker.height){
				miniImg.height = miniMasker.height;
				miniImg.scaleX = miniImg.scaleY;
				miniImg.mask = miniMasker;
				miniImg.smoothing = true;
			}
			
			//recycle user profile image
			_win8.loginSeq.screen.userAccount.image.addChild(_userImage.asset);
			_win8.loginSeq.screen.startupAnim.uImg.addChild(miniImg);
			
			_userImage.asset.width = loginMasker.width;
			_userImage.asset.scaleY = _userImage.scaleX;			
			if(_userImage.asset.height < loginMasker.height){
				_userImage.asset.height = loginMasker.height;
				_userImage.asset.scaleX = _userImage.asset.scaleY;
				_userImage.asset.mask = loginMasker;
			}
		}
		
		override public function resize(obj:Object):void{
			try {
			_body.y = obj.offsetY;
			_venture.scaleX = Math.max(1, obj.width/_venture.mainMask.width);
			_venture.scaleY = _venture.scaleX;
			_win8.scaleX = _win8.scaleY = Math.max(1, obj.width/_win8.mainMask.width);
			
			_videoPlayer.x = _videoPlayer.y = 0;
			_videoPlayer.width = obj.width;
			_videoPlayer.height = obj.height;
			
			} catch(e:Error) { trace(this, "error", e.message);}
		}
		
		override public function destroyBody($e:Event):void{
			var i:int = -1;
			var cPhoto:MovieClip;
			
			while(++i < _dcProxy.teammates.length){
				cPhoto = _venture.screen.browser.sitePg1.pg1Content['cPhoto'+(i+1)];
				var img:ImageLoader = cPhoto.getChildAt(cPhoto.numChildren - 1) as ImageLoader;
				if(img){
					img.destroy();
					img.removeEventListener(Event.COMPLETE, onProfileImgLoaded, false);
				}
			}
			if(_body.contains(_venture))	_body.removeChild(_venture);
			if(_body.contains(_win8))		_body.removeChild(_win8);
			_venture.removeEventListener('done', onSiteComplete, true);
			_win8.removeEventListener('done', onMetroComplete, false);
			
			_body.removeChild(_videoPlayer);
			_videoPlayer = null;

			super.destroyBody($e);
		}
		
		
		/** Triggered when a profile image is loaded. */
		private function onUserImgLoaded($e:Event):void{
			var img:ImageLoader = $e.target as ImageLoader;
			var mainImg:MovieClip = _venture.screen.browser.sitePg1.pg1Content.mainImg;
			sizeAndPlace(mainImg, img.bitmap);
			img.removeEventListener(Event.COMPLETE, onUserImgLoaded, false);
		}
		
		/** Triggered when a profile image is loaded. */
		private function onProfileImgLoaded($e:Event):void{
			var img:ImageLoader = $e.target as ImageLoader;
			if(img.width < img.maxBounds.width){
				img.width = img.maxBounds.width;
				img.scaleY = img.scaleX;
			}
			if(img.height < img.maxBounds.height){
				img.height = img.maxBounds.height;
				img.scaleX = img.scaleY;
			}
			img.removeEventListener(Event.COMPLETE, onProfileImgLoaded, false);
		}
		
		/** Triggered when site animation is complete. */
		private function onSiteComplete($e:Event):void{
			prepMetro();
			_venture.removeEventListener('done', onSiteComplete, true);
			_body.removeChild(_venture);
			
			_body.addChild(_win8);
			
			var obj:Object = {index:4, type:'vo'};
			dispatchEvent(new SceneEvent(SceneEvent.SOUND_CUE_EVENT, obj))

			_win8.addEventListener('done', onMetroComplete, false, 0, true);
			_win8.addEventListener("fishy", onFishyHandler, false, 0, true);
			_win8.gotoAndPlay(2);
		}
		
		private function onSoundCue($e:Event):void
		{
			trace(this, "onSoundCue");
			_win8.removeEventListener('cue_sound', onSoundCue);
			var obj:Object = {index:5, type:'vo'};
			dispatchEvent(new SceneEvent(SceneEvent.SOUND_CUE_EVENT, obj));
		}
		
		/** Triggered when Windows 8 sequence is complete. */
		private function onMetroComplete($e:Event):void{
			_win8.removeEventListener('done', onMetroComplete, false);
			dispatchFinished();
		}
		
		/** Triggered when IM window appears. */
		private function animateIMwindow($e:Event):void{
/*			var mssg1:Array = [_win8.IMseq.chatWin.time1, _win8.IMseq.chatWin.heroName1, _win8.IMseq.chatWin.comment1];
			var mssg2:Array = [_win8.IMseq.chatWin.time2, _win8.IMseq.chatWin.heroName2, _win8.IMseq.chatWin.comment2];
			var mssg3:Array = [_win8.IMseq.chatWin.time3, _win8.IMseq.chatWin.friendName, _win8.IMseq.chatWin.comment3];
			
			_win8.removeEventListener('IMwindow', animateIMwindow, true);
			
			TweenMax.allTo(mssg1, .5, {alpha:1});
			TweenMax.allTo(mssg2, .5, {alpha:1, delay:1.25});
			TweenMax.allTo(mssg3, .5, {alpha:1, delay:2.75});
*/		}
		
		
		
		
		//--------------------------------------------------------------------------
		// SCOTTS Event handlers 
		//--------------------------------------------------------------------------
		private function onFishyHandler($e:Event):void
		{
			_win8.removeEventListener("fishy", onFishyHandler);
			_body.addChild(_videoPlayer);
			_videoPlayer.visible = true;
			_videoPlayer.resume();
		}
		
		private function videoReadyHandler($e:VideoControllerEvent):void
		{
			super.prepareBody();
		}
		
		private function videoOverHandler($e:VideoControllerEvent):void
		{
			_videoPlayer.visible = false;
			_win8.gotoAndPlay(110);
		}
		
	}
}