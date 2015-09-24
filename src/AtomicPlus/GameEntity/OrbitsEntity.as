package AtomicPlus.GameEntity 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.GraphicsLoader;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class OrbitsEntity extends BaseEntity
	{
		public static const LARGE:String = "large";
		public static const SMALL:String = "small";
		
		private var rotationSpeed:Number;
		
		public function OrbitsEntity(orbitSize:String) 
		{
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			rotationSpeed = 4 * Math.PI / 360;
			if (orbitSize == SMALL)
			{
				rotationSpeed *= -1;
				rotation = 15;
			}
			
			bitmap = new Image(GraphicsLoader.GetGraphics(orbitSize + "orbits"));
			bitmap.alpha = 0.12;
			bitmap.blendMode = starling.display.BlendMode.ERASE;
			CenterOO();
			
			layer = LayerConstant.ORBIT_LAYER;
		}
		
		override public function Update():void 
		{
			super.Update();
			
			rotation += rotationSpeed;
		}
	}

}