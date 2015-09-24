package AtomicPlus.GameEntity.GameMenu 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.GraphicsLoader;
	import AmidosEngine.TouchControl;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MenuCoreEntity extends BaseEntity
	{
		private static const ENLARGE:int = 0;
		private static const NORMAL:int = 1;
		private static const SHRINK:int = 2;
		
		private var minScale:Number;
		private var maxScale:Number;
		private var shrinkScaleSpeed:Number;
		private var enlargeScaleSpeed:Number;
		private var state:int;
		private var endFunction:Function;
		
		public function MenuCoreEntity() 
		{
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			state = NORMAL;
			
			minScale = Global.CORE_RADIUS / (Global.GetCurrentOrbitRadius(1) + 30);
			maxScale = 1;
			shrinkScaleSpeed = -0.1;
			enlargeScaleSpeed = 0.1;
			
			bitmap = new Image(GraphicsLoader.GetGraphics("core"));
			
			bitmap.scaleX = minScale;
			bitmap.scaleY = bitmap.scaleX;
			CenterOO();
			
			layer = LayerConstant.CORE_LAYER;
		}
		
		public function Enlarge(endFunction:Function):void
		{
			state = ENLARGE;
			this.endFunction = endFunction;
		}
		
		public function Shrink(endFunction:Function):void
		{
			state = SHRINK;
			this.endFunction = endFunction;
		}
		
		override public function Update():void 
		{
			super.Update();
			
			switch (state)
			{
				case SHRINK:
					bitmap.scaleX += shrinkScaleSpeed;
					if (bitmap.scaleX < minScale)
					{
						bitmap.scaleX = minScale;
						state = NORMAL;
						if (endFunction != null)
						{
							endFunction();
						}
					}
					bitmap.scaleY = bitmap.scaleX;
					CenterOO();
					break;
				case ENLARGE:
					bitmap.scaleX += enlargeScaleSpeed;
					if (bitmap.scaleX > maxScale)
					{
						bitmap.scaleX = maxScale;
						state = NORMAL;
						if (endFunction != null)
						{
							endFunction();
						}
					}
					bitmap.scaleY = bitmap.scaleX;
					CenterOO();
					break;
			}
		}
	}

}