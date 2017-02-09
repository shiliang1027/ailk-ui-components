package com.ailk.common.ui.components.dummymap
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.components.columnar.ColumnarWork;
	
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import spark.components.Group;

	/**
	 * 地图画布
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2010-11-24 下午06:38:18
	 * @category com.linkage.map.core
	 * @copyright 南京联创科技 网管开发部
	 */
	public class MapWork extends Group
	{
		private var logger:ILogger=Log.getLoggerByClass(MapWork);

		//元素容器
		private var _elementBox:ElementBox;
		//地图位置数据
		private var _xmlData:XML;
		//地图元素数组
		private var _mapObjArray:Array;
		//当前地图区域
		private var _mapNode:MapNode=null;

		private var _mapNodeEvent:MapNodeEvent;
		//柱状图容器
		private var _columnarWork:ColumnarWork = null;
		private var _columnarDataArray:Array = null;
		private var _colunmarMaxData:Number = 0;
		
		private var dx:Number=0;
		private var dy:Number=0;
		
//		public var configData:XML;
		
		public var vectorMapID:String="";
		public var configBaseUrl:String="";
		public function MapWork()
		{
			if (_elementBox == null)
			{
				_elementBox=new ElementBox(this);
			}
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			
//			var service:HTTPService = new HTTPService();
//			service.url = "xml/vectormap_config.xml";
//			service.method="POST";
//			service.resultFormat = "e4x";
//			service.addEventListener(ResultEvent.RESULT, resultHandler);
//			service.addEventListener(FaultEvent.FAULT, faultHandler);
//			service.send();
			
			var service:HTTPService = new HTTPService();
			service.url = "xml/map_config.xml";
			service.method="POST";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void{
				var result:XML=event.result as XML;
				if(result.hasOwnProperty("@def")){
					vectorMapID=String(result.@def);
					for each(var map:XML in result.map){
						if(map.@type == result.@def){
							configBaseUrl = String(map.@configBaseUrl);
						}
					}
				}
			});
			service.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{
				throw new IllegalOperationError("加载xml/map_config.xml异常");
			});
			service.send();
		}
		
//		private function resultHandler(event:ResultEvent):void
//		{
//			configData=event.result as XML;
//		}
//		
//		private function faultHandler(event:FaultEvent):void{
//			throw new IllegalOperationError("加载xml/vectormap_config.xml异常");
//		}
		
		private function mouseOver(areaId:String):void{
			var mapNodeA:MapNode=elementBox.getElementById(areaId + "_a") as MapNode;
			var mapNodeB:MapNode=elementBox.getElementById(areaId + "_b") as MapNode;
			var mapLabel:MapLabel=elementBox.getElementById(areaId + "_label") as MapLabel;
			if(mapNodeA){
				mapNodeA.mouseOver();
				_mapNodeEvent=new MapNodeEvent(MapNodeEvent.MAPNODE_MOUSEOVER);
				_mapNodeEvent.mapNode=mapNodeA;
				this.dispatchEvent(_mapNodeEvent);
			}
			if(mapNodeB){
				mapNodeB.mouseOver();
			}
			if(mapLabel){
				mapLabel.mouseOver();
			}
			
		}
		
		
		private function mouseOut(areaId:String):void{
			var mapNodeAM:MapNode=elementBox.getElementById(areaId + "_a") as MapNode;
			var mapNodeBM:MapNode=elementBox.getElementById(areaId + "_b") as MapNode;
			var mapLabelM:MapLabel=elementBox.getElementById(areaId + "_label") as MapLabel;
			if(mapNodeAM){
				mapNodeAM.mouseOut();
				_mapNodeEvent=new MapNodeEvent(MapNodeEvent.MAPNODE_MOUSEOUT);
				_mapNodeEvent.mapNode=mapNodeAM;
				this.dispatchEvent(_mapNodeEvent);
			}
			if(mapNodeBM){
				mapNodeBM.mouseOut();
			}
			if(mapLabelM){
				mapLabelM.mouseOut();
			}
		}

		private function onMouseMove(event:MouseEvent):void
		{
			var areaId:String=null;
			var mapNode:MapNode=findTargetMapNode(event.target);
			var mapNodeA:MapNode;
			
			if (mapNode)
			{
				areaId=getAreaId(mapNode.id);
				mapNodeA=elementBox.getElementById(areaId + "_a") as MapNode;
				if(!mapNodeA){
					return;
				}
				if(!_mapNode){
					mouseOver(areaId);
					_mapNode=mapNodeA;
				}else if (_mapNode && _mapNode.id != mapNodeA.id)
				{
					mouseOut(getAreaId(_mapNode.id));
					mouseOver(areaId);
					_mapNode=mapNodeA;
				}
				
				return;
			}
			else
			{
				//地图名字
				var mapLabell:MapLabel=findTargetMapLabel(event.target);
				if (mapLabell)
				{
					areaId=getAreaId(mapLabell.id);
					mapNodeA=elementBox.getElementById(areaId + "_a") as MapNode;
					if(!mapNodeA){
						return;
					}
					if(!_mapNode){
						mouseOver(areaId);
						_mapNode=mapNodeA;
					}else if (_mapNode && _mapNode.id != mapNodeA.id)
					{
						mouseOut(getAreaId(_mapNode.id));
						mouseOver(areaId);
						_mapNode=mapNodeA;
					}
					return;
				}
				if (_mapNode)
				{
					mouseOut(getAreaId(_mapNode.id));
					_mapNode=null;
				}
			}
		}

		private function onMouseClick(event:MouseEvent):void
		{
			var areaId:String=null;
			var mapNode:MapNode=findTargetMapNode(event.target);
			if (mapNode)
			{
				areaId=getAreaId(mapNode.id);
				var mapNodeA:MapNode=elementBox.getElementById(areaId + "_a") as MapNode;
				_mapNodeEvent=new MapNodeEvent(MapNodeEvent.MAPNODE_CLICK);
				_mapNodeEvent.mapNode=mapNodeA;
				this.dispatchEvent(_mapNodeEvent);
			}
			else
			{
				//地图名字
				var mapLabell:MapLabel=findTargetMapLabel(event.target);
				if (mapLabell)
				{
					areaId=getAreaId(mapLabell.id);
					var mapNodeAA:MapNode=elementBox.getElementById(areaId + "_a") as MapNode;
					_mapNodeEvent=new MapNodeEvent(MapNodeEvent.MAPNODE_CLICK);
					_mapNodeEvent.mapNode=mapNodeAA;
					this.dispatchEvent(_mapNodeEvent);
				}
			}
		}

		public function findTargetMapNode(target:Object):MapNode
		{
			if (target == null)
			{
				return null;
			}

			while (!(target is MapNode))
			{
				target=target.parent;

				if (target == null || target == target.parent)
				{
					return null;
				}
			}
			return target as MapNode;
		}

		/**
		 * 查找目标对象(或其父对象)是那一种元素对象,找不到返回空
		 * @param target
		 * @return
		 *
		 */
		public function findTargetMapLabel(target:Object):MapLabel
		{
			if (target == null)
			{
				return null;
			}

			while (!(target is MapLabel))
			{
				target=target.parent;

				if (target == null || target == target.parent)
				{
					return null;
				}
			}
			return target as MapLabel;
		}

		public function get mapObjArray():Array
		{
			return _mapObjArray;
		}

		public function set mapObjArray(value:Array):void
		{
			_mapObjArray=value;
		}

		public function get xmlData():XML
		{
			return _xmlData;
		}

		public function set xmlData(value:XML):void
		{
			_xmlData=value;
//			dx = Number(_xmlData.map[0].@x)-Number(_xmlData.map[0].@w)/2-10;
//			dy = Number(_xmlData.map[0].@y)-Number(_xmlData.map[0].@h)/2-10;
//			for each(var map:XML in _xmlData.map){
//				dx = Math.min(dx,Number(map.@x)-Number(map.@w)/2-10);
//				dy = Math.min(dy,Number(map.@y)-Number(map.@h)/2-10);
//			}
			logger.debug("dx:{0},dy:{1}",dx,dy);
		}

		//显示地图
		public function showMap():void
		{
			this.clear();
			try
			{
				buildMap();
				buildLabel();
			}
			catch (e:Error)
			{
				Alert.show("构建地图出错!"+e.getStackTrace());
				logger.debug("构建地图出错!", e.getStackTrace());
			}
		}

		public function clear():void{
			this.removeAllElements();
			this._elementBox.clear();
		}
		//根据位置数据定位地图区域
		private function buildMap():void
		{
			for each (var map:XML in _xmlData.map)
			{
				var mapNode:MapNode=new MapNode();
				mapNode.label=map.@n;
				mapNode.id=map.@k;
				mapNode.x=map.@x-dx;
				mapNode.y=map.@y-dy;
				mapNode.width=map.@w;
				mapNode.height=map.@h;
				mapNode.centerPoint = new Point(Number(map.@x)-dx + Number(map.@xr),Number(map.@y)-dy + Number(map.@yr));
				if(map.@longitude){
					mapNode.longitude=Number(map.@longitude);
				}
				if(map.@latitude){
					mapNode.latitude=Number(map.@latitude);
				}
				mapNode.map=_mapObjArray[map.@k];
				mapNode.map.width=mapNode.width;
				mapNode.map.height=mapNode.height;
				mapNode.addChild(mapNode.map);
				_elementBox.add(mapNode);
			}
		}

		//根据位置数据定位地图名称
		private function buildLabel():void
		{
			for each (var map:XML in _xmlData.map)
			{
				if (map.@n != "")
				{
					var mapLabel:MapLabel=new MapLabel();
					mapLabel.id=getAreaId(map.@k) + "_label";
					mapLabel.text=map.@n;
					mapLabel.styleName="mapLabel";
					mapLabel.x=Number(map.@x)-dx + Number(map.@xr);
					mapLabel.y=Number(map.@y)-dy + Number(map.@yr);
					_elementBox.add(mapLabel);
				}
			}
		}

		//刷新地图画板(颜色还原)
		public function refleshMap():void
		{
			forEach(function(data:IData):void
				{
					if (data is MapNode)
					{
						(data as MapNode).reset();
					}
				});
		}

		//根据指标数据填充地图颜色
		public function fillMap(xml:XML):void
		{
			for each (var map:XML in xml.map)
			{
				var mapNode:MapNode=_elementBox.getElementById(map.@k + "_a") as MapNode;
				if (mapNode != null)
				{
					var color:String=map.@color;
					if (color == "0")
					{
						mapNode.reset();
					}
					else
					{
						mapNode.fillColor(Number(color));
					}
				}
			}
		}

		public function fillMapById(mapId:String, color:uint):void
		{
			var mapNodeA:MapNode=_elementBox.getElementById(mapId + "_a") as MapNode;
			var mapNodeB:MapNode=_elementBox.getElementById(mapId + "_b") as MapNode;
			if (mapNodeA)
			{
				mapNodeA.fillColor(color);
			}
			if(mapNodeB){
				mapNodeB.fillColor(color);
			}
		}
		
		public function showColunmar():void{
			if (_columnarDataArray != null)
			{
				_columnarWork = new ColumnarWork(this);
				this.addElement(_columnarWork);
				_columnarWork.columnarConfig.configArray = _mapObjArray;
				_columnarWork.parseColumnar();
				_columnarWork.drawColumnarImages(_columnarDataArray, _colunmarMaxData, 1, false);
				_columnarWork.showHide(true);
			}
		}

		public function forEach(callback:Function=null):void
		{
			for each (var data:IData in _elementBox.elements)
			{
				if (callback != null)
				{
					callback.call(null, data);
				}
			}
		}

		public function getAreaId(mapId:String):String
		{
			if (mapId == null || mapId.indexOf("_") == -1)
			{
				return null;
			}
			return mapId.split("_")[0];
		}

		public function get elementBox():ElementBox
		{
			return _elementBox;
		}

		public function set elementBox(value:ElementBox):void
		{
			_elementBox=value;
		}
		public function get columnarDataArray():Array
		{
			return this._columnarDataArray;
		}
		
		public function set columnarDataArray(value:Array):void
		{
			this._columnarDataArray = value;
		}
		
		public function get colunmarMaxData():Number
		{
			return this._colunmarMaxData;
		}
		
		public function set colunmarMaxData(value:Number):void
		{
			this._colunmarMaxData = value;
		}
	}
}