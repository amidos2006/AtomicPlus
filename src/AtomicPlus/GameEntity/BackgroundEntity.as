package AtomicPlus.GameEntity 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.GraphicsLoader;
	import AmidosEngine.TouchControl;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BackgroundEntity extends BaseEntity
	{
		private var colorTransform:ColorTransform;
		private var percentage:Number;
		private var amount:Number;
		private var intialColor:uint;
		
		public function BackgroundEntity() 
		{
			colorTransform = new ColorTransform();
			
			percentage = 1;
			amount = 0.15;
			
			bitmap = new Image(GraphicsLoader.GetGraphics("background"));
			bitmap.scaleX = GraphicsLoader.Width;
			bitmap.scaleY = GraphicsLoader.Height;
			layer = LayerConstant.BACKGROUND_LAYER;
		}
		
		override public function Added():void 
		{
			super.Added();
			
			intialColor = Global.GetCurrentColor();
			bitmap.color = intialColor;
		}
		
		public function ChangeBackgroundColor():void
		{
			intialColor = bitmap.color;
			Global.ChangeRandomColor();
			percentage = 0;
		}
		
		public function GetCurrentBackColor():uint
		{
			return bitmap.color;
		}
		
		override public function Update():void 
		{
			super.Update();
			
			if (percentage < 1)
			{
				var red:Number = 0x000000FF & intialColor >> 16;
				var green:Number = 0x000000FF & intialColor >> 8;
				var blue:Number = 0x000000FF & intialColor;
				
				var finalRed:Number = 0x000000FF & Global.GetCurrentColor() >> 16;
				var finalGreen:Number = 0x000000FF & Global.GetCurrentColor() >> 8;
				var finalBlue:Number = 0x000000FF & Global.GetCurrentColor();
				
				percentage += amount;
				if (percentage >= 1)
				{
					percentage = 1;
				}
				
				red = (red + (finalRed - red) * percentage);
				green = (green + (finalGreen - green) * percentage);
				blue = (blue + (finalBlue - blue) * percentage);
				var combinedColor:uint = 0xFF000000 | (red << 16 | green << 8 | blue);
				
				bitmap.color = combinedColor;
			}
		}
	}

}