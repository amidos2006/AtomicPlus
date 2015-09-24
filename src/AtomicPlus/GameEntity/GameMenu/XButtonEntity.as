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
	/**
	 * ...
	 * @author Amidos
	 */
	public class XButtonEntity extends BaseEntity
	{	
		private var xText:Text;
		private var pressFunction:Function;
		private var touchPoints:Vector.<Point>;
		
		public function XButtonEntity(xIn:int, yIn:int, pressFunction:Function) 
		{
			x = xIn;
			y = yIn;
			
			this.pressFunction = pressFunction;
			
			xText = new Text("x", 0xFFFFFF, Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			xText.CenterOO();
			
			layer = LayerConstant.HUD_LAYER;
			
			SetHitBox(Text.LARGE_FONT * GraphicsLoader.ConversionRatio, Text.LARGE_FONT * GraphicsLoader.ConversionRatio, 
						-Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, -Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio);
			collisionName = CollisionName.BUTTON_NAME;
		}
		
		override public function Added():void 
		{
			super.Added();
			
			xText.Added();
			addChild(xText);
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			xText.Removed();
			removeChild(xText);
		}
		
		override public function Update():void 
		{
			super.Update();
			
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
	}

}