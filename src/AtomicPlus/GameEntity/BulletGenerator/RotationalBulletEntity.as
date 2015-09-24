package AtomicPlus.GameEntity.BulletGenerator 
{
	import AmidosEngine.GraphicsLoader;
	/**
	 * ...
	 * @author Amidos
	 */
	public class RotationalBulletEntity extends BaseBulletEntity
	{	
		private const RADIAL_SPEED:Number = 5;
		private const ANGLE_SPEED:Number = 6;
		
		private var currentRadius:Number;
		private var currentAngle:Number;
		
		private var xIntial:Number;
		private var yIntial:Number;
		
		public function RotationalBulletEntity(xIn:Number, yIn:Number, angle:Number) 
		{
			super(xIn, yIn);
			
			xIntial = xIn;
			yIntial = yIn;
			
			currentAngle = angle;
			currentRadius = 0;
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