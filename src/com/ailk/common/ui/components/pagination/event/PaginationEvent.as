package com.ailk.common.ui.components.pagination.event
{
	import flash.events.Event;
	
	/**
	 * 分页组件事件
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-6-20 下午04:44:26
	 * @category com.ailk.common.ui.components.pagination.event
	 * @copyright 南京联创科技 网管开发部
	 */
	public class PaginationEvent extends Event
	{
		public static const PAGE_FIRST:String = "firstPage";
		public static const PAGE_PRE:String = "prePage";
		public static const PAGE_NEXT:String = "nextPage";
		public static const PAGE_LAST:String = "lastPage";
		public static const PAGE_CHANGE:String = "pageChange";
		public function PaginationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}