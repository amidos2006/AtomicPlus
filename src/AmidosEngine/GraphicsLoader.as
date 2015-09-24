package AmidosEngine 
{
	import AtomicPlus.Global;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GraphicsLoader 
	{
		[Embed(source = "../../assets/graphics/overlay.png")]private static var overlayerClass:Class;
		[Embed(source = "../../assets/graphics/hitOverlay.png")]private static var hitOverlayerClass:Class;
		[Embed(source = "../../assets/graphics/gameCenter.png")]private static var gamecenterClass:Class;
		[Embed(source = "../../assets/graphics/getOST.png")]private static var getOSTClass:Class;
		[Embed(source = "../../assets/graphics/headphones.png")]private static var headphonesClass:Class;
		
		private static var MAX_HEIGHT:int = 800;
		private static var ORBIT_STEP:int = 30;
		private static var MAX_LOADING_PARTS:int = 19;
		
		private static var graphicsList:Array;
		private static var currentWidth:int;
		private static var currentHeight:int;
		
		public static function Intialize(width:int, height:int):void
		{
			currentWidth = Math.max(width, height);
			currentHeight = Math.min(width, height);
			
			graphicsList = new Array();
		}
		
		public static function IntializeByParts(currentPart:int):void
		{
			var bitmapData:BitmapData;
			var sprite:Sprite;
			var matrix:Matrix;
			
			switch (currentPart) 
			{
				case 0:
					bitmapData = new BitmapData(1, 1, true, 0xFFFFFFFF);
					graphicsList["background"] = Texture.fromBitmapData(bitmapData);
					break;
				case 1:
					bitmapData = new BitmapData(1, 1, true, 0xFF000000);
					graphicsList["blackbackground"] = Texture.fromBitmapData(bitmapData);
					break;
				case 2:
					bitmapData = new BitmapData(currentWidth, currentHeight, true, 0xFFFFFFFF);
					sprite = new Sprite();
					sprite.graphics.beginFill(0x000000);
					sprite.graphics.drawCircle(0, 0, (currentHeight - 150) * ConversionRatio / 2);
					sprite.graphics.endFill();
					matrix = new Matrix();
					matrix.translate(bitmapData.width / 2, bitmapData.height / 2);
					bitmapData.draw(sprite, matrix);
					bitmapData.applyFilter(bitmapData, new Rectangle(0, 0, bitmapData.width, bitmapData.height), 
											new Point(), new BlurFilter(200, 200, 2));
					
					var bitmap:Bitmap = new overlayerClass();
					graphicsList["overlayer"] = Texture.fromBitmapData(bitmap.bitmapData);
					break;
				case 3:
					bitmap = new hitOverlayerClass();
					graphicsList["hitoverlayer"] = Texture.fromBitmapData(bitmap.bitmapData);
					break;
				case 4:
					bitmap = new gamecenterClass();
					graphicsList["gamecenter"] = Texture.fromBitmapData(bitmap.bitmapData);
					break;
				case 5:
					bitmap = new getOSTClass();
					graphicsList["getost"] = Texture.fromBitmapData(bitmap.bitmapData);
					break;
				case 6:
					bitmap = new headphonesClass();
					graphicsList["headphones"] = Texture.fromBitmapData(bitmap.bitmapData);
					break;
				case 7:
					bitmapData = new BitmapData(2 * Global.BULLET_RADIUS * ConversionRatio, 2 * Global.BULLET_RADIUS * ConversionRatio, true, 0);
					sprite = new Sprite();
					sprite.graphics.beginFill(0xFFFFFF);
					sprite.graphics.drawCircle(bitmapData.width / 2, bitmapData.height / 2, Global.BULLET_RADIUS * ConversionRatio);
					sprite.graphics.endFill();
					bitmapData.draw(sprite);
					
					graphicsList["bullet"] = Texture.fromBitmapData(bitmapData);
					break;
				case 8:
					bitmapData = new BitmapData(2.5 * Global.PLAYER_RADIUS * ConversionRatio, 2.5 * Global.PLAYER_RADIUS * ConversionRatio, true, 0);
					sprite = new Sprite();
					sprite.graphics.beginFill(0xFFFFFF);
					sprite.graphics.drawCircle(bitmapData.width / 2, bitmapData.height / 2, Global.PLAYER_RADIUS * ConversionRatio);
					sprite.graphics.endFill();
					bitmapData.draw(sprite);
					
					graphicsList["playerback"] = Texture.fromBitmapData(bitmapData);
					break;
				case 9:
					bitmapData = new BitmapData(2.5 * Global.PLAYER_RADIUS * ConversionRatio, 2.5 * Global.PLAYER_RADIUS * ConversionRatio, true, 0);
					sprite = new Sprite();
					sprite.graphics.lineStyle(Global.STROKE_THICKNESS * ConversionRatio, 0xFFFFFF);
					sprite.graphics.drawCircle(bitmapData.width / 2, bitmapData.height / 2, Global.PLAYER_RADIUS * ConversionRatio);
					bitmapData.draw(sprite);
					
					graphicsList["playerfront"] = Texture.fromBitmapData(bitmapData);
					break;
				case 10:
					bitmapData = new BitmapData(2.5 * Global.BUTTON_RADIUS * ConversionRatio, 2.5 * Global.BUTTON_RADIUS * ConversionRatio, true, 0);
					sprite = new Sprite();
					sprite.graphics.beginFill(0xFFFFFF);
					sprite.graphics.drawCircle(bitmapData.width / 2, bitmapData.height / 2, Global.BUTTON_RADIUS * ConversionRatio);
					sprite.graphics.endFill();
					bitmapData.draw(sprite);
					
					graphicsList["buttonback"] = Texture.fromBitmapData(bitmapData);
					break;
				case 11:
					bitmapData = new BitmapData(2.5 * Global.BUTTON_RADIUS * ConversionRatio, 2.5 * Global.BUTTON_RADIUS * ConversionRatio, true, 0);
					sprite = new Sprite();
					sprite.graphics.lineStyle(Global.STROKE_THICKNESS * ConversionRatio, 0xFFFFFF);
					sprite.graphics.drawCircle(bitmapData.width / 2, bitmapData.height / 2, Global.BUTTON_RADIUS * ConversionRatio);
					bitmapData.draw(sprite);
					
					graphicsList["buttonfront"] = Texture.fromBitmapData(bitmapData);
					break;
				case 12:
					bitmapData = new BitmapData(2 * (Global.GetCurrentOrbitRadius(1) + Global.STROKE_THICKNESS + 30) * ConversionRatio, 2 * (Global.GetCurrentOrbitRadius(1) + Global.STROKE_THICKNESS + 30) * ConversionRatio, true, 0);
					sprite = new Sprite();
					sprite.graphics.beginFill(0xFFFFFF);
					sprite.graphics.drawCircle(bitmapData.width / 2, bitmapData.height / 2, (Global.GetCurrentOrbitRadius(1) + Global.STROKE_THICKNESS + 30) * ConversionRatio);
					sprite.graphics.endFill();
					bitmapData.draw(sprite);
					
					graphicsList["core"] = Texture.fromBitmapData(bitmapData);
					break;
				case 13:
					bitmapData = new BitmapData(2 * (Global.GetCurrentOrbitRadius(3) + 2 * Global.STROKE_THICKNESS) * ConversionRatio, 
										2 * (Global.GetCurrentOrbitRadius(3) + 2 * Global.STROKE_THICKNESS) * ConversionRatio, true, 0);
					sprite = new Sprite();
					sprite.graphics.lineStyle(Global.STROKE_THICKNESS * ConversionRatio, 0xFFFFFF, 1);
					sprite.graphics.drawCircle(bitmapData.width / 2, bitmapData.height / 2, Global.GetCurrentOrbitRadius(3) * ConversionRatio);
					sprite.graphics.drawCircle(bitmapData.width / 2, bitmapData.height / 2, Global.GetCurrentOrbitRadius(1) * ConversionRatio);
					bitmapData.draw(sprite);
					sprite.graphics.clear();
					sprite.graphics.lineStyle(Global.LINE_THICKNESS * ConversionRatio, 0xFFFFFF, 1);
					for (var i:int = 0; i < Global.NUMBER_OF_LINES; i++) 
					{
						var angle:Number = i * 2 * Math.PI / Global.NUMBER_OF_LINES;
						var endX:Number = bitmapData.width / 2 + Math.cos(angle) * (Global.GetCurrentOrbitRadius(3) + 2 * Global.STROKE_THICKNESS) * ConversionRatio;
						var endY:Number = bitmapData.height / 2 + Math.sin(angle) * (Global.GetCurrentOrbitRadius(3) + 2 * Global.STROKE_THICKNESS) * ConversionRatio;
						
						sprite.graphics.moveTo(bitmapData.width / 2, bitmapData.height / 2);
						sprite.graphics.lineTo(endX, endY);
					}
					bitmapData.draw(sprite, null, null, BlendMode.ERASE);
					
					graphicsList["largeorbits"] = Texture.fromBitmapData(bitmapData);
					break;
				case 14:
					bitmapData = new BitmapData(2 * (Global.GetCurrentOrbitRadius(3) + 2 * Global.STROKE_THICKNESS) * ConversionRatio, 
										2 * (Global.GetCurrentOrbitRadius(3) + 2 * Global.STROKE_THICKNESS) * ConversionRatio, true, 0);
					sprite = new Sprite();
					sprite.graphics.lineStyle(Global.STROKE_THICKNESS * ConversionRatio, 0xFFFFFF, 1);
					sprite.graphics.drawCircle(bitmapData.width / 2, bitmapData.height / 2, Global.GetCurrentOrbitRadius(2) * ConversionRatio);
					sprite.graphics.drawCircle(bitmapData.width / 2, bitmapData.height / 2, Global.GetCurrentOrbitRadius(0) * ConversionRatio);
					bitmapData.draw(sprite);
					sprite.graphics.clear();
					sprite.graphics.lineStyle(Global.LINE_THICKNESS * ConversionRatio, 0xFFFFFF, 1);
					for (i = 0; i < Global.NUMBER_OF_LINES; i++) 
					{
						angle = i * 2 * Math.PI / Global.NUMBER_OF_LINES;
						endX = bitmapData.width / 2 + Math.cos(angle) * (Global.GetCurrentOrbitRadius(3) + 2 * Global.STROKE_THICKNESS) * ConversionRatio;
						endY = bitmapData.height / 2 + Math.sin(angle) * (Global.GetCurrentOrbitRadius(3) + 2 * Global.STROKE_THICKNESS) * ConversionRatio;
						
						sprite.graphics.moveTo(bitmapData.width / 2, bitmapData.height / 2);
						sprite.graphics.lineTo(endX, endY);
					}
					bitmapData.draw(sprite, null, null, BlendMode.ERASE);
					
					graphicsList["smallorbits"] = Texture.fromBitmapData(bitmapData);
					break;
				case 15:
					sprite = new Sprite();
					for (i = 0; i < Global.GetNumberOfColors(); i++) 
					{
						bitmapData = new BitmapData((Global.BOX_LENGTH + 2 * Global.STROKE_THICKNESS) * ConversionRatio, 
												(Global.BOX_LENGTH + 2 * Global.STROKE_THICKNESS) * ConversionRatio, true, 0);
						sprite.graphics.clear();
						sprite.graphics.lineStyle(Global.STROKE_THICKNESS * ConversionRatio, 0xFFFFFF, 1);
						sprite.graphics.beginFill(Global.GetColor(i), 1);
						sprite.graphics.drawRect(Global.STROKE_THICKNESS * ConversionRatio, Global.STROKE_THICKNESS * ConversionRatio, 
												Global.BOX_LENGTH * ConversionRatio, Global.BOX_LENGTH * ConversionRatio);
						sprite.graphics.endFill();
						
						bitmapData.draw(sprite);
						graphicsList["box" + i.toString()] = Texture.fromBitmapData(bitmapData);
					}
					break;
				case 16:
					bitmapData = new BitmapData(currentWidth, 30 * ConversionRatio, true, 0);
					sprite = new Sprite();
					sprite.graphics.lineStyle(Global.STROKE_THICKNESS * ConversionRatio ,0xFFFFFF);
					sprite.graphics.drawRect(20 * ConversionRatio, Global.STROKE_THICKNESS * ConversionRatio, currentWidth - 40 * ConversionRatio, (30 - 2 * Global.STROKE_THICKNESS) * ConversionRatio);
					bitmapData.draw(sprite);
					
					graphicsList["damagebaroutline"] = Texture.fromBitmapData(bitmapData);
					break;
				case 17:
					bitmapData = new BitmapData(currentWidth - 40 * ConversionRatio, (30 - 2 * Global.STROKE_THICKNESS) * ConversionRatio, true, 0);
					bitmapData.floodFill(0, 0, 0xFFFFFFFF);
					
					graphicsList["damagebar"] = Texture.fromBitmapData(bitmapData);
					break;
				case 18:
					sprite = new Sprite();
					for (i = Global.MIN_RADIUS; i < Global.MAX_RADIUS; i+= ORBIT_STEP) 
					{
						sprite.graphics.clear();
						sprite.graphics.lineStyle(Global.STROKE_THICKNESS * GraphicsLoader.ConversionRatio, 0xFFFFFF);
						sprite.graphics.drawCircle(0, 0, i * GraphicsLoader.ConversionRatio);
						bitmapData = new BitmapData(2 * (Global.MAX_RADIUS + 2 * Global.STROKE_THICKNESS) * ConversionRatio, 
												2 * (Global.MAX_RADIUS + 2 * Global.STROKE_THICKNESS) * ConversionRatio, true, 0);
						matrix = new Matrix();
						matrix.translate(bitmapData.width / 2, bitmapData.height / 2);
						bitmapData.draw(sprite, matrix);
						graphicsList["mainorbit" + i.toString()] = Texture.fromBitmapData(bitmapData);
					}
					break;
			}
		}
		
		public static function get Width():int
		{
			return currentWidth;
		}
		
		public static function get Height():int
		{
			return currentHeight;
		}
		
		public static function get OrbitStep():int
		{
			return ORBIT_STEP;
		}
		
		public static function get MaxLoadingParts():int
		{
			return MAX_LOADING_PARTS;
		}
		
		public static function get ApplyScale():Boolean
		{
			return currentHeight > MAX_HEIGHT;
		}
		
		public static function get ConversionRatio():Number
		{
			return currentHeight / MAX_HEIGHT;
		}
		
		public static function GetGraphics(name:String):Texture
		{
			return graphicsList[name.toLowerCase()];
		}
	}

}