package com.ailk.common.ui.components.grid.advancedexdatagrid
{
	import flash.utils.setTimeout;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Alert;
	import mx.events.ResizeEvent;

	/**
	 *
	 * 高级表格扩展
	 * <p>版本回顾:</p>
	 * <ul>
	 * <li><b>1.0.0.20121018:</b>增加列百分比数组属性，支持列百分比配置<br>用法说明：percentColumnsWidth=[0.1,0.2,.3]</li>
	 * </ul>
	 * 
	 * @author shiliang (66614)
	 * @version 1.0
	 * @date 2012-10-18
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class AdvancedExDataGrid extends AdvancedDataGrid
	{
		private var _percentColumnsWidth:Array;

		public function AdvancedExDataGrid()
		{
			super();
			this.addEventListener(ResizeEvent.RESIZE, onResizeHandler);
		}

		private function onResizeHandler(event:ResizeEvent):void
		{
			setTimeout(calColumnWidth,100);
		}
		
		private function calColumnWidth():void{
			var column:AdvancedExDataGridColumn;
			for (var i:int=0; i < columns.length-1; i++)
			{
				column=columns[i];
				if (column.percentWidth && column.percentWidth > 0)
				{
					column.width=column.percentWidth * this.width;
				}
				else if (percentColumnsWidth && percentColumnsWidth.length > 0 && percentColumnsWidth[i] > 0)
				{
					column.width=percentColumnsWidth[i] * this.width;
				}
			}
		}

		public function get percentColumnsWidth():Array
		{
			return this._percentColumnsWidth;
		}

		public function set percentColumnsWidth(value:Array):void
		{
			this._percentColumnsWidth=value;
		}
	}
}