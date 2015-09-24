package AtomicPlus.GameEntity 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.GraphicsLoader;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author Amidos
	 */
	public class OverlayerEntity extends BaseEntity
	{
		private var blackFillingLeft:Image;
		private var blackFillingRight:Image;
		
		public function OverlayerEntity() 
		{
			bitmap = new Image(GraphicsLoader.GetGraphics("overlayer"));
			bitmap.scaleX = 2 * GraphicsLoader.ConversionRatio;
			bitmap.scaleY = 2 * GraphicsLoader.ConversionRatio;
			bitmap.smoothing = TextureSmoothing.NONE;
			bitmap.blendMode = BlendMode.ERASE;
			bitmap.alpha = 0.3;
			
			blackFillingLeft = new Image(GraphicsLoader.GetGraphics("blackbackground"));
			blackFillingLeft.scaleX = (GraphicsLoader.Width - GraphicsLoader.Height) / 2;
			blackFillingLeft.scaleY = GraphicsLoader.Height;
			blackFillingLeft.blendMode = BlendMode.ERASE;
			blackFillingLeft.smoothing = TextureSmoothing.NONE;
			blackFillingLeft.alpha = 0.3;
			blackFillingLeft.x -= GraphicsLoader.Width / 2;
			blackFillingLeft.y -= GraphicsLoader.Height / 2;
			
			blackFillingRight = new Image(GraphicsLoader.GetGraphics("blackbackground"));
			blackFillingRight.scaleX = (GraphicsLoader.Width - GraphicsLoader.Height) / 2;
			blackFillingRight.scaleY = GraphicsLoader.Height;
			blackFillingRight.blendMode = BlendMode.ERASE;
			blackFillingRight.smoothing = TextureSmoothing.NONE;
			blackFillingRight.alpha = 0.3;
			blackFillingRight.x += GraphicsLoader.Width / 2 - blackFillingRight.scaleX;
			blackFillingRight.y -= GraphicsLoader.Height / 2;
			
			layer = LayerConstant.OVERLAYER_LAYER;
			
			CenterOO();
			x = GraphicsLoader.Width / 2;
			y = GraphicsLoader.Height / 2;
		}
		
		override public function Added():void 
		{
			super.Added();
			
			addChild(blackFillingLeft);
			addChild(blackFillingRight);
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			removeChild(blackFillingLeft);
			removeChild(blackFillingRight);
		}
	}

}