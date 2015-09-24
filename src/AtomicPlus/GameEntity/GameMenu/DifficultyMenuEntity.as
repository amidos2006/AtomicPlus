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
	import AtomicPlus.GameWorld.GameplayWorld;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	/**
	 * ...
	 * @author Amidos
	 */
	public class DifficultyMenuEntity extends BaseEntity
	{
		private const X_SHIFT:int = 4;
		private const Y_SHIFT:int = -10;
		
		private var backgroundEntity:BackgroundEntity;
		private var menuCoreEntity:MenuCoreEntity;
		
		private var difficultyText:Text;
		private var difficultyModeText:Vector.<Text>;
		private var descriptionText:Vector.<Text>;
		private var touchToSelectText:Text;
		private var creditsText:Text;
		private var selectedDifficulty:int;
		private var flickerAlarm:Alarm;
		private var leftArrowEntity:ArrowButtonEntity;
		private var rightArrowEntity:ArrowButtonEntity;
		private var xButtonEntity:XButtonEntity;
		private var questionButtonEntity:QuestionButtonEntity;
		private var gameCenterButtonEntity:ImageButtonEntity;
		private var getOSTButtonEntity:ImageButtonEntity;
		
		private var changeSelectionSfx:Sfx;
		private var selectedSfx:Sfx;
		private var backSfx:Sfx;
		private var helpSfx:Sfx;
		private var gameCenterSfx:Sfx;
		private var ostSfx:Sfx;
		
		public function DifficultyMenuEntity(background:BackgroundEntity, menuCore:MenuCoreEntity) 
		{
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			backgroundEntity = background;
			menuCoreEntity = menuCore;
			selectedDifficulty = Global.gameDifficulty;
			
			changeSelectionSfx = new Sfx(SoundLoader.GetSound("changeselection"));
			selectedSfx = new Sfx(SoundLoader.GetSound("selected"));
			backSfx = new Sfx(SoundLoader.GetSound("back"));
			helpSfx = new Sfx(SoundLoader.GetSound("help"));
			gameCenterSfx = new Sfx(SoundLoader.GetSound("gamecenter"));
			ostSfx = new Sfx(SoundLoader.GetSound("ost"));
			
			difficultyText = new Text("difficulty", background.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			difficultyText.CenterOO();
			difficultyText.y -= (Text.LARGE_FONT / 2 + Y_SHIFT) * GraphicsLoader.ConversionRatio;
			
			touchToSelectText = new Text("touch center to select", 0xFFFFFF, Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			touchToSelectText.CenterOO();
			touchToSelectText.y = (Global.GetCurrentOrbitRadius(1) + 80) * GraphicsLoader.ConversionRatio;
			
			creditsText = new Text("game by amidos\nmusic by agent whiskers", 0xFFFFFF, Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			creditsText.CenterOO();
			creditsText.y += GraphicsLoader.Height / 2 - (Global.CENTER_SHIFT_Y + Text.SMALL_FONT) * GraphicsLoader.ConversionRatio;
			
			difficultyModeText = new Vector.<Text>();
			descriptionText = new Vector.<Text>();
			
			var text:Text = new Text("normal", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.x += X_SHIFT * GraphicsLoader.ConversionRatio;
			text.y -= Y_SHIFT * GraphicsLoader.ConversionRatio;
			text.alpha = 0;
			difficultyModeText.push(text);
			
			text = new Text("", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.y = difficultyModeText[0].y + (Text.LARGE_FONT / 2) * GraphicsLoader.ConversionRatio;
			text.alpha = 0;
			descriptionText.push(text);
			
			text = new Text("hardcore", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.x += X_SHIFT * GraphicsLoader.ConversionRatio;
			text.y = difficultyModeText[0].y;
			text.alpha = 0;
			difficultyModeText.push(text);
			
			text = new Text("", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.y = descriptionText[0].y;
			text.alpha = 0;
			descriptionText.push(text);
			
			var distanceAway:Number = (Global.GetCurrentOrbitRadius(3)) * GraphicsLoader.ConversionRatio;
			leftArrowEntity = new ArrowButtonEntity(GraphicsLoader.Width / 2 - distanceAway + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio, 
														GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio, 
														backgroundEntity, ArrowButtonEntity.LEFT, ChangeSelectionLeft);
			rightArrowEntity = new ArrowButtonEntity(GraphicsLoader.Width / 2 + distanceAway + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio, 
														GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio, 
														backgroundEntity, ArrowButtonEntity.RIGHT, ChangeSelectionRight);
			xButtonEntity = new XButtonEntity(Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, 
												Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, BackFunction);
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
			
			difficultyText.Added();
			addChild(difficultyText);
			
			for (var i:int = 0; i < difficultyModeText.length; i++) 
			{
				difficultyModeText[i].Added();
				addChild(difficultyModeText[i]);
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
			
			difficultyText.Removed();
			removeChild(difficultyText);
			
			for (var i:int = 0; i < difficultyModeText.length; i++) 
			{
				difficultyModeText[i].Removed();
				removeChild(difficultyModeText[i]);
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
			Global.gameDifficulty = selectedDifficulty;
			changeSelectionSfx.play();
		}
		
		private function ChangeSelectionLeft():void
		{
			selectedDifficulty -= 1;
			if (selectedDifficulty < 0)
			{
				selectedDifficulty = difficultyModeText.length - 1;
			}
			ChangeSelection();
		}
		
		private function ChangeSelectionRight():void
		{
			selectedDifficulty += 1;
			if (selectedDifficulty >= difficultyModeText.length)
			{
				selectedDifficulty = 0;
			}
			ChangeSelection();
		}
		
		private function DifficultySelected():void
		{
			selectedSfx.play();
			Engine.currentWorld.RemoveEntity(this);
			Engine.nextWorld = new GameplayWorld();
		}
		
		private function BackFunction():void
		{
			backSfx.play();
			Engine.currentWorld.RemoveEntity(this);
			Engine.currentWorld.AddEntity(new MainMenuEntity(backgroundEntity, menuCoreEntity));
		}
		
		private function HelpFunction():void
		{
			backgroundEntity.ChangeBackgroundColor();
			helpSfx.play();
			Engine.currentWorld.RemoveEntity(this);
			Engine.currentWorld.AddEntity(new HelpEntity(backgroundEntity, menuCoreEntity, DifficultyMenuEntity));
		}
		
		private function GameCenterFunction():void
		{
			backgroundEntity.ChangeBackgroundColor();
			gameCenterSfx.play();
			Engine.currentWorld.RemoveEntity(this);
			Engine.currentWorld.AddEntity(new GameCenterEntity(backgroundEntity, menuCoreEntity, DifficultyMenuEntity));
		}
		
		public function OSTFunction():void
		{
			ostSfx.play();
			navigateToURL(Global.OST_LINK, "_blank");
		}
		
		override public function Update():void 
		{
			super.Update();
			
			difficultyText.color = backgroundEntity.GetCurrentBackColor();
			
			for (var i:int = 0; i < difficultyModeText.length; i++) 
			{
				difficultyModeText[i].alpha = 0;
				difficultyModeText[i].color = backgroundEntity.GetCurrentBackColor();
			}
			difficultyModeText[selectedDifficulty].alpha = 1;
			
			for (var j:int = 0; j < descriptionText.length; j++) 
			{
				descriptionText[j].alpha = 0;
				descriptionText[j].color = backgroundEntity.GetCurrentBackColor();
			}
			descriptionText[selectedDifficulty].alpha = 1;
			
			var touchPoints:Vector.<Point> = TouchControl.TouchPressedPoints(TouchControl.ANY_SCREEN);
			for (var k:int = 0; k < touchPoints.length; k++) 
			{
				if (CheckCollisionWithPoint(touchPoints[k].x, touchPoints[k].y, x, y))
				{
					DifficultySelected();
				}
			}
		}
		
		override public function RenderMissingFrame():void 
		{
			super.RenderMissingFrame();
			
			difficultyText.color = backgroundEntity.GetCurrentBackColor();
			
			for (var i:int = 0; i < difficultyModeText.length; i++) 
			{
				difficultyModeText[i].alpha = 0;
				difficultyModeText[i].color = backgroundEntity.GetCurrentBackColor();
			}
			difficultyModeText[selectedDifficulty].alpha = 1;
			
			for (var j:int = 0; j < descriptionText.length; j++) 
			{
				descriptionText[j].alpha = 0;
				descriptionText[j].color = backgroundEntity.GetCurrentBackColor();
			}
			descriptionText[selectedDifficulty].alpha = 1;
		}
	}

}