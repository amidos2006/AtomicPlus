package AmidosEngine 
{
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Amidos
	 */
	public class SoundLoader 
	{
		[Embed(source = "../../assets/sound/Back.mp3")]private static var backClass:Class;
		[Embed(source = "../../assets/sound/Box.mp3")]private static var boxClass:Class;
		[Embed(source = "../../assets/sound/ChangeSelection.mp3")]private static var changeSelectionClass:Class;
		[Embed(source = "../../assets/sound/Explosion.mp3")]private static var explosionClass:Class;
		[Embed(source = "../../assets/sound/Help.mp3")]private static var helpClass:Class;
		[Embed(source = "../../assets/sound/GameCenter.mp3")]private static var gamecenterClass:Class;
		[Embed(source = "../../assets/sound/OST.mp3")]private static var ostClass:Class;
		[Embed(source = "../../assets/sound/Hit.mp3")]private static var hitLowClass:Class;
		[Embed(source = "../../assets/sound/Hit2.mp3")]private static var hitHighClass:Class;
		[Embed(source = "../../assets/sound/Selected.mp3")]private static var selectedClass:Class;
		[Embed(source = "../../assets/sound/Shooting.mp3")]private static var shootingClass:Class;
		
		private static var soundList:Array;
		
		private static var globalVolume:Number;
		private static var soundTransform:SoundTransform;
		
		public static function Intialize():void
		{
			soundTransform = new SoundTransform();
			globalVolume = 1;
			
			soundList = new Array();
			
			soundList["back"] = backClass;
			soundList["box"] = boxClass;
			soundList["changeselection"] = changeSelectionClass;
			soundList["explosion"] = explosionClass;
			soundList["help"] = helpClass;
			soundList["gamecenter"] = gamecenterClass;
			soundList["ost"] = ostClass;
			soundList["hitlow"] = hitLowClass;
			soundList["hithigh"] = hitHighClass;
			soundList["selected"] = selectedClass;
			soundList["shooting"] = shootingClass;
		}
		
		/**
		 * Global volume factor for all sounds, a value from 0 to 1.
		 */
		public static function get GlobalVolume():Number { return globalVolume; }
		public static function set GlobalVolume(value:Number):void
		{
			if (soundTransform == null)
			{
				return;
			}
			if (value < 0) value = 0;
			if (globalVolume == value) return;
			soundTransform.volume = globalVolume = value;
			SoundMixer.soundTransform = soundTransform;
		}
		
		public static function GetSound(name:String):Class
		{
			return soundList[name.toLowerCase()];
		}
	}

}