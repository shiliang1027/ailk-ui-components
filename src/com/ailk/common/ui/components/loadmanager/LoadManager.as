package com.ailk.common.ui.components.loadmanager
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;

	import spark.components.Group;
	import spark.components.Label;

	/**
	 *
	 *
	 * @author shiliang (66614)
	 * @version 1.0
	 * @date 2012-11-30
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class LoadManager extends UIComponent
	{
		private static var _loading:UIComponent=new UIComponent();
		private static var _prompt:Label=new Label();
		private static var _label:String="正在处理，请稍后";
		private static var _str:String="......";
		private static var i:uint=0;
		private static var _interval:uint=0;
		private var _loader:Loader=new Loader();
		private static const ASSETSFILE:String="";
		private static var loadManager:LoadManager;

		public function LoadManager(style:*=null)
		{
			_loading.minWidth=220;
			_loading.minHeight=80;
			if (style)
			{
				_loader.load(new URLRequest(ASSETSFILE + "loading1_" + style + ".swf"));
			}
			else
			{
				_loader.load(new URLRequest(ASSETSFILE + "loading1.swf"));
			}
			_loading.addChild(_loader);
		}

		public static function showLoading(label:String="", parent:*=null, modal:Boolean=false, style:*=null):void
		{
			if (!loadManager)
			{
				loadManager=new LoadManager(style);
			}
			if (label != null)
			{
				_label=label;
				_prompt.text=_label;
			}
			if (_loading != null)
			{
				if (!parent)
				{
					var sm:ISystemManager=ISystemManager(FlexGlobals.topLevelApplication.systemManager);
					// no types so no dependencies
					var mp:Object=sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
					if (mp && mp.useSWFBridge())
						parent=Sprite(sm.getSandboxRoot());
					else
						parent=Sprite(FlexGlobals.topLevelApplication);
				}

				// Setting a module factory allows the correct embedded font to be found.
				PopUpManager.addPopUp(_loading, parent, modal);
				PopUpManager.centerPopUp(_loading);
//				if (_interval == 0)
//				{
//					_interval=setInterval(onInterval, 100);
//				}
			}
		}

		public static function hideLoading():void
		{
			if (_loading != null)
			{
				PopUpManager.removePopUp(_loading);
//				if (_interval != 0)
//				{
//					clearInterval(_interval);
//					_interval=0;
//					i=0;
//				}
			}
		}

		private static function onInterval():void
		{
			_prompt.text=_label + _str.substring(0, _str.indexOf(".") + (i % 7));
			i++;
		}
	}
}