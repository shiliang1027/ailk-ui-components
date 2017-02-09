package com.ailk.common.ui.components.downloadprogress
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.events.RSLEvent;
	import mx.managers.BrowserManager;
	import mx.preloaders.DownloadProgressBar;
	import mx.preloaders.IPreloaderDisplay;
	import mx.utils.URLUtil;
	
	public class CustomPreloader extends DownloadProgressBar implements IPreloaderDisplay
	{
		private var dpbImageControl:Loader;
				
		public function CustomPreloader()
		{
			super();
		}
		
		protected function draw():void
		{
		}
		
		override public function set preloader(preloader:Sprite):void 
		{
			// Escuchar los eventos relevantes.
			preloader.addEventListener( ProgressEvent.PROGRESS, handleProgress );
			preloader.addEventListener( Event.COMPLETE, handleComplete );
			preloader.addEventListener(RSLEvent.RSL_PROGRESS, rsl_progressHandler);
			preloader.addEventListener(RSLEvent.RSL_COMPLETE, rsl_completeHandler);
			preloader.addEventListener( FlexEvent.INIT_PROGRESS, handleInitProgress );
			preloader.addEventListener( FlexEvent.INIT_COMPLETE, handleInitComplete );
		}
		// Inicializar el control Loader en el método initialize del interface IPreloaderDisplay
		override public function initialize():void 
		{	
//			var url:String=FlexGlobals.topLevelApplication.url;
//			var serverName:String=URLUtil.getServerName(url);
//			Alert.show("========="+url+","+serverName);
			var url:String = this.parent.stage.loaderInfo.url;
			DownLoadUtil.ASSETSFILE = url.substr(0,url.lastIndexOf("/"));
			
			
			var styleUrlParams:String = ExternalInterface.call("function(){return flashvars.styleUrl;}");
			if(styleUrlParams==null)
			{
				backgroundImage = DownLoadUtil.ASSETSFILE+"/libs/preloader.jpg";
			}
			else
			{
				var styleUrl:String = styleUrlParams.substring(0,styleUrlParams.lastIndexOf("/"));
				backgroundImage = styleUrl+"/assets/preloader.jpg";
			}
			backgroundSize = "100%";
			loadBackgroundImage(backgroundImage);
			dpbImageControl = new Loader();
			dpbImageControl.contentLoaderInfo.addEventListener( Event.COMPLETE, loader_completeHandler );
			dpbImageControl.load(new URLRequest(DownLoadUtil.ASSETSFILE+"/libs/preloader.swf"));
		}
		
		/**
		 *  @private
		 */
		private function loadBackgroundImage(classOrString:Object):void
		{
			var cls:Class;
			
			// The "as" operator checks to see if classOrString
			// can be coerced to a Class
			if (classOrString && classOrString as Class)
			{
				// Load background image given a class pointer
				cls = Class(classOrString);
				initBackgroundImage(new cls());
			}
			else if (classOrString && classOrString is String)
			{
				try
				{
					cls = Class(getDefinitionByName(String(classOrString)));
				}
				catch(e:Error)
				{
					// ignore
				}
				
				if (cls)
				{
					var newStyleObj:DisplayObject = new cls();
					initBackgroundImage(newStyleObj);
				}
				else
				{
					// Loading the image is slightly different
					// than in Loader.loadContent()... is this on purpose?
					
					// Load background image from external URL
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(
						Event.COMPLETE, loader_BGimg_completeHandler);
					loader.contentLoaderInfo.addEventListener(
						IOErrorEvent.IO_ERROR, loader_ioErrorHandler);  
					var loaderContext:LoaderContext = new LoaderContext();
					loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
					loader.load(new URLRequest(String(classOrString)), loaderContext);      
				}
			}
		}
		
		/**
		 *  @private
		 */
		private function initBackgroundImage(image:DisplayObject):void
		{
			addChildAt(image,0);
			
			var backgroundImageWidth:Number = image.width;
			var backgroundImageHeight:Number = image.height;
			
			// Scale according to backgroundSize
			var percentage:Number = calcBackgroundSize();
			if (isNaN(percentage))
			{
				var sX:Number = 1.0;
				var sY:Number = 1.0;
			}
			else
			{
				var scale:Number = percentage * 0.01;
				sX = scale * this.stage.stageWidth / backgroundImageWidth;
				sY = scale * this.stage.stageHeight / backgroundImageHeight;
			}
			
			image.scaleX = sX;
			image.scaleY = sY;
			
			// Center everything.
			// Use a scrollRect to position and clip the image.
			var offsetX:Number =
				Math.round(0.5 * (this.stage.stageWidth - backgroundImageWidth * sX));
			var offsetY:Number =
				Math.round(0.5 * (this.stage.stageHeight - backgroundImageHeight * sY));
			
			image.x = offsetX;
			image.y = offsetY;
			
			// Adjust alpha to match backgroundAlpha
			if (!isNaN(backgroundAlpha))
				image.alpha = backgroundAlpha;
		}
		
		/**
		 *  @private
		 */
		private function calcBackgroundSize():Number
		{   
			var percentage:Number = NaN;
			
			if (backgroundSize)
			{
				var index:int = backgroundSize.indexOf("%");
				if (index != -1)
					percentage = Number(backgroundSize.substr(0, index));
			}
			
			return percentage;
		}
		
		/**
		 *  @private
		 */
		private function loader_BGimg_completeHandler(event:Event):void
		{
			var target:DisplayObject = DisplayObject(LoaderInfo(event.target).loader);
			initBackgroundImage(target);
		}
		
		private function loader_ioErrorHandler(event:IOErrorEvent):void
		{
			// Swallow the error
		}
		
		// Después de cargar el SWF
		private function loader_completeHandler(event:Event):void 
		{	
			setRelacion(0);
			addChild( dpbImageControl );
			dpbImageControl.x = this.stage.stageWidth/2 - dpbImageControl.contentLoaderInfo.width/2;
			dpbImageControl.y = this.stage.stageHeight/2 - dpbImageControl.contentLoaderInfo.height/2;
		}
		
		// Definir los oyentes vacíos.
		private function handleProgress(event:ProgressEvent):void 
		{
			
		}
		
		protected function rsl_progressHandler(event:RSLEvent):void
		{
			var relacion:Number = event.rslIndex / event.rslTotal;
			setRelacion(relacion);
		}
		protected function rsl_completeHandler(event:RSLEvent):void
		{
			
		}
		
		private function handleComplete(event:Event):void 
		{
			setRelacion(1);
		}
		
		private function setRelacion(relacion:Number):void{
			if (dpbImageControl.content)
			{
				dpbImageControl.content["barra"].scaleX = relacion;
				dpbImageControl.content["porcentaje"].text = relacion * 100;
			}
		}
		private function handleInitProgress(event:Event):void 
		{
		}
		
		private function handleInitComplete(event:Event):void 
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}