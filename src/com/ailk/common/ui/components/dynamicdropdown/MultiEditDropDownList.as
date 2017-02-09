package com.ailk.common.ui.components.dynamicdropdown
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.components.dynamicdropdown.renderer.MultiEditDropDownItemRenderer;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	import mx.core.UIComponentGlobals;
	import mx.core.mx_internal;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.utils.StringUtil;

	import spark.components.DropDownList;
	import spark.components.TextInput;
	import spark.events.DropDownEvent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	import spark.utils.LabelUtil;

	use namespace mx_internal;

	[IconFile("assets/combobox.png")]
	[Event(name="textInputChange", type="flash.events.Event")]

	/**
	 *
	 *
	 * @author shiliang (66614)
	 * @version 1.0
	 * @date 2012-11-15
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class MultiEditDropDownList extends DropDownList
	{
		private static var log:ILogger=Log.getLoggerByClass(MultiEditDropDownList);
		[SkinPart(required="false")]
		public var textDisplay:TextInput;
		[SkinPart(required="false")]
		public var focusDisplay:TextInput;

		public var editable:Boolean=false;
		public var allowMultipleSelecte:Boolean=false;

		private var sizeSetByTypicalItem:Boolean;
		private var textDisplayExplicitWidth:Number;
		private var textDisplayExplicitHeight:Number;

		private var selectTimer:Timer=new Timer(1000);

		private var _selectedItemArray:ArrayCollection=new ArrayCollection();
		private var _textInputPrompt:String;

		private var isTextChanged:Boolean=false;

		public function MultiEditDropDownList()
		{
			selectTimer.addEventListener(TimerEvent.TIMER, onSelectTimerHandler);
			this.addEventListener(DropDownEvent.OPEN, onDropDownOpenHandler);
			this.addEventListener(DropDownEvent.CLOSE, onDropDownCloseHandler);
			selectedItemArray.addEventListener(CollectionEvent.COLLECTION_CHANGE, onSelectedArrayChange);
		}

		private function onSelectedArrayChange(event:CollectionEvent):void
		{
//			if (allowMultipleSelecte)
//			{
			log.error("[onSelectedArrayChange]{0}", isTextChanged);
//				if(!isTextChanged){
//					resetPrompt();
//				}else{
//					isTextChanged=false;
//				}
//			if(!isTextChanged){
				resetPrompt();
//			}
//			if(!allowMultipleSelecte && selectedItemArray.length>0){
//				selectedItem = selectedItemArray.getItemAt(0);
//			}
//			}
		}

		private function onSelectTimerHandler(event:TimerEvent):void
		{
			if (selectTimer.running)
			{
				selectTimer.stop();
			}
			dispatchEvent(new Event("textInputChange"));
			openDropDown();
			focusManager.setFocus(focusDisplay);
		}

		private function onDropDownOpenHandler(event:DropDownEvent):void
		{
//			isTextChanged=false;
		}

		private function onDropDownCloseHandler(event:DropDownEvent):void
		{
			selectedItemArray.removeAll();
			if (allowMultipleSelecte)
			{
				for each (var item:* in dataProvider)
				{
					if (item.selected)
					{
						selectedItemArray.addItem(item);
					}
				}
//				var e:IndexChangeEvent=new IndexChangeEvent(IndexChangeEvent.CHANGE);
//				dispatchEvent(e);
//				if (selectedItemArray.length > 0)
//				{
//					resetPrompt();
//				}
			}else{
//				isTextChanged=false;
//				updateLabelDisplay(selectedItem);
			}
//			if (!allowMultipleSelecte && selectedItemArray.length > 0)
//			{
//				selectedItem=selectedItemArray.getItemAt(0);
//			}
//			isTextChanged=false;
//			updateLabelDisplay(selectedItem);
			
		}

		private function resetPrompt():void
		{
			_textInputPrompt="";
			var index:int=0;
			for each (var item:*in selectedItemArray)
			{
				_textInputPrompt+=item[labelField];
				if (index < selectedItemArray.length - 1)
				{
					_textInputPrompt+=",";
				}
				index++;
			}
			if (_textInputPrompt != "")
			{
				textDisplay.text=_textInputPrompt;
				labelDisplay.text=_textInputPrompt;
			}
			else
			{
				textDisplay.text=prompt;
				labelDisplay.text=prompt;
			}
//			log.debug("[resetPrompt]{0},{1}",allowMultipleSelecte,isTextChanged);
//			isTextChanged=false;
			log.debug(id + ":resetPrompt :" + textDisplay.text);
		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			if (instance == textDisplay)
			{
				textDisplay.visible=editable;
//				textDisplay.addEventListener(KeyboardEvent.KEY_DOWN, onTextDisplayKeyDownHandler);
//				textDisplay.addEventListener(KeyboardEvent.KEY_UP, onTextDisplayKeyUpHandler);
				textDisplay.addEventListener(FocusEvent.FOCUS_IN, onTextDisplayFocusInHandler);
				textDisplay.addEventListener(FocusEvent.FOCUS_OUT, onTextDisplayFocusOutHandler);
				textDisplay.addEventListener(TextOperationEvent.CHANGE, onTextOperChangeHandler);
			}

			if (instance == labelDisplay)
			{
				labelDisplay.visible=!editable;
			}
			if (instance == dataGroup)
			{
				if (allowMultipleSelecte)
				{
					dataGroup.itemRenderer=new ClassFactory(MultiEditDropDownItemRenderer);
				}
			}
			super.partAdded(partName, instance);
		}

		override protected function partRemoved(partName:String, instance:Object):void
		{
			if (instance == textDisplay)
			{
//				textDisplay.removeEventListener(KeyboardEvent.KEY_DOWN, onTextDisplayKeyDownHandler);
//				textDisplay.removeEventListener(KeyboardEvent.KEY_UP, onTextDisplayKeyUpHandler);
				textDisplay.removeEventListener(FocusEvent.FOCUS_IN, onTextDisplayFocusInHandler);
				textDisplay.removeEventListener(FocusEvent.FOCUS_OUT, onTextDisplayFocusOutHandler);
				textDisplay.removeEventListener(TextOperationEvent.CHANGE, onTextOperChangeHandler);
			}
			super.partRemoved(partName, instance);
		}

		private function onTextDisplayFocusInHandler(event:FocusEvent):void
		{
			log.debug("[onTextDisplayFocusInHandler]{0}", textDisplay.text);
			if (StringUtil.trim(event.target.text) == prompt)
			{
				event.target.text="";
			}
		}

		private function onTextDisplayFocusOutHandler(event:FocusEvent):void
		{
			log.debug("[onTextDisplayFocusOutHandler]{0}", textDisplay.text);
			if (StringUtil.trim(event.target.text) == "")
			{
				event.target.text=prompt;
			}
		}

		private function onTextOperChangeHandler(event:TextOperationEvent):void
		{
			log.debug("[onTextOperChangeHandler]{0}", event.target.text);
//			if (StringUtil.trim(event.target.text) == "")
//			{
//				isTextChanged=false;
//				return;
//			}
			isTextChanged=true;
			if (!selectTimer.running)
			{
				selectTimer.start();
			}
		}


//		private function onTextDisplayKeyDownHandler(event:KeyboardEvent):void
//		{
//			if (selectTimer.running)
//			{
//				selectTimer.stop();
//			}
//		}

//		private function onTextDisplayKeyUpHandler(event:KeyboardEvent):void
//		{
//			log.error("[onTextDisplayKeyUpHandler]{0}",event.target.text);
//			if(StringUtil.trim(textDisplay.text) == "" || StringUtil.trim(textDisplay.text) == prompt){
//				return;
//			}
//			if(allowMultipleSelecte){
//				for each(var item:* in dataProvider){
//					item.selected=false;
//				}
//				selectedItemArray.removeAll();
//			}else{
//				selectedIndex=-1;
//				selectedItem=null;
//			}
//			
//			if (!selectTimer.running)
//			{
//				selectTimer.start();
//			}
//		}

		override protected function measure():void
		{
			if (textDisplay && typicalItem != null)
			{
				// Save the labelDisplay's dimensions in case we clear out typicalItem
				if (!sizeSetByTypicalItem)
				{
					textDisplayExplicitWidth=textDisplay.explicitWidth;
					textDisplayExplicitHeight=textDisplay.explicitHeight;
					sizeSetByTypicalItem=true;
				}

				textDisplay.explicitWidth=NaN;
				textDisplay.explicitHeight=NaN;

				log.debug("[measure]{0}",typicalItem);
				// Swap in the typicalItem into the labelDisplay
				updateLabelDisplay(typicalItem);
				UIComponentGlobals.layoutManager.validateClient(skin, true);

				// Force the labelDisplay to be sized to the measured size
				textDisplay.width=textDisplay.measuredWidth;
				textDisplay.height=textDisplay.measuredHeight;

				// Set the labelDisplay back to selectedItem
				updateLabelDisplay();
			}
			else if (sizeSetByTypicalItem && typicalItem == null)
			{
				// Restore the labelDisplay to its original size
				textDisplay.width=textDisplayExplicitWidth;
				textDisplay.height=textDisplayExplicitHeight;
				sizeSetByTypicalItem=false;
			}
			super.measure();
		}

		override public function set dataProvider(value:IList):void
		{
			super.dataProvider=value;
			selectedItemArray.removeAll();
		}

		override mx_internal function updateLabelDisplay(displayItem:*=undefined):void
		{
//			if (textDisplay)
//			{
//				log.error("====={0}",isTextChanged);
//				if(!isTextChanged){
//					textDisplay.text=labelDisplay.text;
//				}else{
//					isTextChanged=false;
//				}
//			}

//			if (!allowMultipleSelecte && !isTextChanged)
//			{
//				super.updateLabelDisplay(displayItem);
//			}
//			if (textDisplay && !isTextChanged)
//			{
//				textDisplay.text=labelDisplay.text;
//			}
			log.debug("[updateLabelDisplay]{0}", displayItem);
			if(!isTextChanged || displayItem){
				super.updateLabelDisplay(displayItem);
				textDisplay.text=labelDisplay.text;
			}
			log.debug("[updateLabelDisplay]{0}", textDisplay.text);
		}

		override mx_internal function findKey(eventCode:int):Boolean
		{
//			if (allowMultipleSelecte)
//			{
//				return false;
//			}
//			else
//			{
			return super.findKey(eventCode);
//			}

		}

		override protected function item_mouseDownHandler(event:MouseEvent):void
		{
			if (allowMultipleSelecte)
			{

			}
			else
			{
				super.item_mouseDownHandler(event);
			}
		}

		override mx_internal function isItemIndexSelected(index:int):Boolean
		{
			if (allowMultipleSelecte)
			{
				return false;
			}
			else
			{
				return super.isItemIndexSelected(index);
			}

		}

		public function get selectedItemArray():ArrayCollection
		{
			return _selectedItemArray;
		}

		public function set selectedItemArray(value:ArrayCollection):void
		{
			_selectedItemArray=value;
		}


	}
}