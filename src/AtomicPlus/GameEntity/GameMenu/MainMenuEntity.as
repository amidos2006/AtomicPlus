package AtomicPlus.GameEntity.GameMenu 
{
	import AmidosEngine.Alarm;
	import AmidosEngine.AlarmSystem;
	import AmidosEngine.BaseEntity;
	import AmidosEngine.Engine;
	import AmidosEngine.GraphicsLoader;
	import AmidosEngine.HitBoxDrawer;
	import AmidosEngine.Sfx;
	import AmidosEngine.SoundLoader;
	import AmidosEngine.Text;
	import AmidosEngine.TouchControl;
	import AtomicPlus.GameDifficulty;
	import AtomicPlus.GameEntity.BackgroundEntity;
	import AtomicPlus.GameplayType;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.sampler.NewObjectSample;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MainMenuEntity extends BaseEntity
	{
		private const X_SHIFT:int = 4;
		private const Y_SHIFT:int = -2;
		
		private var backgroundEntity:BackgroundEntity;
		private var menuCoreEntity:MenuCoreEntity;
		
		private var gameplayText:Text;
		private var gamePlayModeText:Vector.<Text>;
		private var descriptionText:Vector.<Text>;
		private var touchToSelectText:Text;
		private var creditsText:Text;
		private var selectedMode:int;
		private var flickerAlarm:Alarm;
		private var leftArrowEntity:ArrowButtonEntity;
		private var rightArrowEntity:ArrowButtonEntity;
		private var xButtonEntity:XButtonEntity;
		private var gameCenterButtonEntity:ImageButtonEntity;
		private var getOSTButtonEntity:ImageButtonEntity;
		private var questionButtonEntity:QuestionButtonEntity;
		private var touchPoints:Vector.<Point>;
		
		private var changeSelectedSfx:Sfx;
		private var selectSfx:Sfx;
		private var backSfx:Sfx;
		private var helpSfx:Sfx;
		private var gamecenterSfx:Sfx;
		private var ostSfx:Sfx;
		
		public function MainMenuEntity(background:BackgroundEntity, menuCore:MenuCoreEntity) 
		{
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			backgroundEntity = background;
			menuCoreEntity = menuCore;
			selectedMode = Global.gameplayType;
			
			changeSelectedSfx = new Sfx(SoundLoader.GetSound("changeselection"));
			selectSfx = new Sfx(SoundLoader.GetSound("selected"));
			backSfx = new Sfx(SoundLoader.GetSound("back"));
			helpSfx = new Sfx(SoundLoader.GetSound("help"));
			gamecenterSfx = new Sfx(SoundLoader.GetSound("gamecenter"));
			ostSfx = new Sfx(SoundLoader.GetSound("ost"));
			
			gameplayText = new Text("control mode", background.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			gameplayText.CenterOO();
			gameplayText.y -= (Text.LARGE_FONT / 2 + Y_SHIFT) * GraphicsLoader.ConversionRatio;
			
			touchToSelectText = new Text("touch center to select", 0xFFFFFF, Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			touchToSelectText.CenterOO();
			touchToSelectText.y = (Global.GetCurrentOrbitRadius(1) + 80) * GraphicsLoader.ConversionRatio;
			
			creditsText = new Text("game by amidos\nmusic by agent whiskers", 0xFFFFFF, Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			creditsText.CenterOO();
			creditsText.y += GraphicsLoader.Height / 2 - (Global.CENTER_SHIFT_Y + Text.SMALL_FONT) * GraphicsLoader.ConversionRatio;
			
			gamePlayModeText = new Vector.<Text>();
			descriptionText = new Vector.<Text>();
			
			var text:Text = new Text("auto", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.x += X_SHIFT * GraphicsLoader.ConversionRatio;
			text.y -= Y_SHIFT * GraphicsLoader.ConversionRatio;
			text.alpha = 0;
			gamePlayModeText.push(text);
			
			text = new Text("touch = radius", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.y = gamePlayModeText[0].y + (Text.LARGE_FONT / 2) * GraphicsLoader.ConversionRatio;
			text.alpha = 0;
			descriptionText.push(text);
			
			text = new Text("manual", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.x += X_SHIFT * GraphicsLoader.ConversionRatio;
			text.y = gamePlayModeText[0].y;
			text.alpha = 0;
			gamePlayModeText.push(text);
			
			text = new Text("touch right = inc radius\ntouch left = dec radius", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.y = descriptionText[0].y + (11) * GraphicsLoader.ConversionRatio;
			text.alpha = 0;
			descriptionText.push(text);
			
			text = new Text("full", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.x += X_SHIFT * GraphicsLoader.ConversionRatio;
			text.y = gamePlayModeText[0].y;
			text.alpha = 0;
			gamePlayModeText.push(text);
			
			text = new Text("touch right = radius\ntouch left = direction", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.y = descriptionText[0].y + (11) * GraphicsLoader.ConversionRatio;
			text.alpha = 0;
			descriptionText.push(text);
			
			text = new Text("full+", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.x += X_SHIFT * GraphicsLoader.ConversionRatio;
			text.y = gamePlayModeText[0].y;
			text.alpha = 0;
			gamePlayModeText.push(text);
			
			text = new Text("touch right = inc radius\ntouch left = dec radius\nboth = direction", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.y = descriptionText[0].y + (28) * GraphicsLoader.ConversionRatio;
			text.alpha = 0;
			descriptionText.push(text);
			
			//text = new Text("orbital", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			//text.CenterOO();
			//text.x += X_SHIFT * GraphicsLoader.ConversionRatio;
			//text.y = gamePlayModeText[0].y;
			//text.alpha = 0;
			//gamePlayModeText.push(text);
			//
			//text = new Text("touch = direction", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			//text.CenterOO();
			//text.y = descriptionText[0].y;
			//text.alpha = 0;
			//descriptionText.push(text);
			//
			//text = new Text("fixer", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			//text.CenterOO();
			//text.x += X_SHIFT * GraphicsLoader.ConversionRatio;
			//text.y = gamePlayModeText[0].y;
			//text.alpha = 0;
			//gamePlayModeText.push(text);
			//
			//text = new Text("touch = fix radius", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			//text.CenterOO();
			//text.y = descriptionText[0].y;
			//text.alpha = 0;
			//descriptionText.push(text);
			//
			//text = new Text("radiofixer", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			//text.CenterOO();
			//text.x += X_SHIFT * GraphicsLoader.ConversionRatio;
			//text.y = gamePlayModeText[0].y;
			//text.alpha = 0;
			//gamePlayModeText.push(text);
			//
			//text = new Text("touch right = radius\ntouch left = fix radius", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			//text.CenterOO();
			//text.y = descriptionText[0].y + (11) * GraphicsLoader.ConversionRatio;
			//text.alpha = 0;
			//descriptionText.push(text);
			//
			//text = new Text("fixorbital", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			//text.CenterOO();
			//text.x += X_SHIFT * GraphicsLoader.ConversionRatio;
			//text.y = gamePlayModeText[0].y;
			//text.alpha = 0;
			//gamePlayModeText.push(text);
			//
			//text = new Text("touch right = fix radius\ntouch left = direction", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			//text.CenterOO();
			//text.y = descriptionText[0].y + (11) * GraphicsLoader.ConversionRatio;
			//text.alpha = 0;
			//descriptionText.push(text);
			//
			//text = new Text("discone", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			//text.CenterOO();
			//text.x += X_SHIFT * GraphicsLoader.ConversionRatio;
			//text.y = gamePlayModeText[0].y;
			//text.alpha = 0;
			//gamePlayModeText.push(text);
			//
			//text = new Text("touch = change orbit", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			//text.CenterOO();
			//text.alpha = 0;
			//text.y = descriptionText[0].y;
			//descriptionText.push(text);
			//
			//text = new Text("discrete", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			//text.CenterOO();
			//text.x += X_SHIFT * GraphicsLoader.ConversionRatio;
			//text.y = gamePlayModeText[0].y;
			//text.alpha = 0;
			//gamePlayModeText.push(text);
			//
			//text = new Text("touch right = inc orbit\ntouch left = dec orbit", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			//text.CenterOO();
			//text.y = descriptionText[0].y + (11) * GraphicsLoader.ConversionRatio;
			//text.alpha = 0;
			//descriptionText.push(text);
			
			var distanceAway:Number = (Global.GetCurrentOrbitRadius(3)) * GraphicsLoader.ConversionRatio;
			leftArrowEntity = new ArrowButtonEntity(GraphicsLoader.Width / 2 - distanceAway + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio, 
														GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio, 
														backgroundEntity, ArrowButtonEntity.LEFT, ChangeSelectionLeft);
			rightArrowEntity = new ArrowButtonEntity(GraphicsLoader.Width / 2 + distanceAway + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio, 
														GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio, 
														backgroundEntity, ArrowButtonEntity.RIGHT, ChangeSelectionRight);
			xButtonEntity = new XButtonEntity(Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, BackFunction);
			questionButtonEntity = new QuestionButtonEntity(GraphicsLoader.Width - (Text.LARGE_FONT / 2 - 5) * GraphicsLoader.ConversionRatio, Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, HelpFunction);
			gameCenterButtonEntity = new ImageButtonEntity(GraphicsLoader.Width - (Text.LARGE_FONT / 2) * GraphicsLoader.ConversionRatio, GraphicsLoader.Height - (Text.LARGE_FONT / 2) * GraphicsLoader.ConversionRatio, "gamecenter", GameCenterFunction);
			getOSTButtonEntity = new ImageButtonEntity((Text.LARGE_FONT / 2) * GraphicsLoader.ConversionRatio, GraphicsLoader.Height - (Text.LARGE_FONT / 2) * GraphicsLoader.ConversionRatio, "getost", OSTFunction);
			
			flickerAlarm = new Alarm(400, Flicker, Alarm.LOOPING);
			
			layer = LayerConstant.HUD_LAYER;
			
			SetHitBox(2 * (Global.GetCurrentOrbitRadius(1) + 30) * GraphicsLoader.ConversionRatio, 
						2 * (Global.GetCurrentOrbitRadius(1) + 30) * GraphicsLoader.ConversionRatio, 
						-(Global.GetCurrentOrbitRadius(1) + 30) * GraphicsLoader.ConversionRatio, 
						-(Global.GetCurrentOrbitRadius(1) + 30) * GraphicsLoader.ConversionRatio);
		}
		
		private function Flicker():void
		{
			touchToSelectText.alpha = 1 - touchToSelectText.alpha;
		}
		
		override public function Added():void 
		{
			super.Added();
			
			gameplayText.Added();
			addChild(gameplayText);
			
			for (var i:int = 0; i < gamePlayModeText.length; i++) 
			{
				gamePlayModeText[i].Added();
				addChild(gamePlayModeText[i]);
			}
			
			for (var j:int = 0; j < descriptionText.length; j++) 
			{
				descriptionText[j].Added();
				addChild(descriptionText[j]);
			}
			
			touchToSelectText.Added();
			addChild(touchToSelectText);
			
			creditsText.Added();
			addChild(creditsText);
			
			AlarmSystem.AddAlarm(flickerAlarm, true);
			
			Engine.currentWorld.AddEntity(leftArrowEntity);
			Engine.currentWorld.AddEntity(rightArrowEntity);
			Engine.currentWorld.AddEntity(xButtonEntity);
			Engine.currentWorld.AddEntity(questionButtonEntity);
			if (GameCenter.isSupported() && GameCenter.gameCenter.isGameCenterAvailable())
			{
				Engine.currentWorld.AddEntity(gameCenterButtonEntity);
			}
			Engine.currentWorld.AddEntity(getOSTButtonEntity);
			
			RenderMissingFrame();
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			gameplayText.Removed();
			removeChild(gameplayText);
			
			for (var i:int = 0; i < gamePlayModeText.length; i++) 
			{
				gamePlayModeText[i].Removed();
				removeChild(gamePlayModeText[i]);
			}
			
			for (var j:int = 0; j < descriptionText.length; j++) 
			{
				descriptionText[j].Removed();
				removeChild(descriptionText[j]);
			}
			
			touchToSelectText.Removed();
			removeChild(touchToSelectText);
			
			creditsText.Removed();
			removeChild(creditsText);
			
			AlarmSystem.RemoveAlarm(flickerAlarm);
			
			Engine.currentWorld.RemoveEntity(leftArrowEntity);
			Engine.currentWorld.RemoveEntity(rightArrowEntity);
			Engine.currentWorld.RemoveEntity(xButtonEntity);
			Engine.currentWorld.RemoveEntity(questionButtonEntity);
			if (GameCenter.isSupported() && GameCenter.gameCenter.isGameCenterAvailable())
			{
				Engine.currentWorld.RemoveEntity(gameCenterButtonEntity);
			}
			Engine.currentWorld.RemoveEntity(getOSTButtonEntity);
		}
		
		private function ChangeSelection():void
		{
			backgroundEntity.ChangeBackgroundColor();
			Global.gameplayType = selectedMode;
			changeSelectedSfx.play();
		}
		
		private function ChangeSelectionLeft():void
		{
			selectedMode -= 1;
			if (selectedMode < 0)
			{
				selectedMode = gamePlayModeText.length - 1;
			}
			ChangeSelection();
		}
		
		private function ChangeSelectionRight():void
		{
			selectedMode += 1;
			if (selectedMode >= gamePlayModeText.length)
			{
				selectedMode = 0;
			}
			ChangeSelection();
		}
		
		public function BackFunction():void
		{
			backSfx.play();
			Engine.currentWorld.RemoveEntity(this);
			menuCoreEntity.Shrink(null);
			Engine.currentWorld.AddEntity(new AtomicPlusEntity(backgroundEntity, menuCoreEntity));
		}
		
		private function ModeSelected():void
		{
			backgroundEntity.ChangeBackgroundColor();
			Global.gameDifficulty = GameDifficulty.EASY;
			selectSfx.play();
			Engine.currentWorld.RemoveEntity(this);
			Engine.currentWorld.AddEntity(new DifficultyMenuEntity(backgroundEntity, menuCoreEntity));
		}
		
		private function HelpFunction():void
		{
			backgroundEntity.ChangeBackgroundColor();
			helpSfx.play();
			Engine.currentWorld.RemoveEntity(this);
			Engine.currentWorld.AddEntity(new HelpEntity(backgroundEntity, menuCoreEntity, MainMenuEntity));
		}
		
		private function GameCenterFunction():void
		{
			backgroundEntity.ChangeBackgroundColor();
			gamecenterSfx.play();
			Engine.currentWorld.RemoveEntity(this);
			Engine.currentWorld.AddEntity(new GameCenterEntity(backgroundEntity, menuCoreEntity, MainMenuEntity));
		}
		
		public function OSTFunction():void
		{
			ostSfx.play();
			navigateToURL(Global.OST_LINK, "_blank");
		}
		
		override public function Update():void 
		{
			super.Update();
			
			gameplayText.color = backgroundEntity.GetCurrentBackColor();
			
			for (var i:int = 0; i < gamePlayModeText.length; i++) 
			{
				gamePlayModeText[i].alpha = 0;
				gamePlayModeText[i].color = backgroundEntity.GetCurrentBackColor();
			}
			gamePlayModeText[selectedMode].alpha = 1;
			
			for (var j:int = 0; j < descriptionText.length; j++) 
			{
				descriptionText[j].alpha = 0;
				descriptionText[j].color = backgroundEntity.GetCurrentBackColor();
			}
			descriptionText[selectedMode].alpha = 1;
			
			touchPoints = TouchControl.TouchPressedPoints(TouchControl.ANY_SCREEN);
			for (var k:int = 0; k < touchPoints.length; k++) 
			{
				if (CheckCollisionWithPoint(touchPoints[k].x, touchPoints[k].y, x, y))
				{
					ModeSelected();
				}
			}
		}
		
		override public function RenderMissingFrame():void 
		{
			super.RenderMissingFrame();
			
			gameplayText.color = backgroundEntity.GetCurrentBackColor();
			
			for (var i:int = 0; i < gamePlayModeText.length; i++) 
			{
				gamePlayModeText[i].alpha = 0;
				gamePlayModeText[i].color = backgroundEntity.GetCurrentBackColor();
			}
			gamePlayModeText[selectedMode].alpha = 1;
			
			for (var j:int = 0; j < descriptionText.length; j++) 
			{
				descriptionText[j].alpha = 0;
				descriptionText[j].color = backgroundEntity.GetCurrentBackColor();
			}
			descriptionText[selectedMode].alpha = 1;
		}
	}

}