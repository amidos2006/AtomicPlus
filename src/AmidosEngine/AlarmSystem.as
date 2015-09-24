package AmidosEngine 
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class AlarmSystem 
	{
		public static const FIXED_RATE:Number = 20;
		
		private static var runningAlarms:Vector.<Alarm>;
		
		public static function Intialize():void
		{
			runningAlarms = new Vector.<Alarm>();
		}
		
		public static function AddAlarm(alarm:Alarm, start:Boolean = false):void
		{
			runningAlarms.push(alarm);
			if (start)
			{
				alarm.Start();
			}
		}
		
		public static function RemoveAlarm(alarm:Alarm):void
		{
			for (var i:int = 0; i < runningAlarms.length; i++) 
			{
				if (runningAlarms[i] == alarm)
				{
					runningAlarms[i].StopAndRemove();
				}
			}
		}
		
		public static function Update():void
		{
			var deletedAlarms:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < runningAlarms.length; i++) 
			{
				runningAlarms[i].Update(FIXED_RATE);
				if (runningAlarms[i].IsStop())
				{
					if (runningAlarms[i].Type == Alarm.ONE_SHOT)
					{
						deletedAlarms.push(i);
					}
					else if (runningAlarms[i].Type == Alarm.LOOPING)
					{
						runningAlarms[i].Start();
					}
				}
			}
			
			for (var j:int = deletedAlarms.length - 1; j >= 0; j--) 
			{
				runningAlarms.splice(deletedAlarms[j], 1);
			}
		}
	}

}