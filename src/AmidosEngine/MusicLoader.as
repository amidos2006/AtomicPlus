package AmidosEngine 
{
	import AtomicPlus.Global;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MusicLoader 
	{
		private static const MIN_NUM_RUNS:int = 3;
		private static const MAX_NUM_RUNS:int = 6;
		
		[Embed(source = "../../assets/sound/AtomicPlusTrack1_3.mp3")]private static var track1Music:Class;
		[Embed(source="../../assets/sound/AtomicPlusTrack2_6.mp3")]private static var track2Music:Class;
		[Embed(source = "../../assets/sound/AtomicPlusTrack4_3.mp3")]private static var track3Music:Class;
		
		private static var musicVolume:Number;
		
		private static var musicList:Vector.<Sfx>;
		private static var runningTrackID:int;
		
		private static var currentRun:int;
		private static var musicShift:int;
		private static var maxRuns:int;
		
		public static function get MusicVolume():Number
		{
			return musicVolume;
		}
		public static function set MusicVolume(value:Number):void
		{
			musicVolume = value;
			if (runningTrackID != -1)
			{
				musicList[runningTrackID].volume = musicVolume;
			}
		}
		
		public static function Intialize():void
		{
			runningTrackID = -1;
			musicVolume = 1;
			musicList = new Vector.<Sfx>();
			
			currentRun = -1;
			musicShift = 0;
			maxRuns = MIN_NUM_RUNS + Global.GetRandom(MAX_NUM_RUNS - MIN_NUM_RUNS);
			
			musicList.push(new Sfx(track1Music));
			musicList.push(new Sfx(track2Music));
			musicList.push(new Sfx(track3Music));
		}
		
		public static function PlayMusic(trackNumber:int, reset:Boolean = false):void
		{
			if (runningTrackID != trackNumber || reset)
			{
				currentRun += 1;
				if (currentRun >= maxRuns)
				{
					currentRun = 0;
					musicShift = (musicShift + Global.GetRandom(musicList.length - 1) + 1) % musicList.length;
					maxRuns = MIN_NUM_RUNS + Global.GetRandom(MAX_NUM_RUNS - MIN_NUM_RUNS);
				}
				
				runningTrackID = (trackNumber + musicShift) % musicList.length;
				musicList[runningTrackID].loop(musicVolume);
			}
		}
		
		public static function StopRunningMusic():void
		{
			if (runningTrackID != -1)
			{
				musicList[runningTrackID].stop();
				runningTrackID = -1;
			}
		}
	}

}