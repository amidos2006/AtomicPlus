package AtomicPlus.GameEntity.BulletGenerator 
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class ShooterRateOfShooting 
	{
		public static var values:Array = [800, 750, 700, 650, 600];
		public static var difficulties:Array = [1, 1, 1.25, 1.25, 1.5];
		
		public static function GetDiffculty(value:int):Number
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