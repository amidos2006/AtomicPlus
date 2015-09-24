package AmidosEngine 
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class Alarm 
	{
		public static const ONE_SHOT:int = 0;
		public static const PRESISTENT:int = 1;
		public static const LOOPING:int = 2;
		
		private const STOP:int = 0;
		private const PLAY:int = 1;
		private const PAUSE:int = 2;
		
		private var state:int;
		
		public var CurrentDelay:Number;
		public var TotalDelay:Number;
		public var FinishFunction:Function;
		public var Type:int;
		public var isDead:Boolean;
		
		public function Alarm(amount:Number, endFunction:Function, type:int = 0) 
		{
			state = STOP;
			
			CurrentDelay = amount;
			TotalDelay = amount;
			FinishFunction = endFunction;
			Type = type;
			
			isDead = false;
		}
		
		public function ChangeTime(amount:Number):void
		{
			TotalDelay = amount;
		}
		
		public function Start(reset:Boolean = false):void
		{
			if (reset || state == STOP)
			{
				CurrentDelay = TotalDelay;
			}
			state = PLAY;
		}
		
		public function Pause():void
		{
			state = PAUSE;
		}
		
		public function StopAndRemove():void
		{
			state = STOP;
			Type = ONE_SHOT;
		}
		
		public function IsRunning():Boolean
		{
			return state == PLAY;
		}
		
		public function IsStop():Boolean 
		{
			return state == STOP;
		}
		
		public function IsPaused():Boolean
		{
			return state == PAUSE;
		}
		
		public function Update(updateTime:Number):void
		{
			if (state != PLAY)
			{
				return;
			}
			
			CurrentDelay -= updateTime;
			if (CurrentDelay <= 0)
			{
				state = STOP;
				FinishFunction();
			}
		}
	}

}