package AtomicPlus.GameEntity 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.GraphicsLoader;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HitOverlayerEntity extends BaseEntity
	{
		private var whiteFillingLeft:Image;
		private var whiteFillingRight:Image;
		private var fadingSpeed:Number;
		
		public function HitOverlayerEntity() 
		{
			fadingSpeed = -0.05;
			
			bitmap = new Image(GraphicsLoader.GetGraphics("hitoverlayer"));
			bitmap.scaleX = 2 * GraphicsLoader.ConversionRatio;
			bitmap.scaleY = 2 * GraphicsLoader.ConversionRatio;
			bitmap.alpha = 0;
			
			whiteFillingLeft = new Image(GraphicsLoader.GetGraphics("background"));
			whiteFillingLeft.scaleX = (GraphicsLoader.Width - GraphicsLoader.Height) / 2;
			whiteFillingLeft.scaleY = GraphicsLoader.Height;
			whiteFillingLeft.alpha = 0;
			whiteFillingLeft.x -= GraphicsLoader.Width / 2;
			whiteFillingLeft.y -= GraphicsLoader.Height / 2;
			
			whiteFillingRight = new Image(GraphicsLoader.GetGraphics("background"));
			whiteFillingRight.scaleX = (GraphicsLoader.Width - GraphicsLoader.Height) / 2;
			whiteFillingRight.scaleY = GraphicsLoader.Height;
			whiteFillingRight.alpha = 0;
			whiteFillingRight.x += GraphicsLoader.Width / 2 - whiteFillingRight.scaleX;
			whiteFillingRight.y -= GraphicsLoader.Height / 2;
			
			layer = LayerConstant.EFFECT_LAYER;
			
			CenterOO();
			x = GraphicsLoader.Width / 2;
			y = GraphicsLoader.Height / 2;
		}
		
		override public function Added():void 
		{
			super.Added();
			
			addChild(whiteFillingLeft);
			addChild(whiteFillingRight);
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			removeChild(whiteFillingLeft);
			removeChild(whiteFillingRight);
		}
		
		public function GotHit():void
		{
			bitmap.alpha = 0.4;
			whiteFillingLeft.alpha = bitmap.alpha;
			whiteFillingRight.alpha = bitmap.alpha;
		}
		
		override public function Update():void 
		{
			super.Update();
			
			bitmap.alpha += fadingSpeed;
			if (bitmap.alpha <= 0)
			{
				bitmap.alpha = 0;
			}
			whiteFillingLeft.alpha = bitmap.alpha;
			whiteFillingRight.alpha = bitmap.alpha;
		}
	}

}