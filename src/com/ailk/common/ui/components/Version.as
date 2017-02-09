package com.ailk.common.ui.components
{

	/**
	 * 类库版本文件
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
	public class Version
	{
		/**
		 * 版本号
		 *
		 * <p>历史版本回顾:</p>
		 *
		 * <ul>
		 * <li><b>1.0.0.120614</b>	初始化版本,增加自动调整宽高的树组件,同时支持分步加载接口</li>
		 * <li><b>1.0.0.120619</b>	增加日期、高级扩展表格（用于行合并，目前样式有点问题）、侧边导航、分页、面板组件</li>
		 * <li><b>1.0.0.120620</b>	增加动态下拉框组件</li>
		 * </ul>
		 */
		public static const VERSION:String = "1.0.0.120620";

		/**
		 * UI组件库 版本信息
		 * @return
		 *
		 */
		public static function get info():String
		{
			return "[ailk-ui-components Version] " + VERSION;
		}
	}
}