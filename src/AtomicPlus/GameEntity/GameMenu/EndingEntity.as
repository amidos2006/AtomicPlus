package AtomicPlus.GameEntity.GameMenu 
{
	import AmidosEngine.Alarm;
	import AmidosEngine.AlarmSystem;
	import AmidosEngine.BaseEntity;
	import AmidosEngine.Engine;
	import AmidosEngine.GraphicsLoader;
	import AmidosEngine.Sfx;
	import AmidosEngine.SoundLoader;
	import AmidosEngine.Text;
	import AmidosEngine.TouchControl;
	import AtomicPlus.GameEntity.BackgroundEntity;
	import AtomicPlus.GameWorld.GameplayWorld;
	import AtomicPlus.GameWorld.StartingWorld;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import com.milkmangames.nativeextensions.ios.events.GameCenterEvent;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Amidos
	 */
	public class EndingEntity extends BaseEntity
	{
		private var backgroundEntity:BackgroundEntity;
		private var menuCoreEntity:MenuCoreEntity;
		
		private var gameOverText:Text;
		private var scoreText:Text;
		private var scoreValueText:Text;
		private var bestScoreText:Text;
		private var leftArrowEntity:ArrowButtonEntity;
		private var rightArrowEntity:ArrowButtonEntity;
		private var xButtonEntity:XButtonEntity;
		private var choicesText:Vector.<Text>;
		private var selectedChoice:int;
		private var touchToSelectText:Text;
		private var flickerAlarm:Alarm;
		private var touchPoints:Vector.<Point>;
		
		private var changeSelectionSfx:Sfx;
		private var selectedSfx:Sfx;
		private var backSfx:Sfx;
		
		public function EndingEntity(background:BackgroundEntity, menuCore:MenuCoreEntity) 
		{
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			backgroundEntity = background;
			menuCoreEntity = menuCore;
			selectedChoice = 0;
			
			changeSelectionSfx = new Sfx(SoundLoader.GetSound("changeselection"));
			selectedSfx = new Sfx(SoundLoader.GetSound("selected"));
			backSfx = new Sfx(SoundLoader.GetSound("back"));
			
			gameOverText = new Text("gameover", backgroundEntity.GetCurrentBackColor(), Text.LARGE_FONT * GraphicsLoader.ConversionRatio);
			gameOverText.CenterOO();
			gameOverText.y -= 70 * GraphicsLoader.ConversionRatio;
			gameOverText.x = 3 * GraphicsLoader.ConversionRatio;
			
			scoreText = new Text("score", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			scoreText.CenterOO();
			
			scoreValueText = new Text(Global.score.toString(), backgroundEntity.GetCurrentBackColor(), 
										Text.X_LARGE_FONT * GraphicsLoader.ConversionRatio);
			scoreValueText.CenterOO();
			
			scoreValueText.x = (4) * GraphicsLoader.ConversionRatio;
			scoreValueText.y = (15) * GraphicsLoader.ConversionRatio;
			scoreText.y = scoreValueText.y - (Text.X_LARGE_FONT) * GraphicsLoader.ConversionRatio / 2;
			
			bestScoreText = new Text("best submitted score: " + Global.bestScore[Global.gameplayType.toString() + Global.gameDifficulty.toString()].toString(), 0xFFFFFF, Text.SMALL_FONT * GraphicsLoader.ConversionRatio, "center");
			bestScoreText.CenterOO();
			bestScoreText.y += GraphicsLoader.Height / 2 - (Global.CENTER_SHIFT_Y + Text.SMALL_FONT / 2) * GraphicsLoader.ConversionRatio;
			
			touchToSelectText = new Text("touch center to select", 0xFFFFFF, Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			touchToSelectText.CenterOO();
			touchToSelectText.y = (Global.GetCurrentOrbitRadius(1) + 80) * GraphicsLoader.ConversionRatio;
			
			choicesText = new Vector.<Text>();
			
			var text:Text = new Text("play again", backgroundEntity.GetCurrentBackColor(), Text.MEDIUM_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.alpha = 0;
			text.y += 70 * GraphicsLoader.ConversionRatio;
			choicesText.push(text);
			
			text = new Text("show scores", backgroundEntity.GetCurrentBackColor(), Text.MEDIUM_FONT * GraphicsLoader.ConversionRatio);
			text.CenterOO();
			text.alpha = 0;
			text.y = choicesText[0].y;
			if (GameCenter.isSupported() && GameCenter.gameCenter.isGameCenterAvailable())
			{
				choicesText.push(text);
			}
			
			var distanceAway:Number = (Global.GetCurrentOrbitRadius(3)) * GraphicsLoader.ConversionRatio;
			leftArrowEntity = new ArrowButtonEntity(GraphicsLoader.Width / 2 - distanceAway + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio, 
														GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio, 
														backgroundEntity, ArrowButtonEntity.LEFT, ChangeSelectionLeft);
			rightArrowEntity = new ArrowButtonEntity(GraphicsLoader.Width / 2 + distanceAway + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio, 
														GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio, 
														backgroundEntity, ArrowButtonEntity.RIGHT, ChangeSelectionRight);
			xButtonEntity = new XButtonEntity(Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, 
												Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, BackFunction);
			
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
			
			if (GameCenter.isSupported() && GameCenter.gameCenter.isGameCenterAvailable() && GameCenter.gameCenter.isUserAuthenticated())
			{
				GameCenter.gameCenter.addEventListener(GameCenterEvent.SCORE_REPORT_SUCCEEDED, ScoreReported);
				GameCenter.gameCenter.reportScoreForCategory(Global.score, Global.GetLeaderboardName());
			}
			
			addChild(scoreText);
			scoreText.Added();
			
			if (Global.bestScore[Global.gameplayType.toString() + Global.gameDifficulty.toString()] > 0)
			{
				addChild(bestScoreText);
				bestScoreText.Added();
			}
			
			addChild(gameOverText);
			gameOverText.Added();
			
			addChild(scoreValueText);
			scoreValueText.Added();
			
			addChild(touchToSelectText);
			touchToSelectText.Added();
			
			for (var i:int = 0; i < choicesText.length; i++) 
			{
				choicesText[i].Added();
				addChild(choicesText[i]);
			}
			
			if (choicesText.length > 1)
			{
				Engine.currentWorld.AddEntity(leftArrowEntity);
				Engine.currentWorld.AddEntity(rightArrowEntity);
			}
			Engine.currentWorld.AddEntity(xButtonEntity);
			AlarmSystem.AddAlarm(flickerAlarm, true);
			
			RenderMissingFrame();
		}
		
		private function ScoreReported(e:Event):void
		{
			GameCenter.gameCenter.removeEventListener(GameCenterEvent.SCORE_REPORT_SUCCEEDED, ScoreReported);
			
			if (Global.score > Global.bestScore[Global.gameplayType.toString() + Global.gameDifficulty.toString()])
			{
				Global.bestScore[Global.gameplayType.toString() + Global.gameDifficulty.toString()] = Global.score;
			}
			Global.SaveBestScore();
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			removeChild(scoreText);
			scoreText.Removed();
			
			if (Global.bestScore[Global.gameplayType.toString() + Global.gameDifficulty.toString()] > 0)
			{
				removeChild(bestScoreText);
				bestScoreText.Removed();
			}
			
			removeChild(gameOverText);
			gameOverText.Removed();
			
			removeChild(scoreValueText);
			scoreValueText.Removed();
			
			removeChild(touchToSelectText);
			touchToSelectText.Removed();
			
			for (var i:int = 0; i < choicesText.length; i++) 
			{
				choicesText[i].Removed();
				removeChild(choicesText[i]);
			}
			
			if (choicesText.length > 1)
			{
				Engine.currentWorld.RemoveEntity(leftArrowEntity);
				Engine.currentWorld.RemoveEntity(rightArrowEntity);
			}
			Engine.currentWorld.RemoveEntity(xButtonEntity);
			AlarmSystem.RemoveAlarm(flickerAlarm);
		}
		
		private function ChangeSelection():void
		{
			changeSelectionSfx.play();
		}
		
		private function ChangeSelectionLeft():void
		{
			selectedChoice -= 1;
			if (selectedChoice < 0)
			{
				selectedChoice = choicesText.length - 1;
			}
			ChangeSelection();
		}
		
		private function ChangeSelectionRight():void
		{
			selectedChoice += 1;
			if (selectedChoice >= choicesText.length)
			{
				selectedChoice = 0;
			}
			ChangeSelection();
		}
		
		private function OptionSelected():void
		{
			selectedSfx.play();
			switch (selectedChoice) 
			{
				case 0:
					Engine.currentWorld.RemoveEntity(this);
					Engine.nextWorld = new GameplayWorld();
					break;
				case 1:
					Engine.currentWorld.RemoveEntity(this);
					var submitScore:Boolean = !GameCenter.gameCenter.isUserAuthenticated();
					Engine.currentWorld.AddEntity(new GameCenterEntity(backgroundEntity, menuCoreEntity, EndingEntity, submitScore));
					break;
			}
		}
		
		private function BackFunction():void
		{
			backSfx.play();
			Engine.nextWorld = new StartingWorld(true, menuCoreEntity);
		}
		
		override public function Update():void 
		{
			super.Update();
			
			scoreText.color = backgroundEntity.GetCurrentBackColor();
			gameOverText.color = backgroundEntity.GetCurrentBackColor();
			
			scoreValueText.text = Global.score.toString();
			scoreValueText.CenterOO();
			scoreValueText.color = backgroundEntity.GetCurrentBackColor();
			
			for (var i:int = 0; i < choicesText.length; i++) 
			{
				choicesText[i].alpha = 0;
				choicesText[i].color = backgroundEntity.GetCurrentBackColor();
			}
			choicesText[selectedChoice].alpha = 1;
			
			touchPoints = TouchControl.TouchPressedPoints(TouchControl.ANY_SCREEN);
			for (var k:int = 0; k < touchPoints.length; k++) 
			{
				if (CheckCollisionWithPoint(touchPoints[k].x, touchPoints[k].y, x, y))
				{
					OptionSelected();
				}
			}
		}
		
		override public function RenderMissingFrame():void 
		{
			super.RenderMissingFrame();
			
			scoreText.color = backgroundEntity.GetCurrentBackColor();
			gameOverText.color = backgroundEntity.GetCurrentBackColor();
			
			scoreValueText.text = Global.score.toString();
			scoreValueText.CenterOO();
			scoreValueText.color = backgroundEntity.GetCurrentBackColor();
			
			for (var i:int = 0; i < choicesText.length; i++) 
			{
				choicesText[i].alpha = 0;
				choicesText[i].color = backgroundEntity.GetCurrentBackColor();
			}
			choicesText[selectedChoice].alpha = 1;
		}
	}

}