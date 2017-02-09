package com.ailk.common.ui.components.dummymap
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Transform;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;

	/**
	 * 地图区域节点
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2010-11-26 上午11:38:27
	 * @category com.linkage.module.ims.scene.outshow.core
	 * @copyright 南京联创科技 网管开发部
	 */
	public class MapNode extends UIComponent implements IData
	{
		private var _map:MovieClip;
		private var _isMove:Boolean = false;
		private var _defBgColor:Number = 0x0fffff;
		private var _defTransform:Transform;
		private var _centerPoint:Point;
		private var _longitude:Number;
		private var _latitude:Number;
		private var _label:String;

		private var _def:MovieClip = new MovieClip();
		public function MapNode()
		{
			super();
		}

		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
		}
		
		public function get latitude():Number
		{
			return _latitude;
		}

		public function set latitude(value:Number):void
		{
			_latitude = value;
		}

		public function get longitude():Number
		{
			return _longitude;
		}

		public function set longitude(value:Number):void
		{
			_longitude = value;
		}

		public function fillColor(color:Number):void
		{
			if (id.indexOf("_a") != -1)
			{
//				if(!_def.transform){
//					_def.transform = _map.transform;
//					_def.transform.colorTransform.color = _map.transform.colorTransform.color;
//				}
				var colorForm:ColorTransform = _map.transform.colorTransform;
				colorForm.color = color;
				_map.transform.colorTransform = colorForm;
			}
		}

		public function reset():void
		{
			if (id.indexOf("_a") != -1)
			{
				var colorForm:ColorTransform = _map.transform.colorTransform;
				colorForm.color = _defBgColor;
				_map.transform.colorTransform = colorForm;
//				if(_def.transform){
//					_map.transform = _def.transform;
//				}
				
			}
		}

		public function mouseOver():void
		{
			if (!_isMove)
			{
				if(id.indexOf("_b") == -1){
					return;
				}
//				this.y -= Const.MOUSEOVER_REMOTE_NUM;
				_isMove = true;
			}
		}

		public function mouseOut():void
		{
			if (_isMove)
			{
				if(id.indexOf("_b") == -1){
					return;
				}
//				this.y += Const.MOUSEOVER_REMOTE_NUM;
				_isMove = false;
			}
		}

		public function get map():MovieClip
		{
			return _map;
		}

		public function set map(value:MovieClip):void
		{
			_map = value;
		}
		
		public function get centerPoint():Point{
			return this._centerPoint;
		}
		
		public function set centerPoint(value:Point):void{
			this._centerPoint = value;
		}
	}
}