package AtomicPlus.GameEntity.GameMenu 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.GraphicsLoader;
	import AmidosEngine.Text;
	import AmidosEngine.TouchControl;
	import AtomicPlus.CollisionName;
	import AtomicPlus.GameEntity.BackgroundEntity;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ArrowButtonEntity extends BaseEntity
	{
		public static const LEFT:int = 0;
		public static const RIGHT:int = 1;
		
		private var backBitmap:Image;
		private var arrowText:Text;
		private var backgroundEntity:BackgroundEntity;
		private var pressFunction:Function;
		private var colorTransform:ColorTransform;
		private var touchPoints:Vector.<Point>;
		
		public function ArrowButtonEntity(xIn:int, yIn:int, background:BackgroundEntity, direction:int, pressFunction:Function) 
		{
			x = xIn;
			y = yIn;
			
			this.pressFunction = pressFunction;
			backgroundEntity = background;
			
			bitmap = new Image(GraphicsLoader.GetGraphics("buttonfront"));
			CenterOO();
			
			backBitmap = new Image(GraphicsLoader.GetGraphics("buttonback"));
			backBitmap.x = bitmap.x;
			backBitmap.y = bitmap.y;
			backBitmap.color = backgroundEntity.GetCurrentBackColor();
			
			if (direction == LEFT)
			{
				arrowText = new Text("<", 0xFFFFFF, Text.MEDIUM_FONT * GraphicsLoader.ConversionRatio);
				arrowText.CenterOO();
			}
			else
			{
				arrowText = new Text(">", 0xFFFFFF, Text.MEDIUM_FONT * GraphicsLoader.ConversionRatio);
				arrowText.CenterOO();
				arrowText.x += 4 * GraphicsLoader.ConversionRatio;
			}
			arrowText.y += 2 * GraphicsLoader.ConversionRatio;
			
			layer = LayerConstant.HUD_LAYER;
			
			SetHitBox(bitmap.width, bitmap.height, bitmap.x, bitmap.y);
			collisionName = CollisionName.BUTTON_NAME;
		}
		
		override public function Added():void 
		{
			addChild(backBitmap);
			
			super.Added();
			
			arrowText.Added();
			addChild(arrowText);
		}
		
		override public function Removed():void 
		{
			removeChild(backBitmap);
			
			super.Removed();
			
			arrowText.Removed();
			removeChild(arrowText);
		}
		
		override public function Update():void 
		{
			super.Update();
			
			backBitmap.color = backgroundEntity.GetCurrentBackColor();
			
			touchPoints = TouchControl.TouchPressedPoints(TouchControl.ANY_SCREEN);
			for (var i:int = 0; i < touchPoints.length; i++) 
			{
				if (CheckCollisionWithPoint(touchPoints[i].x, touchPoints[i].y, x, y))
				{
					if (pressFunction != null)
					{
						pressFunction();
					}
				}
			}
		}
		
		override public function RenderMissingFrame():void 
		{
			super.RenderMissingFrame();
			
			backBitmap.color = backgroundEntity.GetCurrentBackColor();
		}
	}

}