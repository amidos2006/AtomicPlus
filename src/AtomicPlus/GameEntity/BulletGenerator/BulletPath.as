package AtomicPlus.GameEntity.BulletGenerator 
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class BulletPath
	{
		public static var values:Array = [LinearBulletEntity, SinBulletEntity, CircularBulletEntity, RotationalBulletEntity];
		public static var difficulties:Array = [1, 2, 2.5, 2.5];
		
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