package com.ailk.common.ui.components.window.standardwindow
{
	import com.ailk.common.ui.components.window.standardwindow.event.WindowEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.core.IVisualElementContainer;
	import mx.managers.CursorManager;
	
	import spark.components.Button;
	import spark.components.Panel;

	[IconFile("assets/window.png")]
	[Event(name="close", type="com.ailk.common.ui.components.window.standardwindow.event.WindowEvent")]
	[Event(name="maximize", type="com.ailk.common.ui.components.window.standardwindow.event.WindowEvent")]
	[Event(name="minimize", type="com.ailk.common.ui.components.window.standardwindow.event.WindowEvent")]
	[Event(name="restore", type="com.ailk.common.ui.components.window.standardwindow.event.WindowEvent")]
	[Event(name="focusstart", type="com.ailk.common.ui.components.window.standardwindow.event.WindowEvent")]
	[Event(name="focusend", type="com.ailk.common.ui.components.window.standardwindow.event.WindowEvent")]
	[Event(name="config", type="com.ailk.common.ui.components.window.standardwindow.event.WindowEvent")]
	
	/**
	 * 标准窗口面板，最大化、最小化、还原有基本实现，若不满足需求，可外部继续实现，关闭由外部实现
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-10-9 上午11:55:21
	 * @category com.ailk.common.ui.components.window.normalwindow
	 * @copyright 南京联创科技 网管开发部
	 */
	public class Window extends Panel
	{
		[Embed(source="assets/resizeCursorH.gif")]
		private static var DEFAULT_RESIZE_CURSOR_HORIZONTAL:Class;

		[Embed(source="assets/resizeCursorTLBR.gif")]
		private static var DEFAULT_RESIZE_CURSOR_TL_BR:Class;

		[Embed(source="assets/resizeCursorTRBL.gif")]
		private static var DEFAULT_RESIZE_CURSOR_TR_BL:Class;

		[Embed(source="assets/resizeCursorV.gif")]
		private static var DEFAULT_RESIZE_CURSOR_VERTICAL:Class;

		public function Window()
		{
			super();
			setStyle("cornerRadius", 6);
//			setStyle("skinClass", WindowSkin);
//			this.styleName="window";
			windowState=WindowState.NORMAL;
			this.mouseEnabled=true;
		}

		//改变窗口尺寸的按钮=========start==============
		[SkinPart(required="false")]
		public var bottomLeftResizeButton:Button;

		[SkinPart(required="false")]
		public var bottomResizeButton:Button;

		[SkinPart(required="false")]
		public var bottomRightResizeButton:Button;

		[SkinPart(required="false")]
		public var leftResizeButton:Button;

		[SkinPart(required="false")]
		public var rightResizeButton:Button;

		[SkinPart(required="false")]
		public var topLeftResizeButton:Button;

		[SkinPart(required="false")]
		public var topResizeButton:Button;

		[SkinPart(required="false")]
		public var topRightResizeButton:Button;
		//改变窗口尺寸的按钮=========end==============

		//控制窗口状态的按钮=========start==============
		
		[SkinPart(required="false")]
		public var titleIconDisplay:Image;
		
		[SkinPart(required="false")]
		public var minimizeButton:Button;

		[SkinPart(required="false")]
		public var restoreButton:Button;

		[SkinPart(required="false")]
		public var maximizeButton:Button;

		[SkinPart(required="false")]
		public var closeButton:Button;

		[SkinPart(required="false")]
		public var configButton:Button;
		//控制窗口状态的按钮=========end==============

		private var _hasFocus:Boolean;

		private var _windowState:int;

		private var currentResizeHandle:Button;

		private var dragAmountX:Number;

		private var dragAmountY:Number;

		private var dragMaxX:Number;

		private var dragMaxY:Number;

		private var dragStartMouseX:Number;

		private var dragStartMouseY:Number;

		private var normalHeight:Number;

		private var normalWidth:Number;

		private var normalX:Number;

		private var normalY:Number;

		private var savedWindowRect:Rectangle;

		private var _maximizable:Boolean=true;

		private var _minimizable:Boolean=true;

		private var _resizable:Boolean=false;

		private var _closable:Boolean=true;

		private var _dragable:Boolean=false;

		private var _configable:Boolean=false;

		private var _contentGroupHeight:Number=0;
		
		private var _minimizableLeft:Number=0;
		
		private var _minimizableBottom:Number=0;
		
		private var _minimizableRight:Number=0;
		
		private var _minimizableTop:Number=0;
		
		private var _minimizableX:Number=0;
		
		private var _minimizableY:Number=0;
		
		private var _titleIcon:Object;

		public function get configable():Boolean
		{
			return _configable;
		}

		public function set configable(value:Boolean):void
		{
			_configable=value;
		}

		public function get dragable():Boolean
		{
			return _dragable;
		}

		public function set dragable(value:Boolean):void
		{
			_dragable=value;
			if(titleDisplay){
				if(dragable){
					titleDisplay.addEventListener(MouseEvent.MOUSE_DOWN, dragStart);
					titleDisplay.addEventListener(MouseEvent.MOUSE_UP, dragStop);
				}else{
					titleDisplay.removeEventListener(MouseEvent.MOUSE_DOWN, dragStart);
					titleDisplay.removeEventListener(MouseEvent.MOUSE_UP, dragStop);
				}
			}
		}

		public function get closable():Boolean
		{
			return _closable;
		}

		public function set closable(value:Boolean):void
		{
			_closable=value;
		}

		public function get resizable():Boolean
		{
			return _resizable;
		}

		public function set resizable(value:Boolean):void
		{
			_resizable=value;
		}

		public function get minimizable():Boolean
		{
			return _minimizable;
		}

		public function set minimizable(value:Boolean):void
		{
			_minimizable=value;
		}

		public function get maximizable():Boolean
		{
			return _maximizable;
		}

		public function set maximizable(value:Boolean):void
		{
			_maximizable=value;
		}

		public function get hasFocus():Boolean
		{
			return _hasFocus;
		}

		public function set hasFocus(value:Boolean):void
		{
			if (_hasFocus == value)
			{
				return;
			}

			_hasFocus=value;
			focusHandle();
		}

		public function restoreWindow():void
		{
			restore();
		}
		
		private function focusHandle():void
		{
			if (hasFocus == true)
			{
				this.alpha=1;
				IVisualElementContainer(parent).setElementIndex(this, this.parent.numChildren - 1);
				dispatchEvent(new WindowEvent(WindowEvent.FOCUS_START,this));
			}
			else
			{
				this.alpha=0.6;
				dispatchEvent(new WindowEvent(WindowEvent.FOCUS_END,this));
			}
		}

		/**
		 * 按住窗口标题开始移动时调用
		 */
		private function dragStart(event:MouseEvent):void
		{
			if (windowState != WindowState.MAXIMIZED)
			{
				this.startDrag(false, new Rectangle(0, 0, parent.width - this.width, parent.height - this.height));
			}
			systemManager.addEventListener(MouseEvent.MOUSE_UP, dragStop);
			systemManager.stage.addEventListener(Event.MOUSE_LEAVE, dragStop);
		}

		/**
		 * 按住窗口标题停止移动时调用
		 */
		private function dragStop(event:Event):void
		{
			this.stopDrag();
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, dragStop);
			systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, dragStop);
		}

		/**
		 * 派发最小化事件
		 */
		private function minimize(event:MouseEvent):void
		{
			if(windowState != WindowState.MINIMIZED){
				if(windowState == WindowState.NORMAL)
				{
					normalX=this.x;
					normalY=this.y;
					normalHeight=this.height;
					normalWidth=this.width;
				}
				if(this.minimizableX>0){
					this.x = this.minimizableX;
				}
				if(this.minimizableY>0){
					this.y = this.minimizableY;
				}
				if(this.minimizableBottom>0){
					this.bottom = this.minimizableBottom;
				}
				if(this.minimizableLeft>0){
					this.left = this.minimizableLeft;	
				}
				if(this.minimizableRight>0){
					this.right = this.minimizableRight;
				}
				if(this.minimizableTop>0){
					this.top = this.minimizableTop;
				}
				if(this.minWidth>0){
					this.width=this.minWidth;
				}
				this.height = this.minHeight;
				this.contentGroup.visible=false;
				this.contentGroup.includeInLayout=false;
				
				minimizeButton.visible=false;
				minimizeButton.enabled=false;
				minimizeButton.includeInLayout=false;
				restoreButton.visible=true;
				restoreButton.enabled=true;
				restoreButton.includeInLayout=true;
				if(this.maximizable){
					maximizeButton.visible=true;
					maximizeButton.enabled=true;
					maximizeButton.includeInLayout=true;
				}
				windowState = WindowState.MINIMIZED;
				dispatchEvent(new WindowEvent(WindowEvent.MINIMIZE,this));
			}
		}
		/**
		 * 窗口还原时调用
		 */
		private function restore(event:MouseEvent=null):void
		{
			if (windowState != WindowState.NORMAL)
			{
				this.x=this.normalX;
				this.y=this.normalY;
				this.width=this.normalWidth;
				this.height=this.normalHeight;
				if(this.minimizableLeft>0){
					this.clearStyle("left");
				}
				if(this.minimizableRight>0){
					this.clearStyle("right");
				}
				if(this.minimizableBottom>0){
					this.clearStyle("bottom");
				}
				if(this.minimizableTop>0){
					this.clearStyle("top");
				}
				
				restoreButton.visible=false;
				restoreButton.enabled=false;
				restoreButton.includeInLayout=false;
				this.contentGroup.visible=true;
				this.contentGroup.includeInLayout=true;
				if(windowState == WindowState.MAXIMIZED){
					maximizeButton.visible=true;
					maximizeButton.enabled=true;
					maximizeButton.includeInLayout=true;
				}
				if(windowState == WindowState.MINIMIZED){
					minimizeButton.visible=true;
					minimizeButton.enabled=true;
					minimizeButton.includeInLayout=true;
				}
				windowState=WindowState.NORMAL;
				dispatchEvent(new WindowEvent(WindowEvent.RESTORE,this));
			}
		}

		/**
		 * 窗口最大化时调用
		 */
		private function maximize(event:MouseEvent=null):void
		{
			if (windowState != WindowState.MAXIMIZED)
			{
				if(windowState == WindowState.NORMAL)
				{
					normalX=this.x;
					normalY=this.y;
					normalHeight=this.height;
					normalWidth=this.width;
				}
				this.x=0;
				this.y=0;
				this.percentHeight=100;
				this.percentWidth=100;
				this.contentGroup.visible=true;
				this.contentGroup.includeInLayout=true;
				windowState=WindowState.MAXIMIZED;
				maximizeButton.visible=false;
				maximizeButton.enabled=false;
				maximizeButton.includeInLayout=false;
				restoreButton.visible=true;
				restoreButton.enabled=true;
				restoreButton.includeInLayout=true;
				if(this.minimizable){
					minimizeButton.visible=true;
					minimizeButton.enabled=true;
					minimizeButton.includeInLayout=true;
				}
				dispatchEvent(new WindowEvent(WindowEvent.MAXIMIZE,this));
			}
		}

		/**
		 *派发配置事件
		 * @param event
		 *
		 */
		private function config(event:MouseEvent):void
		{
			dispatchEvent(new WindowEvent(WindowEvent.CONFIG,this));
		}

		/**
		 * 派发关闭事件
		 */
		private function close(event:MouseEvent):void
		{
			dispatchEvent(new WindowEvent(WindowEvent.CLOSE,this));
		}

		/**
		 * 在窗口标题双击时调用
		 */
		private function titleDoubleClick(event:MouseEvent):void
		{
			if (windowState != WindowState.MAXIMIZED)
			{
				maximize();
			}
			else
			{
				restore();
			}
		}

		/**
		 * 窗口尺寸改变时调用
		 */
		private function resize(event:Event):void
		{
			dragAmountX=parent.mouseX - dragStartMouseX;
			dragAmountY=parent.mouseY - dragStartMouseY;
			if (currentResizeHandle == topResizeButton && parent.mouseY > 0)
			{
				this.y=Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
				this.height=Math.max(savedWindowRect.height - dragAmountY, this.skin.minHeight);

			}
			else if (currentResizeHandle == rightResizeButton)
			{
				this.width=Math.max(savedWindowRect.width + dragAmountX, this.skin.minWidth);
			}
			else if (currentResizeHandle == bottomResizeButton && parent.mouseY < parent.height)
			{
				this.height=Math.max(savedWindowRect.height + dragAmountY, this.skin.minHeight);
			}
			else if (currentResizeHandle == leftResizeButton && parent.mouseX > 0)
			{
				this.x=Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
				this.width=Math.max(savedWindowRect.width - dragAmountX, this.skin.minWidth);
			}
			else if (currentResizeHandle == topLeftResizeButton && parent.mouseX > 0 && parent.mouseY > 0)
			{
				this.x=Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
				this.y=Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
				this.width=Math.max(savedWindowRect.width - dragAmountX, this.skin.minWidth);
				this.height=Math.max(savedWindowRect.height - dragAmountY, this.skin.minHeight);
			}
			else if (currentResizeHandle == topRightResizeButton && parent.mouseX < parent.width && parent.mouseY > 0)
			{
				this.y=Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
				this.width=Math.max(savedWindowRect.width + dragAmountX, this.skin.minWidth);
				this.height=Math.max(savedWindowRect.height - dragAmountY, this.skin.minHeight);
			}
			else if (currentResizeHandle == bottomRightResizeButton && parent.mouseX < parent.width && parent.mouseY < parent.height)
			{
				this.width=Math.max(savedWindowRect.width + dragAmountX, this.skin.minWidth);
				this.height=Math.max(savedWindowRect.height + dragAmountY, this.skin.minHeight);
			}
			else if (currentResizeHandle == bottomLeftResizeButton && parent.mouseX > 0 && parent.mouseY < parent.height)
			{
				this.x=Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
				this.width=Math.max(savedWindowRect.width - dragAmountX, this.skin.minWidth);
				this.height=Math.max(savedWindowRect.height + dragAmountY, this.skin.minHeight);
			}
		}

		/**
		 * 在窗口边缘并按下鼠标左键时调用
		 */
		private function resizeButtonDown(event:MouseEvent):void
		{
			if (windowState == WindowState.NORMAL)
			{
				currentResizeHandle=event.target as Button;
				setCursor(currentResizeHandle);
				dragStartMouseX=parent.mouseX;
				dragStartMouseY=parent.mouseY;
				savedWindowRect=new Rectangle(this.x, this.y, this.width, this.height);
				dragMaxX=savedWindowRect.x + (savedWindowRect.width - this.skin.minWidth);
				dragMaxY=savedWindowRect.y + (savedWindowRect.height - this.skin.minHeight);
				systemManager.addEventListener(Event.ENTER_FRAME, resize);
				systemManager.addEventListener(MouseEvent.MOUSE_UP, resizeButtonRelease);
				systemManager.stage.addEventListener(Event.MOUSE_LEAVE, resizeButtonRelease);
			}
		}

		/**
		 * 在窗口边缘并弹开鼠标左键时调用
		 */
		private function resizeButtonRelease(event:MouseEvent):void
		{
			currentResizeHandle=null;
			systemManager.removeEventListener(Event.ENTER_FRAME, resize);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, resizeButtonRelease);
			systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, resizeButtonRelease);
			CursorManager.removeAllCursors();
		}

		/**
		 * 在窗口边缘并鼠标离开时调用
		 */
		private function resizeButtonRollOut(event:MouseEvent):void
		{
			if (!event.buttonDown)
				CursorManager.removeAllCursors();
		}

		/**
		 * 在窗口边缘并鼠标进入时调用
		 */
		private function resizeButtonRollOver(event:MouseEvent):void
		{
			if (windowState == WindowState.NORMAL)
			{
				if (!event.buttonDown)
				{
					setCursor(event.target as Button);
				}
			}
		}

		/**
		 * 鼠标经过窗口边缘时设置鼠标显示形状
		 */
		private function setCursor(target:Button):void
		{
			switch (target)
			{
				case topResizeButton:
				case bottomResizeButton:
					CursorManager.setCursor(DEFAULT_RESIZE_CURSOR_VERTICAL, 2, -10, -10);
					break;
				case rightResizeButton:
				case leftResizeButton:
					CursorManager.setCursor(DEFAULT_RESIZE_CURSOR_HORIZONTAL, 2, -10, -10);
					break;
				case topLeftResizeButton:
				case bottomRightResizeButton:
					CursorManager.setCursor(DEFAULT_RESIZE_CURSOR_TL_BR, 2, -10, -10);
					break;
				case topRightResizeButton:
				case bottomLeftResizeButton:
					CursorManager.setCursor(DEFAULT_RESIZE_CURSOR_TR_BL, 2, -10, -10);
					break;
			}
		}

		/**
		 * 窗口初始化时调用该函数加载皮肤
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == titleIconDisplay){
				if(titleIcon){
					titleIconDisplay.source=titleIcon;
					titleIconDisplay.visible=titleIconDisplay.includeInLayout=true;
				}else{
					titleIconDisplay.visible=titleIconDisplay.includeInLayout=false;
				}
			}
			if (instance == titleDisplay)
			{
				if (dragable)
				{
					titleDisplay.addEventListener(MouseEvent.MOUSE_DOWN, dragStart);
					titleDisplay.addEventListener(MouseEvent.MOUSE_UP, dragStop);
				}
				if (maximizable)
				{
					titleDisplay.addEventListener(MouseEvent.DOUBLE_CLICK, titleDoubleClick);
				}
			}
			if (instance == configButton)
			{
				if (configable)
				{
					configButton.addEventListener(MouseEvent.CLICK, config);
				}
				else
				{
					configButton.visible=false;
					configButton.enabled=false;
					configButton.includeInLayout=false;
				}
			}
			if (instance == closeButton)
			{
				if (closable)
				{
					closeButton.addEventListener(MouseEvent.CLICK, close);
				}
				else
				{
					closeButton.visible=false;
					closeButton.enabled=false;
					closeButton.includeInLayout=false;
				}
			}
			if (instance == maximizeButton)
			{
				if (maximizable)
				{
					maximizeButton.addEventListener(MouseEvent.CLICK, maximize);
				}
				else
				{
					maximizeButton.visible=false;
					maximizeButton.enabled=false;
					maximizeButton.includeInLayout=false;
				}
			}
			if (instance == restoreButton)
			{
				restoreButton.visible=false;
				restoreButton.enabled=false;
				restoreButton.includeInLayout=false;
				restoreButton.addEventListener(MouseEvent.CLICK, restore);
			}
			if (instance == minimizeButton)
			{
				if (minimizable)
				{
					minimizeButton.addEventListener(MouseEvent.CLICK, minimize);
				}
				else
				{
					minimizeButton.visible=false;
					minimizeButton.enabled=false;
					minimizeButton.includeInLayout=false;
				}
			}
			if (instance == topResizeButton)
			{
				if (resizable)
				{
					topResizeButton.addEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver);
					topResizeButton.addEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown);
					topResizeButton.addEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut);
				}
				else
				{
					topResizeButton.visible=false;
					topResizeButton.enabled=false;

				}
			}
			if (instance == bottomResizeButton)
			{
				if (resizable)
				{
					bottomResizeButton.addEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver)
					bottomResizeButton.addEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown)
					bottomResizeButton.addEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut)
				}
				else
				{
					bottomResizeButton.visible=false;
					bottomResizeButton.enabled=false;
				}
			}
			if (instance == leftResizeButton)
			{
				if (resizable)
				{
					leftResizeButton.addEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver);
					leftResizeButton.addEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown);
					leftResizeButton.addEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut);
				}
				else
				{
					leftResizeButton.visible=false;
					leftResizeButton.enabled=false;
				}
			}
			if (instance == rightResizeButton)
			{
				if (resizable)
				{
					rightResizeButton.addEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver)
					rightResizeButton.addEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown)
					rightResizeButton.addEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut)
				}
				else
				{
					rightResizeButton.visible=false;
					rightResizeButton.enabled=false;
				}
			}
			if (instance == topLeftResizeButton)
			{
				if (resizable)
				{
					topLeftResizeButton.addEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver)
					topLeftResizeButton.addEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown)
					topLeftResizeButton.addEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut)
				}
				else
				{
					topLeftResizeButton.visible=false;
					topLeftResizeButton.enabled=false;
				}
			}
			if (instance == topRightResizeButton)
			{
				if (resizable)
				{
					topRightResizeButton.addEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver);
					topRightResizeButton.addEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown);
					topRightResizeButton.addEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut);
				}
				else
				{
					topRightResizeButton.visible=false;
					topRightResizeButton.enabled=false;
				}
			}
			if (instance == bottomLeftResizeButton)
			{
				if (resizable)
				{
					bottomLeftResizeButton.addEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver);
					bottomLeftResizeButton.addEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown);
					bottomLeftResizeButton.addEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut);
				}
				else
				{
					bottomLeftResizeButton.visible=false;
					bottomLeftResizeButton.enabled=false;
				}
			}
			if (instance == bottomRightResizeButton)
			{
				if (resizable)
				{
					bottomRightResizeButton.addEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver);
					bottomRightResizeButton.addEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown);
					bottomRightResizeButton.addEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut);
				}
				else
				{
					bottomRightResizeButton.visible=false;
					bottomRightResizeButton.enabled=false;
				}
			}
		}

		/**
		 * 窗口销毁时调用该函数卸载皮肤
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if (instance == titleDisplay)
			{
				titleDisplay.removeEventListener(MouseEvent.MOUSE_DOWN, dragStart);
				titleDisplay.removeEventListener(MouseEvent.MOUSE_UP, dragStop);
				titleDisplay.removeEventListener(MouseEvent.DOUBLE_CLICK, titleDoubleClick)
			}
			if (instance == closeButton)
			{
				closeButton.removeEventListener(MouseEvent.CLICK, close);
			}
			if (instance == restoreButton)
			{
				restoreButton.removeEventListener(MouseEvent.CLICK, maximize);
			}
			if (instance == maximizeButton)
			{
				maximizeButton.removeEventListener(MouseEvent.CLICK, titleDoubleClick);
			}
			if (instance == minimizeButton)
			{
				minimizeButton.removeEventListener(MouseEvent.CLICK, minimize);
			}
			if (instance == topResizeButton)
			{
				topResizeButton.removeEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver)
				topResizeButton.removeEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown)
				topResizeButton.removeEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut)
			}
			if (instance == bottomResizeButton)
			{
				bottomResizeButton.removeEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver)
				bottomResizeButton.removeEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown)
				bottomResizeButton.removeEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut)
			}
			if (instance == leftResizeButton)
			{
				leftResizeButton.removeEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver)
				leftResizeButton.removeEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown)
				leftResizeButton.removeEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut)
			}
			if (instance == rightResizeButton)
			{
				rightResizeButton.removeEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver)
				rightResizeButton.removeEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown)
				rightResizeButton.removeEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut)
			}
			if (instance == topLeftResizeButton)
			{
				topLeftResizeButton.removeEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver)
				topLeftResizeButton.removeEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown)
				topLeftResizeButton.removeEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut)
			}
			if (instance == topRightResizeButton)
			{
				topRightResizeButton.removeEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver)
				topRightResizeButton.removeEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown)
				topRightResizeButton.removeEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut)
			}
			if (instance == bottomLeftResizeButton)
			{
				bottomLeftResizeButton.removeEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver)
				bottomLeftResizeButton.removeEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown)
				bottomLeftResizeButton.removeEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut)
			}
			if (instance == bottomRightResizeButton)
			{
				bottomRightResizeButton.removeEventListener(MouseEvent.ROLL_OVER, resizeButtonRollOver)
				bottomRightResizeButton.removeEventListener(MouseEvent.MOUSE_DOWN, resizeButtonDown)
				bottomRightResizeButton.removeEventListener(MouseEvent.ROLL_OUT, resizeButtonRollOut)
			}
		}

		private function get windowState():int
		{
			return _windowState;
		}

		private function set windowState(windowState:int):void
		{
			_windowState=windowState;
		}

		public function get minimizableY():Number
		{
			return _minimizableY;
		}

		public function set minimizableY(value:Number):void
		{
			_minimizableY = value;
		}

		public function get minimizableX():Number
		{
			return _minimizableX;
		}

		public function set minimizableX(value:Number):void
		{
			_minimizableX = value;
		}

		public function get minimizableTop():Number
		{
			return _minimizableTop;
		}

		public function set minimizableTop(value:Number):void
		{
			_minimizableTop = value;
		}

		public function get minimizableRight():Number
		{
			return _minimizableRight;
		}

		public function set minimizableRight(value:Number):void
		{
			_minimizableRight = value;
		}

		public function get minimizableBottom():Number
		{
			return _minimizableBottom;
		}

		public function set minimizableBottom(value:Number):void
		{
			_minimizableBottom = value;
		}

		public function get minimizableLeft():Number
		{
			return _minimizableLeft;
		}

		public function set minimizableLeft(value:Number):void
		{
			_minimizableLeft = value;
		}

		public function get titleIcon():Object
		{
			return _titleIcon;
		}

		public function set titleIcon(value:Object):void
		{
			_titleIcon = value;
		}


	}
}