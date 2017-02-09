package com.ailk.common.ui.components.mask
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import mx.core.UIComponent;

	import spark.components.SkinnableContainer;

	/**
	 *
	 *
	 * @author shiliang (66614)
	 * @version 1.0
	 * @date 2013-1-7
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class SimpleMask extends SkinnableContainer
	{

		private var _unMaskObj:DisplayObject;
		private var isUnMaskObjChange:Boolean=false;
		private var _mask:UIComponent=new UIComponent();
		private var _x:Number=0;
		private var _y:Number=0;
		private var _w:Number=0;
		private var _h:Number=0;

		public function SimpleMask(unMaskObj:DisplayObject=null)
		{
			super();
			this.percentWidth=100;
			this.percentHeight=100;
			setStyle("backgroundAlpha", 0.5);
			this.unMaskObj=unMaskObj;
		}

		private function isInnerView(view:DisplayObject):Boolean
		{
			var rect:Rectangle=systemManager.screen;
			var point:Point=view.parent.localToGlobal(new Point(view.x, view.y));
			if (point.x + view.width < rect.x)
			{
				return false;
			}
			if (point.x > rect.width)
			{
				return false;
			}
			if (point.y + view.height < rect.y)
			{
				return false;
			}
			if (point.y > rect.height)
			{
				return false;
			}
			return true;
		}

		override protected function createChildren():void
		{
			super.createChildren();
			if (!getStyle("backgroundAlpha"))
			{
				setStyle("backgroundAlpha", 0.5);
			}
			if (!getStyle("backgroundColor"))
			{
				setStyle("backgroundColor", 0x000000);
			}
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var rect:Rectangle=systemManager.screen;
			if (unMaskObj && unMaskObj.visible && isInnerView(unMaskObj))
			{
				var point:Point=unMaskObj.parent.localToGlobal(new Point(unMaskObj.x, unMaskObj.y));
				_x=point.x;
				_y=point.y;
				_w=unMaskObj.width;
				_h=unMaskObj.height;
			}
			else
			{
				_x=0;
				_y=0;
				_w=0;
				_h=0;
			}
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xFF0000);
			_mask.graphics.drawRect(0, 0, _x, _y);
			_mask.graphics.drawRect(_x, 0, _w, _y);
			_mask.graphics.drawRect(_x + _w, 0, rect.width - _x - _w, _y);
			_mask.graphics.drawRect(_x + _w, _y, rect.width - _x - _w, _h);
			_mask.graphics.drawRect(_x + _w, _y + _h, rect.width - _x - _w, rect.height - _y - _h);

			_mask.graphics.drawRect(_x, _y + _h, _w, rect.height - _y - _h);
			_mask.graphics.drawRect(0, _y + _h, _x, rect.height - _y - _h);
			_mask.graphics.drawRect(0, _y, _x, _h);
			_mask.graphics.endFill();
		}

		public function get unMaskObj():DisplayObject
		{
			return _unMaskObj;
		}

		public function set unMaskObj(value:DisplayObject):void
		{
			_unMaskObj=value;
			this.mask=null;
			this.mask=_mask;
			invalidateDisplayList();
		}
	}
}