package com.ailk.common.ui.components.navbar.event
{
	import flash.events.Event;
	
	public class NavBarEvent extends Event
	{
		public static const CLOSE:String="close";
		public static const OPEN:String="open";
		public function NavBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}