package{
	
	import com.deepfocus.as3.templates.microsite.AbstractFlexProxy;
	import com.office365.Office365;
	import com.office365.Office365_Loader;
	
	import flash.events.Event;
	
	[SWF(width="960", height="540", backgroundColor="#fff", bacframeRate="30")]	

	public class Office365_Flex extends AbstractFlexProxy{
		
		//protected const PATH										:String = "../deploy/office365_loader.swf";
		protected const PATH										:String = "../deploy/assets/swf/office365.swf";
		
		public function Office365_Flex (){
			super(PATH);
		}
		
		override protected function onAssetLoadComplete($evt:Event):void{
			//remove xml listeners, init asset manager and pass it asset mc and xml
			//addChild($evt.target.content as Office365_Loader);
		
			addChild($evt.target.content as Office365);
			super.onAssetLoadComplete($evt);
		}
	}
}	
