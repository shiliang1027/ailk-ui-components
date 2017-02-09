package com.ailk.common.ui.components.requestserver
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;

	/**
	 * 该as的描述信息
	 * @author shiliang(66614) Tel:18661205639
	 * @version 1.0
	 * @since 2014-10-13 上午10:29:43
	 * @category com.linkage.module.cms.utils
	 * @copyright 南京联创科技 网管开发部
	 */
	public class RequestServerUtil
	{
		private var log:ILogger = Log.getLoggerByClass(RequestServerUtil);
		public static const REQUEST_COMPLETE:String = "REQUEST_COMPLETE";
		[MessageDispatcher]
		public var dispatchMsg:Function;
		private var requestArray:Array=new Array();
		private var sorted:Boolean=false;
		public var sortArray:Array=new Array();
		private var finshed:Boolean=true;
		private var timer:Timer = new Timer(500);
		public var parallelMax:int = 2;
		private var parallelNum:int=0;
		private var requeseTypeArray:ArrayCollection = new ArrayCollection();
		
		public function RequestServerUtil()
		{
			timer.addEventListener(TimerEvent.TIMER,onTimerHandler);
//			parallelNum=parallelMax;
		}
		
		private function onTimerHandler(event:TimerEvent):void{
			if(finshed && requestArray.length>0){
				dispatchMsg(new Event("REQUEST_COMPLETE"));
			}
		}
		
		public function addRequest(requestEvent:Event):void{
			if(!requeseTypeArray.contains(requestEvent.type)){
				sorted=false;
				requestArray.push(requestEvent);
				requeseTypeArray.addItem(requestEvent.type);
				log.debug("【addRequest】request.length:{0},type:{1}",requestArray.length,requestEvent.type);
			}else{
				log.debug("【addRequest】请求已存在:{0}",requestEvent.type);
			}
//			timer.reset();
			timer.start();
		}
		
		private function removeRequest():void{
			
		}
		
		[MessageHandler(selector = "REQUEST_CLEAR")]
		public function clearRequest(e:Event):void{
			requeseTypeArray.removeAll();
			requestArray.splice(0,requestArray.length);
		}
		
		[MessageHandler(selector = "REQUEST_COMPLETE")]
		public function doRequest(e:Event):void{
			if(requestArray.length>0){
				if(!sorted){
					sorted=true;
					requestArray.sort(sortFun);
					log.debug("sortArray:{0}",sortArray);
				}
//				log.debug("parallelNum:{0},requestArray.length:{1}",parallelNum,requestArray.length);
				finshed=false;
				var max:int=parallelMax<=requestArray.length?parallelMax:requestArray.length;
//				if(parallelNum==max){
					for(var i:int=0;i<max;i++){
						var reqEvt:Event = requestArray.shift() as Event;
						requeseTypeArray.removeItemAt(requeseTypeArray.getItemIndex(reqEvt.type));
						log.debug("【doRequest】request.length:{0},type:{1}",requestArray.length+1,reqEvt.type);
						dispatchMsg(reqEvt);
					}
//					parallelNum=0;
//				}else{
//					parallelNum++;
//				}
			}else{
				finshed=true;
			}
		}
		
		public function sortFun(a:Event,b:Event):int{
			var i:int=0,j:int=0;
			sortArray.forEach(function(item:*, index:int, array:Array):void{
				if(item == a.type){
					i=index;
				}
				if(item == b.type){
					j=index;
				}
			});
			log.info("i:{0},j:{1}",i,j);
			if(i < j){
				return -1; //a在前,b在后
			}else if(i == j){
				return 0; //ab位置不变
			}else{
				return 1; //b在前,a在后
			}
		}
	}
}