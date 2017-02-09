package com.ailk.common.ui.components.tree.autosizetree
{
	import flash.events.Event;

	import mx.controls.Tree;
	import mx.core.ScrollPolicy;
	import mx.core.mx_internal;

	/**
	 *  Dispatched when a item is opened or expanded first time.
	 *
	 *  @eventType com.ailk.common.ui.components.tree.autosizetree.TreeLoadEvent
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="loadChildren", type="com.ailk.common.ui.components.tree.autosizetree.event.TreeStepLoadEvent")]

	/**
	 * 能自动调整宽高,出现滚动条的Tree
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
	public class AutoSizeTree extends Tree
	{
		public function AutoSizeTree()
		{
			super();
			horizontalScrollPolicy = ScrollPolicy.AUTO;
			verticalScrollPolicy = ScrollPolicy.AUTO;
		}

		override public function get maxHorizontalScrollPosition():Number
		{
			if (isNaN(mx_internal::_maxHorizontalScrollPosition))
				return 0;
			return mx_internal::_maxHorizontalScrollPosition;
		}

		override public function set maxHorizontalScrollPosition(value:Number):void
		{
			mx_internal::_maxHorizontalScrollPosition = value;
			dispatchEvent(new Event("maxHorizontalScrollPositionChanged"));
			scrollAreaChanged = true;
			invalidateDisplayList();
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var diffWidth:Number = measureWidthOfItems(0, 0) - (unscaledWidth - viewMetrics.left - viewMetrics.right);

			var indentation:Number = getStyle("indentation");

			if (diffWidth <= 0)
				maxHorizontalScrollPosition = NaN;
			else
				maxHorizontalScrollPosition = diffWidth + indentation;
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}

	}
}