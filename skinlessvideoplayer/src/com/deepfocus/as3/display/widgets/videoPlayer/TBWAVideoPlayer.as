package com.deepfocus.as3.display.widgets.videoPlayer{


	import com.bigspaceship.utils.Out;
	import com.deepfocus.as3.display.widgets.videoPlayer.thumbnailViewer.ThumbnailViewer;
	import com.egraphicsNY.events.VideoControlBarEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.utils.Timer;

	public class TBWAVideoPlayer extends Sprite{
		
		private var _mc								:MovieClip;
		private var _player							:Video;
		private var _netConnection					:NetConnection;
		private var _netStream						:NetStream;
		private var _metaData						:Object;
		private var _controlBar						:VideoControlBar;
		private var _isPlayingDirectFromURL			:Boolean;
		private var _movieURL						:String; 
		private var _playList						:XML;
		private var _playListIndex					:int;
		private var _delayPlayTimer					:Timer;	
		private var _movieDuration					:Number;
		private var _thumbNailViewer				:ThumbnailViewer;
		private var _playlistIsLoaded				:Boolean;
		private var _playListURL					:String;
		private var _urlLoader						:URLLoader;
		private var _seekPosition					:Number;
		private var _bufferTime						:Number;
		
		public function TBWAVideoPlayer($mc:MovieClip,$url:String=null,$bufferTime:Number=undefined){
			_mc			= $mc;	
//			_movieURL	= $url;
			_bufferTime = $bufferTime;
			addChild(_mc);
			_init();
		}
		private function _init():void{
				//player
			_player							= _mc.player;
			_netConnection					= new NetConnection();
			_netConnection.connect(null);
			_netStream						= new NetStream(_netConnection);
			_metaData						= {};
			_metaData.onMetaData			= _onMetaData;
			_netStream.client				= _metaData;
			_player.attachNetStream(_netStream);
					//controllbar
			_controlBar						= new VideoControlBar(_mc.controlBar);
					//listeners
			_netStream.addEventListener(NetStatusEvent.NET_STATUS,_onNetStatus,false,0,true);
			_netStream.addEventListener(NetStatusEvent.NET_STATUS,_controlBar.onNetStatus,false,0,true);			
			_controlBar.addEventListener(VideoControlBarEvent.PAUSE,_onControlVideo,false,0,true);
			_controlBar.addEventListener(VideoControlBarEvent.PLAY,_onControlVideo,false,0,true);
			_controlBar.addEventListener(VideoControlBarEvent.SOUND_OFF,_onControlVideo,false,0,true);
			_controlBar.addEventListener(VideoControlBarEvent.SOUND_ON,_onControlVideo,false,0,true);
			_controlBar.addEventListener(VideoControlBarEvent.VOLUME,_onControlVideo,false,0,true);
			_controlBar.addEventListener(VideoControlBarEvent.VIDEO_SLIDER_POSITION,_onControlVideo,false,0,true);
			_controlBar.addEventListener(VideoControlBarEvent.THUMBNAIL_VIEWER_BUTTON_CLICK,_onControlVideo,false,0,true);
			addEventListener(VideoControlBarEvent.LOADING,_controlBar.onLoadingEvent,false,0,true);
			addEventListener(VideoControlBarEvent.VIDEO_POSITION,_controlBar.onVideoPositionEvent,false,0,true);
			addEventListener(VideoControlBarEvent.RESET,_controlBar.reset,false,0,true);
//			addEventListener(ThumbnailEvent.ITEM_CHOOSEN,_thumbNailViewer.onAutoPlayChange,false,0,true);
//			_playVideo();			
		}
		public function playVideo($url:String=null):void{
/* 			_isPlayingDirectFromURL	= true;
			if($url){
				_movieURL = $url;
				_playVideo();
			}else if(_netStream.time < _movieDuration){
				_netStream.resume();
			}else{
				_playVideo();
			} */
			
			if($url) {_movieURL = $url;}
			_isPlayingDirectFromURL	= true;
//			_seekPosition = (_netStream.time < _movieDuration && _netStream.time > 1000) ? _netStream.time : undefined;
			_playVideo();
		}
		public function pauseVideo():void{
//			if(_netStream)_netStream.pause();
			
			if(_netStream){
				_netStream.close();
				if(_netStream.time > 1) _seekPosition =  _netStream.time;
			}
		}
		private function _playVideo($evt:TimerEvent=null):void{
			Out.info(this, '_playVideo()');
			dispatchEvent(new VideoControlBarEvent(VideoControlBarEvent.RESET));
//			if(!_isPlayingDirectFromURL) _movieURL		= _playList.trailer[_playListIndex].location;
			_netStream.pause();
			_netStream.close();
			_netStream.bufferTime						= (_bufferTime) ? _bufferTime : .2;
			_player.visible								= true;
			_netStream.play(_movieURL);
			if(_seekPosition > 0){
				_netStream.seek(_seekPosition);
			} 
			_mc.addEventListener(Event.ENTER_FRAME,_onCheckLoading,false,0,true);
			_mc.addEventListener(Event.ENTER_FRAME,_dispatchPlayerPostion,false,0,true);
			_isPlayingDirectFromURL						= false;
		}
		private function _onMetaData($data:Object):void{
//			Out.info(this,'_onMetaData() '+$data.duration);
			_movieDuration = $data.duration;
		}
		private function _onNetStatus($evt:NetStatusEvent):void{
			Out.info(this,'_onNetStatus() '+$evt.info.code.toString());
			switch($evt.info.code){
				case 'NetStream.Play.Stop':
					//called when mov is complete
					_mc.removeEventListener(Event.ENTER_FRAME,_dispatchPlayerPostion);
					dispatchEvent($evt);
					_player.visible	= false;
/* 						_playListIndex++;
						if(_playListIndex >=_playList.trailer.length()) _playListIndex = 0;
						_delayPlayTimer.stop();
						_delayPlayTimer.reset();
						_delayPlayTimer.start();
						dispatchEvent(new ThumbnailEvent(ThumbnailEvent.ITEM_CHOOSEN,_playListIndex));	 */					
					// if no playlist then it has not been loaded yet. condition only possible if pick a fight called before playlist
				break;
			}
		}		
		private function _onControlVideo($evt:VideoControlBarEvent):void{
			var trans:SoundTransform;
			switch($evt.type){
				case VideoControlBarEvent.PAUSE:
					_netStream.pause();
					_mc.removeEventListener(Event.ENTER_FRAME,_dispatchPlayerPostion);
				break;
				case VideoControlBarEvent.PLAY:
					Out.info(this, '_netStream.time '+_netStream.time+' _movieDuration '+_movieDuration+' _movieURL '+_movieURL+' _netStream '+_netStream.toString());
					_player.visible								= true;
					if(_netStream.time < _movieDuration- .04){ //  - .02 ya its a hack, but the movie is over and its time is still less than duration
						_netStream.resume();
					}else{
						_netStream.play(_movieURL);
					}
					_mc.addEventListener(Event.ENTER_FRAME,_dispatchPlayerPostion,false,0,true);
				break;
				case VideoControlBarEvent.SOUND_OFF:
					Out.info(this,'VideoControlBarEvent.SOUND_OFF');
 					trans 						= _netStream.soundTransform;
					trans.volume 				= 0;
					_netStream.soundTransform	= trans; 
				break;
				case VideoControlBarEvent.SOUND_ON:
					Out.info(this,'VideoControlBarEvent.SOUND_ON');
 					trans 						= _netStream.soundTransform;
					trans.volume 				= 1;
					_netStream.soundTransform	= trans; 
				break;
				case VideoControlBarEvent.VOLUME:
					Out.info(this,'VideoControlBarEvent.SOUND_ON');
 					trans 						= _netStream.soundTransform;
					trans.volume 				= $evt.value;
					_netStream.soundTransform	= trans; 					
				break;
				case VideoControlBarEvent.VIDEO_SLIDER_POSITION:
					Out.info(this,'VideoControlBarEvent.SOUND_ON');
					_netStream.seek(Number(_movieDuration*$evt.value)); 					
				break;	
				case VideoControlBarEvent.THUMBNAIL_VIEWER_BUTTON_CLICK:
					// posible this could be called in pickafight mode before thumbnail viewr is inited
				if(_thumbNailViewer){
					if(_thumbNailViewer.isIn){
						_thumbNailViewer.animateOut();
//						_netStream.resume();
					}else{
						_netStream.pause();
						_thumbNailViewer.animateIn();
					}
				}
					 
				break;		
			}
		}
		private function _dispatchPlayerPostion($evt:Event):void{
//			Out.info(this,'_dispatchPlayerPostion() !!!!!!!!!!'+Number(_netStream.time/_movieDuration)+' _netStream.time: '+_netStream.time+' _movieDuration: '+_movieDuration);
			var percent:Number = Number(_netStream.time/_movieDuration)
			dispatchEvent(new VideoControlBarEvent(VideoControlBarEvent.VIDEO_POSITION, percent));
		}
		private function _onCheckLoading($evt:Event):void{
			var percent:Number = Math.round(Number(_netStream.bytesLoaded/_netStream.bytesTotal*100));
//			Out.info(this, '_onCheckLoading() percent !!!!!!!!!!'+percent+' bytesLoaded: '+_netStream.bytesLoaded+' _netStream.bytesTotal: '+_netStream.bytesTotal);
			if(percent == 100)_mc.removeEventListener(Event.ENTER_FRAME,_onCheckLoading);
			dispatchEvent(new VideoControlBarEvent(VideoControlBarEvent.LOADING, percent));			
		}			
		public function kill():void{
			removeChild(_mc);
			_mc.stop();
			_mc										= null;
		}
	}
}