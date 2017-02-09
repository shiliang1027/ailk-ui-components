package com.ailk.common.ui.components.grid.datagridex
{
	import mx.controls.dataGridClasses.DataGridColumn;
	
	/**
	 * 
	 * 表格列扩展
	 * <p>版本回顾:</p>
	 * <ul>
	 * <li><b>1.0.0.20121018:</b>增加列百分比属性，支持列百分比配置<br>用法说明：percentWidth=0.1</li>
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
	public class DataGridColumnEx extends DataGridColumn
	{
		private var _percentWidth:Number;
		public function DataGridColumnEx(columnName:String=null)
		{
			super(columnName);
		}
		
		public function get percentWidth():Number{
			return this._percentWidth;
		}
		
		public function set percentWidth(value:Number):void{
			this._percentWidth = value;
		}
	}
}