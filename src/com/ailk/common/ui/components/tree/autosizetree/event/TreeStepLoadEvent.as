package com.ailk.common.ui.components.tree.autosizetree.event
{
	import flash.events.Event;

	/**
	 * 树节点分步加载事件
	 *
	 * @author duangr (65250)
	 * @version 1.0
	 * @date 2012-6-14
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class TreeStepLoadEvent extends Event
	{
		/**
		 * 事件类型: 触发加载树上具体节点的子节点事件
		 */
		public static const LOAD_CHILDREN:String = "loadChildren";

		private var _data:* = null;

		public function TreeStepLoadEvent(type:String, data:*, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}

		/**
		 * 当前触发事件的树节点数据
		 * @return
		 *
		 */
		public function get data():*
		{
			return _data;
		}

		override public function clone():Event
		{
			return new TreeStepLoadEvent(type, _data, bubbles, cancelable);
		}

		override public function toString():String
		{
			return "[TreeLoadEvent] " + type;
		}

	}
}