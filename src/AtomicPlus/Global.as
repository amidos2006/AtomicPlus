package AtomicPlus 
{
	import AmidosEngine.Data;
	import AmidosEngine.GraphicsLoader;
	import AtomicPlus.GameEntity.PlayerEntity;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Global 
	{
		public static const STROKE_THICKNESS:int = 4;
		public static const CORE_RADIUS:int = 70;
		public static const PLAYER_RADIUS:int = 18;
		public static const BULLET_RADIUS:int = 8;
		public static const BUTTON_RADIUS:int = 30;
		public static const BOX_LENGTH:int = 35;
		
		public static const MIN_RADIUS:int = 120;
		public static const MAX_RADIUS:int = 340;
		public static const NUMBER_OF_ORBITS:int = 4;
		public static const NUMBER_OF_LINES:int = 12;
		public static const LINE_THICKNESS:int = 15;
		
		public static const CENTER_SHIFT_X:int = 0;
		public static const CENTER_SHIFT_Y:int = -30;
		
		public static const SAVE_FILE:String = "AtomicPlusSaveFile";
		public static const OST_LINK:URLRequest = new URLRequest("http://agentwhiskers.bandcamp.com/album/atomic");
		
		public static var deviceOS:String;
		public static var score:int;
		public static var bestScore:Array;
		public static var gameplayType:int;
		public static var gameDifficulty:int;
		public static var playerEntity:PlayerEntity;
		public static var firstRun:Boolean;
		
		//private static var colors:Array = [0xFF7AA8CC, 0xFFB075FF, 0xFFFF5171, 0xFFFF935E, 0xFFABD856, 0xFF77CEBD];
		private static var colors:Array = [0xFF5196CC, 0xFF8D3DFF, 0xFFFF1947, 0xFFFF6A26, 0xFF9DD62A, 0xFF47CCB1];
		private static var currentColor:int;
		
		public static function Intialize():void
		{
			currentColor = 2;
			
			score = 0;
			gameplayType = GameplayType.AUTO;
			gameDifficulty = GameDifficulty.EASY;
			playerEntity = null;
			firstRun = true;
			
			bestScore = new Array();
			LoadBestScore();
		}
		
		public static function GetRandom(max:int):int
		{
			return Math.floor(Math.random() * max);
		}
		
		public static function ChangeRandomColor():void
		{
			currentColor = (currentColor + GetRandom(colors.length - 1) + 1) % colors.length;
		}
		
		public static function GetaValue(values:Array):Object
		{
			return values[GetRandom(values.length)];
		}
		
		public static function GetCurrentColor():uint
		{
			return colors[currentColor];
		}
		
		public static function GetCurrentColorNumber():int
		{
			return currentColor;
		}
		
		public static function GetColor(number:int):uint
		{
			return colors[number];
		}
		
		public static function GetNumberOfColors():int
		{
			return colors.length;
		}
		
		public static function GetCurrentOrbitRadius(number:int):Number
		{
			if (number < 0)
			{
				return MIN_RADIUS;
			}
			
			if (number >= NUMBER_OF_ORBITS)
			{
				return MAX_RADIUS;
			}
			
			return MIN_RADIUS + (number) * (MAX_RADIUS - MIN_RADIUS) / (NUMBER_OF_ORBITS - 1);
		}
		
		public static function GetLeaderboardName():String
		{
			var leaderBoardName:String = "";
			switch (gameplayType) 
			{
				case GameplayType.AUTO:
					leaderBoardName += "auto";
					break;
				case GameplayType.MANUAL:
					leaderBoardName += "manual";
					break;
				case GameplayType.FULL:
					leaderBoardName += "full";
					break;
				case GameplayType.MANUALFULL:
					leaderBoardName += "fullplus";
					break;
			}
			
			leaderBoardName += "_";
			
			switch (gameDifficulty) 
			{
				case GameDifficulty.EASY:
					leaderBoardName += "normal";
					break;
				case GameDifficulty.HARD:
					leaderBoardName += "hardcore";
					break;
			}
			
			return leaderBoardName;
		}
		
		public static function SaveBestScore():void
		{
			for (var i:int = 0; i <= GameplayType.MANUALFULL; i++) 
			{
				for (var j:int = 0; j <= GameDifficulty.HARD; j++) 
				{
					Data.writeInt("bestScore" + i.toString() + j.toString(), bestScore[i.toString() + j.toString()]);
				}
			}
			Data.save(SAVE_FILE);
		}
		
		public static function LoadBestScore():void
		{
			Data.load(SAVE_FILE);
			
			for (var i:int = 0; i <= GameplayType.MANUALFULL; i++) 
			{
				for (var j:int = 0; j <= GameDifficulty.HARD; j++) 
				{
					bestScore[i.toString() + j.toString()] = Data.readInt("bestScore" + i.toString() + j.toString(), 0);
				}
			}
			
		}
		
		public static function IsiPhone4(height:Number = 0):Boolean
		{
			if (height != 0)
			{
				return height <= 980;
			}
			
			return GraphicsLoader.Width <= 980;
		}
	}

}