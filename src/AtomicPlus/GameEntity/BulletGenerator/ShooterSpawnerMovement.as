package AtomicPlus.GameEntity.BulletGenerator 
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class ShooterSpawnerMovement 
	{
		public static var values:Array = [ConstantShooterEntity, SpiralShooterEntity, FixedSpiralShooterEntity];
		public static var difficulties:Array = [0, 5, 5];
		
		public static function GetDiffculty(value:Class):Number
		{
			for (var i:int = 0; i < values.length; i++) 
			{
				if (value == values[i])
				{
					return difficulties[i];
				}
			}
			
			return 0;
		}
	}

}