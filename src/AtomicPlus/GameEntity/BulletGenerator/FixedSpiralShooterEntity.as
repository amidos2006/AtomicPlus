package AtomicPlus.GameEntity.BulletGenerator 
{
	import AtomicPlus.GameEntity.SquareSpawnerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class FixedSpiralShooterEntity extends BaseShooterEntity
	{
		private const ORBITAL_SPEED:Number = 10;
		private const MAX_ANGLE:Number = 45;
		
		private var shiftAngle:Number;
		private var direction:int;
		
		public function FixedSpiralShooterEntity(squareSpawner:SquareSpawnerEntity) 
		{
			super(squareSpawner);
			
			shiftAngle = 0;
			direction = 1;
		}
		
		override public function Shoot():void 
		{
			shiftAngle += ORBITAL_SPEED;
			if (shiftAngle >= MAX_ANGLE)
			{
				direction *= -1;
				shiftAngle -= MAX_ANGLE;
			}
			
			for (var i:int = 0; i < spawnerList.length; i++) 
			{
				spawnerList[i].currentAngle = (spawnerList[i].currentAngle + direction * ORBITAL_SPEED) % 360;
			}
			
			super.Shoot();
		}
	}

}