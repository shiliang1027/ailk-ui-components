package com.ailk.common.ui.components.dummymap
{
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class ViewConfig
	{
		public var mapUrl:String="dummyMap.xml";
		public var viewUrl:String="dummyView.xml";
		private static var instance:ViewConfig=null;
		private var app:Object;
		public function ViewConfig()
		{
		}
		
		public static function getInstance():ViewConfig{
			if (instance == null){
				instance = new ViewConfig();
			}
			return instance;
		}
		
		public function ReadConfig(application:Object):void
		{
			this.app = application;
			var mapService:HTTPService = new HTTPService();   
			mapService.url = mapUrl;   
			mapService.addEventListener(ResultEvent.RESULT, mapResultHandler);			
			mapService.send(); 
			var viewService:HTTPService = new HTTPService();   
			viewService.url = viewUrl;   
			viewService.addEventListener(ResultEvent.RESULT, viewResultHandler);			
			viewService.send(); 
		}
		
		private function mapResultHandler(event:ResultEvent):void
		{ 	
			
		}
		
		private function viewResultHandler(event:ResultEvent):void
		{ 	
			
		}
	}
}