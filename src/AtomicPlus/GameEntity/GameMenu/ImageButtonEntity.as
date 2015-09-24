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
	public class ImageButtonEntity extends BaseEntity
	{	
		private var pressFunction:Function;
		private var touchPoints:Vector.<Point>;
		
		public function ImageButtonEntity(xIn:int, yIn:int, imageName:String, pressFunction:Function) 
		{
			x = xIn;
			y = yIn;
			
			this.pressFunction = pressFunction;
			
			this.bitmap = new Image(GraphicsLoader.GetGraphics(imageName));
			this.bitmap.scaleX = GraphicsLoader.ConversionRatio;
			this.bitmap.scaleY = GraphicsLoader.ConversionRatio;
			CenterOO();
			
			layer = LayerConstant.HUD_LAYER;
			
			SetHitBox(Text.LARGE_FONT * GraphicsLoader.ConversionRatio, Text.LARGE_FONT * GraphicsLoader.ConversionRatio, 
						-Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, -Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio);
			collisionName = CollisionName.BUTTON_NAME;
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