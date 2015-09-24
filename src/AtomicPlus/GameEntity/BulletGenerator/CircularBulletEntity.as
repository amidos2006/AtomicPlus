package AtomicPlus.GameEntity.BulletGenerator 
{
	import AmidosEngine.GraphicsLoader;
	import AtomicPlus.Global;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Amidos
	 */
	public class CircularBulletEntity extends BaseBulletEntity
	{	
		private const RADIAL_SPEED:Number = 5;
		private const ANGLE_SPEED:Number = 6;
		
		private var currentRadius:Number;
		private var currentAngle:Number;
		
		private var xIntial:Number;
		private var yIntial:Number;
		
		public function CircularBulletEntity(xIn:Number, yIn:Number, angle:Number) 
		{
			super(xIn, yIn);
			
			xIntial = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			yIntial = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			currentAngle = angle;
			currentRadius = Point.distance(new Point(xIn, yIn), new Point(xIntial, yIntial));
		}
		
		override public function Update():void 
		{
			currentRadius += RADIAL_SPEED;
			currentAngle += rotationDirection * ANGLE_SPEED;
			
			x = xIntial + currentRadius * GraphicsLoader.ConversionRatio * Math.cos(currentAngle * Math.PI / 180);
			y = yIntial + currentRadius * GraphicsLoader.ConversionRatio * Math.sin(currentAngle * Math.PI / 180);
			
			super.Update();
		}
	}

}