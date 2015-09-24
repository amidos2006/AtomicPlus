package AtomicPlus.GameEntity.BulletGenerator 
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class ShooterNumberOfSpawner 
	{
		public static var values:Array = [1, 2, 3, 4];
		public static var difficulties:Array = [1, 2, 3, 4];
		
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