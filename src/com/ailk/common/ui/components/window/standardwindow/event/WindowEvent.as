package com.ailk.common.ui.components.window.standardwindow.event
{
	import com.ailk.common.ui.components.window.standardwindow.Window;
	
	import flash.events.Event;

	public class WindowEvent extends Event
	{
		public var window:Window;
		public static const CLOSE:String="close";

		public static const MAXIMIZE:String="maximize";

		public static const MINIMIZE:String="minimize";

		public static const RESTORE:String="restore";

		public static const FOCUS_START:String="focusstart";

		public static const FOCUS_END:String="focusend";
		
		public static const CONFIG:String="config";

		public function WindowEvent(type:String,_window:Window=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.window=_window;
		}
	}
}