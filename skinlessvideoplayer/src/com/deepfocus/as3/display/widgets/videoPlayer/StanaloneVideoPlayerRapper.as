package com.deepfocus.as3.display.widgets.videoPlayer{

	import com.bigspaceship.utils.Out;
	import com.deepfocus.as3.events.SingleAssetLoaderEvent;
	import com.egraphicsNY.loading.SingleAssetLoder;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;

	public class StanaloneVideoPlayerRapper extends MovieClip{
		
		public var vidoeAssets						:MovieClip;
		public var backGroundImage					:MovieClip;
		private var _vp								:TBWAVideoPlayer;
		private var _video							:Video;
		private var _controlBar						:MovieClip;
		private var _videoURL						:String;
		private var _backgroundLoader				:SingleAssetLoder;
		
		private const CONTROLBAR_PADDING			:int	= 3;
		
		public function StanaloneVideoPlayerRapper(){
			addEventListener(Event.ADDED_TO_STAGE,_init,false,0,true);
			
		}
		private function _init($evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,_init,false);
			Out.enableAllLevels();
			Out.info(this,'_init()');
			var p:Object = stage.loaderInfo.parameters;
			Out.traceObject(this,'flashVars',p);
			stage.scaleMode						= StageScaleMode.NO_SCALE;
			stage.align							= StageAlign.TOP_LEFT; 
			
			_video								= vidoeAssets.vp.player;
			_controlBar							= vidoeAssets.vp.controlBar;
			
			var frameRate:int					= int(p.frameRate);
			if(frameRate > 0 && frameRate < 100) stage.frameRate = frameRate;
			
			if(p.flvHeight)	_video.height		= Number(p.flvHeight);
			_controlBar.y						= Math.floor(_video.height+CONTROLBAR_PADDING);
			
			if(p.flvWidth)	_video.width		= Number(p.flvWidth);

			
			_videoURL							= (p.flvWidth) ? p.flvURL : 'media/flv/BC_Fireman_450x253.flv';
			var bt:Number						= (p.bufferTime) ? Number(p.bufferTime) : undefined;
			_vp									= new TBWAVideoPlayer(vidoeAssets.vp,_videoURL,bt);
			_vp.addEventListener(NetStatusEvent.NET_STATUS,_onVideoComplete,false,0,true);
			addChild(_vp);
			
			_setcontrolBarWidth();
			_setBackground(p.backgroundURL);
			
		
			(p.autoPlay=='true') ? _vp.playVideo(_videoURL) : setBigButton();	
		}
		private function _onVideoAreaClicked($evt:MouseEvent):void{
			backGroundImage.removeEventListener(MouseEvent.CLICK,_onVideoAreaClicked);
			backGroundImage.mouseChildren		= true;
			backGroundImage.buttonMode			= false;
			_vp.removeEventListener(MouseEvent.CLICK,_onVideoAreaClicked);
			_vp.mouseChildren					= true;
			_vp.buttonMode						= false;			
			_vp.playVideo(_videoURL);
		}
		private function _setcontrolBarWidth():void{
			var backGround:MovieClip			= _controlBar.backGround;
			var rightVertLine:MovieClip			= _controlBar.rightVertLine;
			var farRightVertLine:MovieClip		= _controlBar.farRightVertLine;
			var sound_mov:MovieClip				= _controlBar.sound_mov;			
			var sliderBorder:MovieClip			= _controlBar.videoSlider.sliderBorder;			
			var sliderBorderVB:MovieClip		= _controlBar.videoSlider.verticleBorder;
			backGround.width 					= _video.width 			-  2; //x is 1 and 1 px ofset at end for border
			rightVertLine.x						= _video.width 			- 20;
			farRightVertLine.x					= _video.width 			-  1;
			sound_mov.x							= _video.width 			- 19;
			sliderBorder.width					= _video.width 			- 55;
			sliderBorderVB.x					= sliderBorder.width;
		}
		private function _setBackground($url:String=null):void{
			var background:MovieClip			= backGroundImage.background;
			var logo:MovieClip					= backGroundImage.logo;
			
			background.width					= _video.width;
			logo.x								= (background.width/2) - (logo.width/2);
			
			background.height					= _video.height;
			logo.y								= (background.height/2) - (logo.height/2);
			
				
			if($url){
				_backgroundLoader		= new SingleAssetLoder();
				_backgroundLoader.addEventListener(SingleAssetLoaderEvent.LOAD_COMPLETE,_onBackGroundImageComplete,false,0,true);
				_backgroundLoader.load($url);
			}
		}
		private function _onBackGroundImageComplete($evt:SingleAssetLoaderEvent):void{
			backGroundImage.anchor.addChild(Bitmap($evt.asset));
		}
		private function _onVideoComplete($evt:NetStatusEvent):void{
			switch($evt.info.code){
				case 'NetStream.Play.Stop':
					setBigButton();
				break;	
			}
		}
		private function setBigButton():void{
			backGroundImage.addEventListener(MouseEvent.CLICK,_onVideoAreaClicked,false,0,true);
			backGroundImage.mouseChildren		= false;
			backGroundImage.buttonMode			= true;
			_vp.addEventListener(MouseEvent.CLICK,_onVideoAreaClicked,false,0,true);
			_vp.mouseChildren					= false;
			_vp.buttonMode						= true;				
		}
	}
}
	
