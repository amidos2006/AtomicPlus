package 
{
	import AmidosEngine.*;
	import AtomicPlus.GameEntity.BackgroundEntity;
	import AtomicPlus.GameWorld.*;
	import AtomicPlus.Global;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import com.sticksports.nativeExtensions.SilentSwitch;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.Event;
	import starling.display.Image;
	import starling.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Amidos
	 */
	public class Main extends Sprite 
	{
		[Embed(source = "../assets/graphics/LoadingPictures/1024.png")]private var ipadClass:Class;
		[Embed(source = "../assets/graphics/LoadingPictures/1136.png")]private var iphone5Class:Class;
		[Embed(source = "../assets/graphics/LoadingPictures/960.png")]private var iphone4Class:Class;
		
		
		private const FRAME_RATE:Number = 100/3;
		
		private var timer:Timer;
		private var updateTimer:Timer;
		private var testingAlarm:Alarm;
		private var mStarling:Starling;
		
		public static var stopUpdating:Boolean;
		public static var fullScreenWidth:int;
		public static var fullScreenHeight:int;
		public static var currentStage:Stage;
		public static var currentLoadingScreen:Bitmap;
		
		public function Main():void 
		{
			Global.deviceOS = Capabilities.os.toLowerCase();
			
			stopUpdating = false;
			
			//enable the silent switch
			SilentSwitch.apply();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(flash.events.Event.ACTIVATE, activate);
			stage.addEventListener(flash.events.Event.DEACTIVATE, deactivate);
			
			// Handling the touch controls
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// intialize the game controllers
			fullScreenWidth = stage.fullScreenWidth;
			fullScreenHeight = stage.fullScreenHeight;
			
			//For Covering the loading
			if (Main.fullScreenWidth < 980)
			{
				currentLoadingScreen = new iphone4Class();
			}
			else if (Main.fullScreenWidth / Main.fullScreenHeight == 4 / 3)
			{
				currentLoadingScreen = new ipadClass();
			}
			else
			{
				currentLoadingScreen = new iphone5Class();
			}
			currentLoadingScreen.scaleX = fullScreenWidth / currentLoadingScreen.width;
			currentLoadingScreen.scaleY = fullScreenHeight / currentLoadingScreen.height;
			stage.addChild(currentLoadingScreen);
			
			currentStage = stage;
			
			Starling.handleLostContext = true;
			mStarling = new Starling(Engine, stage, new Rectangle(0, 0, fullScreenWidth, fullScreenHeight));
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, intialize);
			mStarling.stage.stageWidth = fullScreenWidth;
			mStarling.stage.stageHeight = fullScreenHeight;
			//mStarling.showStats = true;
			//mStarling.showStatsAt("right", "top");
			mStarling.start();
			
			// new to AIR? please read *carefully* the readme.txt files!
		}
		
		private function intialize(e:starling.events.Event):void
		{
			mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, intialize);
			
			TouchControl.Intialize();
			AlarmSystem.Intialize();
			Global.Intialize();
			Engine.Intialize();
			
			if (GameCenter.isSupported())
			{
				GameCenter.create(stage);
				if (GameCenter.gameCenter.isGameCenterAvailable())
				{
					GameCenter.gameCenter.authenticateLocalUser();
				}
			}
			
			Engine.nextWorld = new LoadingWorld();
		}
		
		public static function activate(e:flash.events.Event):void
		{
			stopUpdating = false;
			SoundLoader.GlobalVolume = 1;
		}
		
		public static function deactivate(e:flash.events.Event):void 
		{
			stopUpdating = true;
			SoundLoader.GlobalVolume = 0;
		}
	}
	
}