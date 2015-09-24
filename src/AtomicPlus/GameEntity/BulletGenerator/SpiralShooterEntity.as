package AtomicPlus.GameEntity.BulletGenerator 
{
	import AtomicPlus.GameEntity.SquareSpawnerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class SpiralShooterEntity extends BaseShooterEntity
	{
		private const ORBITAL_SPEED:Number = 10;
		
		public function SpiralShooterEntity(squareSpawner:SquareSpawnerEntity) 
		{
			super(squareSpawner);
		}
		
		override public function Shoot():void
		{
			for (var i:int = 0; i < spawnerList.length; i++) 
			{
				spawnerList[i].currentAngle = (spawnerList[i].currentAngle + ORBITAL_SPEED) % 360;
			}
			
			super.Shoot();
		}
	}

}