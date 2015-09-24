package AtomicPlus.GameEntity 
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class DiffcultyCurve 
	{
		private static var difficultyChange:Array = [5, 10, 15, 20, 30, 40, 50, 70];
		private static var difficultyHigh:Array = [3, 5, 7, 8, 10, 15, 20, 100];
		private static var difficultyLow:Array = [0, 0, 3, 4, 6, 8, 12, 17];
		
		private static function GetDifficultyIndex(playerScore:int):int
		{
			for (var i:int = 0; i < difficultyChange.length; i++) 
			{
				if (playerScore < difficultyChange[i])
				{
					return i;
				}
			}
			
			return difficultyChange.length - 1;
		}
		
		public static function CorrectDifficulty(playerScore:int, diff:int):Boolean
		{
			var currentDiffIndex:int = GetDifficultyIndex(playerScore);
			
			return diff <= difficultyHigh[currentDiffIndex] && diff >= difficultyLow[currentDiffIndex];
		}
	}

}