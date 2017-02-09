package com.ailk.common.ui.components.pagination
{
	import com.ailk.common.ui.components.pagination.event.PaginationEvent;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.ValidationResultEvent;
	import mx.validators.NumberValidator;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.TextInput;

	/**
	 * 分页组件
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-6-20 下午04:19:51
	 * @category com.ailk.common.ui.components.pagination
	 * @copyright 南京联创科技 网管开发部
	 */
	[Event(name="firstPage", type="com.ailk.common.ui.components.pagination.event.PaginationEvent")]
	[Event(name="prePage", type="com.ailk.common.ui.components.pagination.event.PaginationEvent")]
	[Event(name="nextPage", type="com.ailk.common.ui.components.pagination.event.PaginationEvent")]
	[Event(name="lastPage", type="com.ailk.common.ui.components.pagination.event.PaginationEvent")]
	[Event(name="pageChange", type="com.ailk.common.ui.components.pagination.event.PaginationEvent")]
	public class Pagination extends SkinnableContainer
	{
		private var _currentPage:Number=1;
		private var _pageSize:Number=10;
		private var _maxPage:Number=0;
		private var _totalRowCount:Number=0;
		
		[SkinPart(required="false")]
		public var totalNumInfo:Label;
		[SkinPart(required="false")]
		public var pageSizeInfo:Label;
		[SkinPart(required="false")]
		public var currentPageInfo:Label;
		[SkinPart(required="false")]
		public var totalPageInfo:Label;
		[SkinPart(required="false")]
		public var pageChangeInput:TextInput;
		[SkinPart(required="false")]
		public var pageChangeBtn:Button;
		[SkinPart(required="false")]
		public var firstPage:Button;
		[SkinPart(required="false")]
		public var prePage:Button;
		[SkinPart(required="false")]
		public var nextPage:Button;
		[SkinPart(required="false")]
		public var lastPage:Button;
		
		[Inspectable(category="General", enumeration="true,false", defaultValue="true")]
		public var showTotalNumInfo:Boolean=true;
		[Inspectable(category="General", enumeration="true,false", defaultValue="true")]
		public var showPageSizeInfo:Boolean=true;
		
		public function Pagination()
		{
		}
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(instance == firstPage){
				firstPage.addEventListener(MouseEvent.CLICK,firstPageClick);
			}else if(instance == prePage){
				prePage.addEventListener(MouseEvent.CLICK,prePageClick);
			}else if(instance == nextPage){
				nextPage.addEventListener(MouseEvent.CLICK,nextPageClick);
			}else if(instance == lastPage){
				lastPage.addEventListener(MouseEvent.CLICK,lastPageClick);
			}else if(instance == pageSizeInfo){
				pageSizeInfo.visible=showPageSizeInfo;
				pageSizeInfo.includeInLayout=showPageSizeInfo;
				pageSizeInfo.text = "每页"+_pageSize+"条";
			}else if(instance == totalNumInfo){
				totalNumInfo.visible=showTotalNumInfo;
				totalNumInfo.includeInLayout = showTotalNumInfo;
				totalNumInfo.text = "总记录"+_totalRowCount+"条";
			}else if(instance == currentPageInfo){
				currentPageInfo.text = "第"+_currentPage+"页";
			}else if(instance == totalPageInfo){
				totalPageInfo.text = "共"+_maxPage+"页";
			}else if(instance == pageChangeInput){
				pageChangeInput.visible=showPageSizeInfo;
				pageChangeInput.includeInLayout=showPageSizeInfo;
				pageChangeInput.addEventListener(KeyboardEvent.KEY_UP,onPageChangeInputKekUp);
				var valid:NumberValidator = new NumberValidator();
				valid.source = pageChangeInput;
				valid.property = "text";
				valid.domain = "int";
				valid.addEventListener(ValidationResultEvent.VALID,onValid);
				valid.addEventListener(ValidationResultEvent.INVALID,onInvalid);
				valid.trigger = pageChangeInput;
				valid.triggerEvent = KeyboardEvent.KEY_UP;
			}else if(instance == pageChangeBtn){
				pageChangeBtn.visible=showPageSizeInfo;
				pageChangeBtn.includeInLayout=showPageSizeInfo;
				pageChangeBtn.addEventListener(MouseEvent.CLICK,onPageChangeClick);
			}
			checkEnable();
		}
		
		private function onPageChangeClick(event:MouseEvent):void{
			var page:Number = Number(pageChangeInput.text);
			if(page>0 && page<=maxPage){
				currentPage = page;
				dispatchEvent(new PaginationEvent(PaginationEvent.PAGE_CHANGE));
			}else{
				Alert.show("页数错误!");
			}
		}
		
		private function firstPageClick(event:MouseEvent):void{
			if(hasPrePage()){
				currentPage=1;
				dispatchEvent(new PaginationEvent(PaginationEvent.PAGE_FIRST));
				dispatchEvent(new PaginationEvent(PaginationEvent.PAGE_CHANGE));
			}
			checkEnable();
		}
		
		private function prePageClick(event:MouseEvent):void{
			if(hasPrePage()){
				currentPage--;
				dispatchEvent(new PaginationEvent(PaginationEvent.PAGE_PRE));
				dispatchEvent(new PaginationEvent(PaginationEvent.PAGE_CHANGE));
			}
			checkEnable();
		}
		
		private function nextPageClick(event:MouseEvent):void{
			if(hasNextPage()){
				currentPage++;
				dispatchEvent(new PaginationEvent(PaginationEvent.PAGE_NEXT));
				dispatchEvent(new PaginationEvent(PaginationEvent.PAGE_CHANGE));
			}
			checkEnable();
		}
		
		private function lastPageClick(event:MouseEvent):void{
			if(hasNextPage()){
				currentPage = maxPage;
				dispatchEvent(new PaginationEvent(PaginationEvent.PAGE_LAST));
				dispatchEvent(new PaginationEvent(PaginationEvent.PAGE_CHANGE));
			}
			checkEnable();
		}
		private function checkEnable():void{
			if(!hasPrePage()){
				if(firstPage){
					firstPage.enabled=false;
				}
				if(prePage){
					prePage.enabled=false;
				}
			}else{
				if(firstPage){
					firstPage.enabled=true;
				}
				if(prePage){
					prePage.enabled=true;
				}
			}
			if(!hasNextPage()){
				if(nextPage){
					nextPage.enabled=false;
				}
				if(lastPage){
					lastPage.enabled=false;
				}
			}else{
				if(nextPage){
					nextPage.enabled=true;
				}
				if(lastPage){
					lastPage.enabled=true;
				}
			}
		}
		private function onPageChangeInputKekUp(event:KeyboardEvent):void{
			if(event.keyCode == 13){
				var page:Number = Number(pageChangeInput.text);
				if(page>0 && page<=maxPage){
					currentPage = page;
					dispatchEvent(new PaginationEvent(PaginationEvent.PAGE_CHANGE));
				}else{
					Alert.show("页数错误!");
				}
			}
		}
		
		private function onValid(event:ValidationResultEvent):void{
			
		}
		
		private function onInvalid(event:ValidationResultEvent):void{
		}
		
		public function hasPrePage():Boolean{
			if(currentPage>1){
				return true;
			}
			return false;
		}
		
		public function hasNextPage():Boolean{
			if(currentPage<maxPage){
				return true;
			}
			return false;
		}
		
		
		/**
		 *当前页 
		 */
		public function get currentPage():Number
		{
			return _currentPage;
		}

		/**
		 * @private
		 */
		public function set currentPage(value:Number):void
		{
			_currentPage = value;
			try{
				currentPageInfo.text = "第"+_currentPage+"页";
			}catch(e:Error){
				
			}
			checkEnable();
		}

		/**
		 *每页记录数 
		 */
		public function get pageSize():Number
		{
			return _pageSize;
		}

		/**
		 * @private
		 */
		public function set pageSize(value:Number):void
		{
			_pageSize = value;
			try{
				pageSizeInfo.text = "每页"+_pageSize+"条";
			}catch(e:Error){
				
			}
		}

		/**
		 *最大页数 
		 */
		public function get maxPage():Number
		{
			return _maxPage;
		}

		/**
		 * @private
		 */
		public function set maxPage(value:Number):void
		{
			_maxPage = value;
			try{
				totalPageInfo.text = "共"+_maxPage+"页";
			}catch(e:Error){
				
			}
			checkEnable();
		}

		/**
		 *总记录数 
		 */
		public function get totalRowCount():Number
		{
			return _totalRowCount;
		}

		/**
		 * @private
		 */
		public function set totalRowCount(value:Number):void
		{
			_totalRowCount = value;
			try{
				totalNumInfo.text = "总记录"+_totalRowCount+"条";
			}catch(e:Error){
				
			}
			if(_totalRowCount % pageSize == 0){
				maxPage = _totalRowCount/pageSize;
			}else{
				maxPage = int(_totalRowCount/pageSize) + 1;
			}
		}
	}
}