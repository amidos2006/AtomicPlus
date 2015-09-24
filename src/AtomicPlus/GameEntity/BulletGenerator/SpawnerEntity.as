package AtomicPlus.GameEntity.BulletGenerator 
{
	import AmidosEngine.Alarm;
	import AmidosEngine.AlarmSystem;
	import AmidosEngine.BaseEntity;
	import AmidosEngine.Engine;
	import AmidosEngine.GraphicsLoader;
	import AtomicPlus.Global;
	/**
	 * ...
	 * @author Amidos
	 */
	public class SpawnerEntity
	{
		private const SHIFT_ANGLE:int = 20;
		
		private var intialX:int;
		private var intialY:int;
		private var currentShots:int;
		
		private var burstFireAlarm:Alarm;
		
		public var currentRadius:Number;
		public var currentAngle:Number;
		public var bulletClass:Class;
		public var numberOfBurstShots:int;
		public var numberOfBullets:int;
		public var rotationDirection:int;
		
		public function SpawnerEntity(radius:int, angle:Number) 
		{
			intialX = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			intialY = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			currentRadius = radius;
			currentAngle = angle;
			
			currentShots = 0;
			
			burstFireAlarm = new Alarm(100, FireBullet, Alarm.PRESISTENT);
			AlarmSystem.AddAlarm(burstFireAlarm, false);
		}
		
		public function Shoot():void
		{
			currentShots = numberOfBurstShots;
			
			FireBullet();
		}
		
		public function Stop():void
		{
			AlarmSystem.RemoveAlarm(burstFireAlarm);
		}
		
		private function FireBullet():void
		{
			var tempAngle:Number = currentAngle;
			
			var x:Number = intialX + currentRadius * Math.cos(tempAngle * Math.PI / 180);
			var y:Number = intialY + currentRadius * Math.sin(tempAngle * Math.PI / 180);
			
			var bullet:BaseBulletEntity;
			if (numberOfBullets == 1)
			{
				bullet = new bulletClass(Math.floor(x), Math.floor(y), tempAngle);
				bullet.rotationDirection = rotationDirection;
				Engine.currentWorld.AddEntity(bullet);
			}
			else
			{
				var angleShift:Number = SHIFT_ANGLE / (numberOfBullets - 1);
				for (var i:int = 0; i < numberOfBullets; i++) 
				{
					bullet = new bulletClass(Math.floor(x), Math.floor(y), tempAngle - SHIFT_ANGLE / 2 + i * angleShift);
					bullet.rotationDirection = rotationDirection;
					Engine.currentWorld.AddEntity(bullet);
				}
			}
			
			currentShots -= 1;
			if (currentShots > 0)
			{
				burstFireAlarm.Start();
			}
		}
	}

}