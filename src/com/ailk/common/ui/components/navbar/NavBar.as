package com.ailk.common.ui.components.navbar
{
	import flash.events.MouseEvent;

	import mx.controls.Image;
	import mx.effects.Parallel;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;

	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Panel;
	import spark.effects.Move;
	import spark.effects.Resize;

	[IconFile("assets/tab_side.png")]
	[Event(name="close", type="com.ailk.common.ui.components.navbar.event.NavBarEvent")]
	[Event(name="open", type="com.ailk.common.ui.components.navbar.event.NavBarEvent")]

	public class NavBar extends Panel
	{
		[SkinPart(required="false")]
		public var content:Group;
		[SkinPart(required="false")]
		public var titleGroup:Group;
		[SkinPart(required="false")]
		public var closeBtn:Button;
		[SkinPart(required="false")]
		public var icon:Image;

		private var _moveA:Move;
		private var _moveB:Move;
		private var _resizeA:Resize;
		private var _resizeB:Resize;

		private var _xFrom:Number;
		private var _xTo:Number;
		private var _widthFrom:Number;
		private var _widthTo:Number;

		private var _location:String;
		private var _titleLocation:String;

		public function NavBar()
		{
			super();
			if (!location)
			{
				location="left";
			}
			if (!titleLocation)
			{
				titleLocation="top";
			}
		}


		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (instance == titleGroup)
			{
				titleGroup.addEventListener(MouseEvent.CLICK, open);
			}
		}

		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if (instance == titleGroup)
			{
				titleGroup.removeEventListener(MouseEvent.CLICK, open);
			}
		}

		//打开关闭
		private function open(event:MouseEvent):void
		{
			content.visible=!content.visible;
		}

		public function get location():String
		{
			return this._location;
		}

		[Inspectable(category="General", enumeration="left,right", defaultValue="left")]
		public function set location(value:String):void
		{
			this._location=value;
			this.setStyle("location", this._location);
		}

		public function get titleLocation():String
		{
			return _titleLocation;
		}

		[Inspectable(category="General", enumeration="top,bottom", defaultValue="top")]
		public function set titleLocation(value:String):void
		{
			_titleLocation=value;
			this.setStyle("titleLocation", this._titleLocation);
		}


	}
}