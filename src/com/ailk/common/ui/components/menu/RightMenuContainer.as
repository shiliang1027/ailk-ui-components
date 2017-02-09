package com.ailk.common.ui.components.menu
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.system.structure.map.IMap;
	import com.ailk.common.system.structure.map.Map;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Menu;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.MenuEvent;

	/**
	 * 该as的描述信息
	 * @author shiliang(66614) Tel:18661205639
	 * @version 1.0
	 * @since 2014-9-10 下午3:58:06
	 * @category com.linkage.module.cms.utils
	 * @copyright 南京联创科技 网管开发部
	 */
	public class RightMenuContainer
	{
		
		private static var log:ILogger = Log.getLoggerByClass(RightMenuContainer);
		private static var instance:RightMenuContainer;
		private const RIGHT_CLICK:String = "rightClick";
		
		private var isRegist:Boolean=false;
		private var _displayObject:DisplayObjectContainer;
		private var _mouseEvent:MouseEvent;
		
		private var rightClickTarget:DisplayObject;//右键点击的对象
		private var menu:Menu;
		
		private var menuMap:IMap=new Map();
		public function RightMenuContainer(){
			
		}
		public static function getInstance():RightMenuContainer{
			if(!instance){
				instance = new RightMenuContainer();
			}
			return instance;
		}
		
		public function init(displayObject:DisplayObjectContainer):void{
			this._displayObject = displayObject;
		}
		
		public function addRightMenu(menuObj:UIComponent,rightClickCallBack:Function=null,_this:*=null):RightMenuContainer{
			regist();
			menuMap.put(menuObj,{"rightClickCallBack":rightClickCallBack,"_this":_this});
			menuObj.addEventListener(RIGHT_CLICK,rightClickHandler);
			log.warn("[右键菜单]{0}",menuMap);
			return instance;
		}
		private function regist() : Boolean
		{
			if (ExternalInterface.available && !isRegist)
			{
				log.warn("[注册右键事件]ExternalInterface.available:{0},ExternalInterface.objectID:{1}",ExternalInterface.available,ExternalInterface.objectID);
				isRegist=true;
				ExternalInterface.call(javascript, ExternalInterface.objectID);
				ExternalInterface.addCallback(RIGHT_CLICK, dispatchRightClickEvent);
				FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			}
			return true;
		}
		
		public function createMenuItems(menuObj:UIComponent,menuItemArray:Array,menuLabelField:String="lable",menuItemClickCallBack:Function=null):RightMenuContainer{
			var value:* = menuMap.get(menuObj);
			value["menuItemArray"]=menuItemArray;
			value["menuLabelField"]=menuLabelField;
			value["menuItemClickCallBack"]=menuItemClickCallBack;
			return instance;
		}
		
		private function dispatchRightClickEvent() : void
		{
			var event:ContextMenuEvent;
			if (rightClickTarget != null)
			{
				event = new ContextMenuEvent(RIGHT_CLICK, true, false, rightClickTarget as InteractiveObject, rightClickTarget as InteractiveObject);
				rightClickTarget.dispatchEvent(event);
			}
		}
		
		private function checkTarget(target1:*,target2:*):Boolean{
			if(!target1 || !target2){
				return false;
			}
			if(target1 == target2){
				return true;
			}
			return checkTarget(target1,target2.parent);
		}
		private function mouseOverHandler(event:MouseEvent) : void
		{
			rightClickTarget = InteractiveObject(event.target);
		}
		private function mouseMoveHandler(event:MouseEvent) : void
		{
			this._mouseEvent = event;
		}
		
		private function rightClickHandler(event:ContextMenuEvent):void
		{
			//确定对象
			log.warn("右键触发----{0}",rightClickTarget);
			var menuParam:*=null;
			menuMap.forEach(function(key:*,value:*):void{
				if(checkTarget(key,rightClickTarget)){
					menuParam = value;
				}
			});
			//隐藏原有菜单
			if(menu!=null)
			{
				menu.hide();
				menu.removeEventListener(MenuEvent.ITEM_CLICK,menuItemSelected);  
				menu=null;
			}
			if(menuParam["rightClickCallBack"]!=null && menuParam["rightClickCallBack"] is Function){
				menuParam["rightClickCallBack"].call(null,rightClickTarget,event);
			}
			menu = Menu.createMenu(this._displayObject, menuParam["menuItemArray"], true);
			
			menu.labelField=menuParam["menuLabelField"];  //右键菜单的名称 
			menu.variableRowHeight = true;
			menu.addEventListener(MenuEvent.ITEM_CLICK, menuItemSelected);  //右键菜单的事件
			
			menu.show(this._mouseEvent.stageX,this._mouseEvent.stageY);  //显示右键菜单
			var rectangle:Rectangle = new Rectangle(0, 0, this._displayObject.width, this._displayObject.height);
			var point:Point = new Point(this._mouseEvent.stageX,this._mouseEvent.stageY);
			point = getValidPoint(point,rectangle);
			log.warn("point:{0}",point);
			menu.hide();
			menu.show(point.x,point.y);
		}
		
		private function getValidPoint(point:Point,rectangle:Rectangle):Point{
			var menuRectangle:Rectangle = new Rectangle(point.x, point.y, menu.width, menu.height);
			if(rectangle.width>menu.width && rectangle.height>menu.height){
				if(!rectangle.containsRect(menuRectangle)){
					if(menuRectangle.right>rectangle.right){
						point.x-= menu.width;
					}
					if(menuRectangle.left<rectangle.left){
						point.x = 0;
					}
					if(menuRectangle.bottom>rectangle.bottom){
						point.y-=menu.height;
					}
					if(menuRectangle.top<rectangle.top){
						point.y=0;
					}
					return getValidPoint(point,rectangle);
				}else{
					return point;
				}
			}
			if(menuRectangle.right>rectangle.right){
				point.x-= menu.width;
			}
			if(menuRectangle.left<rectangle.left){
				point.x = 0;
			}
			if(menuRectangle.bottom>rectangle.bottom){
				point.y-=menu.height;
			}
			if(menuRectangle.top<rectangle.top){
				point.y=0;
			}
			return point;
		}
		private function menuItemSelected(event:MenuEvent):void
		{
			log.warn("右键菜单事件响应！！");
			var menuItem:Object = event.menu.selectedItem as Object;
			
			var menuParam:*=null;
			menuMap.forEach(function(key:*,value:*):void{
				if(checkTarget(key,rightClickTarget)){
					menuParam = value;
				}
			});
			
			var e:ContextMenuEvent = new ContextMenuEvent(ContextMenuEvent.MENU_ITEM_SELECT, true, false, rightClickTarget as InteractiveObject, rightClickTarget as InteractiveObject);
			if(menuParam["menuItemClickCallBack"]!=null && menuParam["menuItemClickCallBack"] is Function){
				menuParam["menuItemClickCallBack"].call(null,menuItem,e);
			}
			
		}
		
		
		private const javascript:XML = <script>
						<![CDATA[
							/**
							 * 
							 * Copyright 2007
							 * 
							 * Paulius Uza
							 * http://www.uza.lt
							 * 
							 * Dan Florio
							 * http://www.polygeek.com
							 * 
							 * Project website:
							 * http://code.google.com/p/custom-context-menu/
							 * 
							 * --
							 * RightClick for Flash Player. 
							 * Version 0.6.2
							 * 
							 */
							function(flashObjectId)
							{				
								var RightClick = {
									/**
									 *  Constructor
									 */ 
									init: function (flashObjectId) {
										this.FlashObjectID = flashObjectId;
										this.Cache = this.FlashObjectID;
										if(window.addEventListener){
											 window.addEventListener("mousedown", this.onGeckoMouse(), true);
										} else {
											document.getElementById(this.FlashObjectID).parentNode.onmouseup = function() { document.getElementById(RightClick.FlashObjectID).parentNode.releaseCapture(); }
											document.oncontextmenu = function(){ if(window.event.srcElement.id == RightClick.FlashObjectID) { return false; } else { RightClick.Cache = "nan"; }}
											document.getElementById(this.FlashObjectID).parentNode.onmousedown = RightClick.onIEMouse;
										}
									},
									/**
									 * GECKO / WEBKIT event overkill
									 * @param {Object} eventObject
									 */
									killEvents: function(eventObject) {
										if(eventObject) {
											if (eventObject.stopPropagation) eventObject.stopPropagation();
											if (eventObject.preventDefault) eventObject.preventDefault();
											if (eventObject.preventCapture) eventObject.preventCapture();
											if (eventObject.preventBubble) eventObject.preventBubble();
										}
									},
									/**
									 * GECKO / WEBKIT call right click
									 * @param {Object} ev
									 */
									onGeckoMouse: function(ev) {
										return function(ev) {
										if (ev.button != 0) {
											RightClick.killEvents(ev);
											if(ev.target.id == RightClick.FlashObjectID && RightClick.Cache == RightClick.FlashObjectID) {
												RightClick.call();
											}
											RightClick.Cache = ev.target.id;
										}
									  }
									},
									/**
									 * IE call right click
									 * @param {Object} ev
									 */
									onIEMouse: function() {
										if (event.button > 1) {
											if(window.event.srcElement.id == RightClick.FlashObjectID && RightClick.Cache == RightClick.FlashObjectID) {
												RightClick.call(); 
											}
											document.getElementById(RightClick.FlashObjectID).parentNode.setCapture();
											if(window.event.srcElement.id)
											RightClick.Cache = window.event.srcElement.id;
										}
									},
									/**
									 * Main call to Flash External Interface
									 */
									call: function() {
										document.getElementById(this.FlashObjectID).rightClick();
									}
								}
								
								RightClick.init(flashObjectId);
							}
						]]>
					</script>;
	}
}