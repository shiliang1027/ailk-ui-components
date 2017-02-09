package com.ailk.common.ui.components.dynamicdropdown.event
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 该as的描述信息
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2012-2-29 上午10:54:47
	 * @category com.ailk.common.ui.components.dynamicdropdown.event
	 * @copyright 南京联创科技 网管开发部
	 */
	public class DynamicDropDownEvent extends Event
	{
		public static const KEYWORDQUERY:String="keyWordQuery";
		public static const DATALISTCHANGE:String="dataListChange";
		public static const QUERY:String="query";
		public static const DATASELECTED:String = "dataSelected";
		public static const INIT:String = "init";
		
		public function DynamicDropDownEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}