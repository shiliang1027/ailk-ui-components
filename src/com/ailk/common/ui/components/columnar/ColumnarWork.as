package com.ailk.common.ui.components.columnar
{
	import com.ailk.common.ui.components.dummymap.MapLabel;
	import com.ailk.common.ui.components.dummymap.MapNode;
	import com.ailk.common.ui.components.dummymap.MapWork;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.effects.AnimateProperty;
	import mx.effects.Move;
	
	import spark.components.Group;

	public class ColumnarWork extends Group
	{
		//移动效果
		private var _move:Move = null;
		//动画持续时间
		private var _duration:int = 3000;
		//柱状图容器
		private var _columnarBox:ColumnarBox = null;
		//动画效果
		private var _animate:AnimateProperty = null;
		//柱状图显示容器
		private var _columnarGroup:Group = null;
		//柱状图配置信息
		private var _columnarConfig:ColumnarConfig = null;
		//柱状图地区ID数组
		private var _areaIdArray:ArrayCollection;

		private var _mw:MapWork;
		public function ColumnarWork(mw:MapWork)
		{
			this._mw = mw;
			_move = new Move();
			this._mw.addElement(this);
			_columnarGroup = new Group();
			addElement(_columnarGroup);
			_columnarBox = new ColumnarBox();
			_animate = new AnimateProperty();
			initAnimatePropertyParam();
			_columnarConfig = new ColumnarConfig();
		}

		/**
		 *解析柱状图
		 *
		 */
		public function parseColumnar():void
		{
			var areaArray:Array = _columnarConfig.configArray;
			for(var nodeId:String in areaArray)
			{
				if(nodeId == "border"){
					continue;
				}
				var areaId:String = _mw.getAreaId(nodeId);
				var mapNode:MapNode = _mw.elementBox.getElementById(nodeId) as MapNode;
				//1.创建柱状图
				var columnarNode:ColumnarNode = new ColumnarNode();
				columnarNode.id = areaId;
				columnarNode.x = mapNode.x;
				columnarNode.y = mapNode.y;
				columnarNode.width = _columnarConfig.width;
				columnarNode.color = _columnarConfig.color;
				_columnarBox.add(columnarNode);
				//2.创建标签
				var columnarLabel:ColumnarLabel = new ColumnarLabel();
				columnarLabel.id = areaId + "_label";
				columnarLabel.x =  mapNode.x;
				columnarLabel.y = mapNode.y;
				_columnarBox.add(columnarLabel);
			}
		}

		/**
		 *画柱状图
		 * @param dataArray 数据数组
		 * @param max 整数为:数据中最大值，小数为:1
		 * @param expandMultiple 扩大倍数
		 * @param isPercent 是否百分数
		 *
		 */
		public function drawColumnarImages(dataArray:Array, max:Number, expandMultiple:Number, isPercent:Boolean):void
		{
			_areaIdArray = new ArrayCollection();
			for (var areaId:String in dataArray)
			{
				var coluHeight:Number = ColumnarUtil.countHeight(dataArray[areaId], max, _columnarConfig.height);
				var columnarNode:ColumnarNode = _columnarBox.getElementById(areaId) as ColumnarNode;
				var mapLabel:MapLabel = _mw.elementBox.getElementById(areaId+"_label") as MapLabel;
				columnarNode.toolTip=mapLabel.text+","+dataArray[areaId];
				columnarNode.height = coluHeight;
				columnarNode.drawDefaultColumnar();
				//columnarNode.drawColumnar();
				var columnarLabel:ColumnarLabel = _columnarBox.getElementById(areaId + "_label") as ColumnarLabel;
				columnarLabel.expandMultiple = expandMultiple;
				columnarLabel.showValue = dataArray[areaId];
				columnarLabel.remoteNum = coluHeight;
				columnarLabel.isPercent = isPercent;
				_areaIdArray.addItem(areaId);
			}
		}

		/**
		 *是否显示
		 * @param flag true：显示 false：不显示
		 *
		 */
		public function showHide(flag:Boolean):void
		{
			_columnarGroup.removeAllElements();
			if (flag)
			{
				var areaId:String = null;
				//1.增加柱状图
				for each (areaId in _areaIdArray)
				{
					var columnarNode:ColumnarNode = _columnarBox.getElementById(areaId) as ColumnarNode;
					_columnarGroup.addElement(columnarNode);
					_animate.play([columnarNode]);
				}
				//2.增加标签
				for each (areaId in _areaIdArray)
				{
					var columnarLabel:ColumnarLabel = _columnarBox.getElementById(areaId + "_label") as ColumnarLabel;
//					_columnarGroup.addElement(columnarLabel);
					columnarLabel.showValueChange(_duration);
					initMoveParam(columnarLabel.remoteNum, columnarLabel.coordY);
					_move.play([columnarLabel]);
				}
				
			}
		}

		/**
		 *初始化动画效果
		 *
		 */
		private function initAnimatePropertyParam():void
		{
			_animate.property = "scaleY";
			_animate.fromValue = 0;
			_animate.toValue = 1;
			_animate.duration = _duration;
		}

		/**
		 *初始化动画效果
		 * @param remote 偏移量
		 * @param coordY Y轴原始坐标
		 *
		 */
		private function initMoveParam(remote:Number, coordY:Number):void
		{
			_move.yBy = -remote;
			_move.yFrom = coordY;
			_move.duration = _duration;
		}

		public function get columnarBox():ColumnarBox
		{
			return _columnarBox;
		}

		public function set columnarBox(value:ColumnarBox):void
		{
			_columnarBox = value;
		}

		public function get columnarConfig():ColumnarConfig
		{
			return _columnarConfig;
		}

		public function set columnarConfig(value:ColumnarConfig):void
		{
			_columnarConfig = value;
		}
	}
}