package com.ailk.common.ui.components.window.normalwindow.event
{
	import flash.events.Event;
	
	/**
	 * 该as的描述信息
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-10-9 上午11:56:14
	 * @category com.ailk.common.ui.components.window.normalwindow.event
	 * @copyright 南京联创科技 网管开发部
	 */
	public class NormalWindowExtEvent extends Event
	{
		public static const CLOSE:String="close";
		
		public static const MAXIMIZE:String="maximize";
		
		public static const MINIMIZE:String="minimize";
		
		public static const RESTORE:String="restore";
		
		public static const FOCUS_START:String="focusstart";
		
		public static const FOCUS_END:String="focusend";
		
		public static const CONFIG:String="config";
		
		public function NormalWindowExtEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}