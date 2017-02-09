package com.ailk.common.ui.components.grid.advanceddatagrid.Util
{
	import com.ailk.common.ui.components.grid.advanceddatagrid.Renderer.Header.AdvancedDataGridHeaderRenderer;
	import com.ailk.common.ui.components.grid.advanceddatagrid.Renderer.Item.AdvancedDataGridItemRenderer;
	
	import mx.core.IFactory;
	
	public class ItemRendererIFactory implements mx.core.IFactory
	{
		public var classname:String="";
		
		public function newInstance():*{
			var ret:Object;
			
			switch(classname.toLowerCase()){
				case "defaultheader":
					ret=new AdvancedDataGridHeaderRenderer();
				case "defaultitem":
				default:
					ret=new AdvancedDataGridItemRenderer();
				break;
			}
			
			return ret;
		} 
	}
}