package AtomicPlus.GameEntity.BulletGenerator 
{
	import AmidosEngine.GraphicsLoader;
	/**
	 * ...
	 * @author Amidos
	 */
	public class LinearBulletEntity extends BaseBulletEntity
	{
		private const SPEED:Number = 9;
		
		private var xSpeed:Number;
		private var ySpeed:Number;
		
		public function LinearBulletEntity(xIn:Number, yIn:Number, angle:Number) 
		{
			super(xIn, yIn);
			
			xSpeed = SPEED * GraphicsLoader.ConversionRatio * Math.cos(angle * Math.PI / 180);
			ySpeed = SPEED * GraphicsLoader.ConversionRatio * Math.sin(angle * Math.PI / 180);
		}
		
		override public function Update():void 
		{
			x += xSpeed;
			y += ySpeed;
			
			super.Update();
		}
	}

}