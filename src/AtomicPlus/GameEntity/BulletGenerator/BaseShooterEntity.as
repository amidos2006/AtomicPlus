package AtomicPlus.GameEntity.BulletGenerator 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.GraphicsLoader;
	import AtomicPlus.GameEntity.SquareSpawnerEntity;
	import AtomicPlus.Global;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BaseShooterEntity
	{	
		private const SHIFT_ANGLE:Number = 10;
		
		protected var spawnerList:Vector.<SpawnerEntity>;
		
		private var numberOfBurstShots:int;
		private var numberOfSpawner:int;
		private var numberOfBullets:int;
		private var bulletClass:Class;
		
		public function BaseShooterEntity(squareSpawner:SquareSpawnerEntity) 
		{
			spawnerList = new Vector.<SpawnerEntity>();
			
			numberOfSpawner = (int)(Global.GetaValue(ShooterNumberOfSpawner.values));
			do
			{
				bulletClass = (Class)(Global.GetaValue(BulletPath.values));
			}while (squareSpawner.GetCurrentSquareOrbit() == 0 && 
					(bulletClass == BulletPath.values[3] || bulletClass == BulletPath.values[2]));
			numberOfBurstShots = (int)(Global.GetaValue(SpawnerBurstNumber.values));
			numberOfBullets = (int)(Global.GetaValue(SpawnerNumberOfBullets.values));
			var squareAngle:Number = squareSpawner.GetSquareAngle();
			var shiftAngle:Number = 360 / numberOfSpawner;
			var intialAngle:Number = squareAngle + shiftAngle / 2 - SHIFT_ANGLE / 2 + Global.GetRandom(SHIFT_ANGLE);
			
			//starting must be away from the player start position
			if (Global.score == 0)
			{
				numberOfSpawner = 1;
				numberOfBurstShots = 1;
				numberOfBullets = 1;
				bulletClass = LinearBulletEntity;
				intialAngle = squareAngle + (2 * Global.GetRandom(2) - 1) * 30;
			}
			
			for (var i:int = 0; i < numberOfSpawner; i++) 
			{
				spawnerList.push(new SpawnerEntity((Global.CORE_RADIUS - Global.BULLET_RADIUS) * GraphicsLoader.ConversionRatio, 
									(intialAngle + i * 360.0 / numberOfSpawner) % 360));
				spawnerList[i].bulletClass = bulletClass;
				spawnerList[i].numberOfBurstShots = numberOfBurstShots;
				spawnerList[i].numberOfBullets = numberOfBullets;
			}
		}
		
		public function Shoot():void
		{
			for (var i:int = 0; i < spawnerList.length; i++) 
			{
				spawnerList[i].Shoot();
			}
		}
		
		public function GetDifficulty():int
		{
			return BulletPath.GetDiffculty(bulletClass) * ShooterNumberOfSpawner.GetDiffculty(numberOfSpawner) * 
					SpawnerNumberOfBullets.GetDiffculty(numberOfBullets) * SpawnerBurstNumber.GetDiffculty(numberOfBurstShots);
		}
		
		public function StopShooting():void
		{
			for (var i:int = 0; i < spawnerList.length; i++) 
			{
				spawnerList[i].Stop();
			}
		}
		
		public function SetRotationDirection(direction:int):void
		{
			for (var i:int = 0; i < spawnerList.length; i++) 
			{
				spawnerList[i].rotationDirection = direction;
			}
		}
	}

}