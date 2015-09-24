package AtomicPlus.GameEntity.BulletGenerator 
{
	import AmidosEngine.GraphicsLoader;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Amidos
	 */
	public class SinBulletEntity extends BaseBulletEntity
	{
		private const SPEED:Number = 7;
		private const DISTANCE:Number = 30;
		
		private var xSpeed:Number;
		private var ySpeed:Number;
		
		private var xIntial:Number;
		private var yIntial:Number;
		
		private var xNormal:Number;
		private var yNormal:Number;
		
		private var xLinear:Number;
		private var yLinear:Number;
		
		public function SinBulletEntity(xIn:Number, yIn:Number, angle:Number) 
		{
			super(xIn, yIn);
			
			xIntial = xIn;
			yIntial = yIn;
			
			xNormal = Math.sin((angle) * Math.PI / 180);
			yNormal = Math.cos((angle) * Math.PI / 180);
			
			xSpeed = SPEED * GraphicsLoader.ConversionRatio * Math.cos(angle * Math.PI / 180);
			ySpeed = SPEED * GraphicsLoader.ConversionRatio * Math.sin(angle * Math.PI / 180);
			
			xLinear = xIn;
			yLinear = yIn;
		}
		
		override public function Update():void 
		{
			xLinear += xSpeed;
			yLinear += ySpeed;
			
			var distance:Number = Point.distance(new Point(xIntial, yIntial), new Point(xLinear, yLinear));
			var sinValue:Number = DISTANCE * GraphicsLoader.ConversionRatio * Math.sin(distance * 2 * Math.PI / 180);
			
			x = xLinear + xNormal * sinValue;
			y = yLinear + yNormal * sinValue;
			
			super.Update();
		}
	}

}