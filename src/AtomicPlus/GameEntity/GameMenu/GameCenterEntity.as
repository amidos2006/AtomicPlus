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
	import AtomicPlus.GameEntity.BackgroundEntity;
	import AtomicPlus.GameplayType;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import com.milkmangames.nativeextensions.ios.events.GameCenterErrorEvent;
	import com.milkmangames.nativeextensions.ios.events.GameCenterEvent;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameCenterEntity extends BaseEntity
	{
		private var backgroundEntity:BackgroundEntity;
		private var menuCoreEntity:MenuCoreEntity;
		
		private var descriptionText:Text;
		private var creditsText:Text;
		private var xButtonEntity:XButtonEntity;
		private var returnClass:Class;
		
		private var backSfx:Sfx;
		private var submitScore:Boolean;
		private var backPressed:Boolean;
		
		public function GameCenterEntity(background:BackgroundEntity, menuCore:MenuCoreEntity, backClass:Class, submit:Boolean = false) 
		{
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			backgroundEntity = background;
			menuCoreEntity = menuCore;
			returnClass = backClass;
			submitScore = submit;
			backPressed = false;
			
			backSfx = new Sfx(SoundLoader.GetSound("back"));
			
			descriptionText = new Text("authenticating...", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			descriptionText.CenterOO();
			
			creditsText = new Text("game by amidos\nmusic by agent whiskers", 0xFFFFFF, Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			creditsText.CenterOO();
			creditsText.y += GraphicsLoader.Height / 2 - (Global.CENTER_SHIFT_Y + Text.SMALL_FONT) * GraphicsLoader.ConversionRatio;
			
			xButtonEntity = new XButtonEntity(Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, BackFunction);
			
			layer = LayerConstant.HUD_LAYER;
			
			SetHitBox(2 * (Global.GetCurrentOrbitRadius(1) + 30) * GraphicsLoader.ConversionRatio, 
						2 * (Global.GetCurrentOrbitRadius(1) + 30) * GraphicsLoader.ConversionRatio, 
						-(Global.GetCurrentOrbitRadius(1) + 30) * GraphicsLoader.ConversionRatio, 
						-(Global.GetCurrentOrbitRadius(1) + 30) * GraphicsLoader.ConversionRatio);
		}
		
		override public function Added():void 
		{
			super.Added();
			
			descriptionText.Added();
			addChild(descriptionText);
			
			if (!submitScore)
			{
				creditsText.Added();
				addChild(creditsText);
			}
			
			if (GameCenter.gameCenter.isUserAuthenticated())
			{
				AuthSucceed(null);
			}
			else
			{
				Authenticate();
			}
			
			Engine.currentWorld.AddEntity(xButtonEntity);
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			descriptionText.Removed();
			removeChild(descriptionText);
			
			if (!submitScore)
			{
				creditsText.Removed();
				removeChild(creditsText);
			}
			
			Engine.currentWorld.RemoveEntity(xButtonEntity);
		}
		
		private function Authenticate():void
		{
			GameCenter.gameCenter.addEventListener(GameCenterEvent.AUTH_SUCCEEDED, AuthSucceed);
			GameCenter.gameCenter.addEventListener(GameCenterErrorEvent.AUTH_FAILED, AuthFailed);
			
			GameCenter.gameCenter.authenticateLocalUser();
		}
		
		private function AuthSucceed(e:Event):void
		{
			GameCenter.gameCenter.removeEventListener(GameCenterEvent.AUTH_SUCCEEDED, AuthSucceed);
			GameCenter.gameCenter.removeEventListener(GameCenterErrorEvent.AUTH_FAILED, AuthFailed);
			
			if (submitScore)
			{
				SubmitScore();
			}
			else
			{
				ShowScore();
			}
		}
		
		private function AuthFailed(e:Event):void
		{
			GameCenter.gameCenter.removeEventListener(GameCenterEvent.AUTH_SUCCEEDED, AuthSucceed);
			GameCenter.gameCenter.removeEventListener(GameCenterErrorEvent.AUTH_FAILED, AuthFailed);
			
			descriptionText.text = "authentication failed";
			descriptionText.CenterOO();
		}
		
		private function SubmitScore():void
		{
			if (backPressed)
			{
				return;
			}
			
			GameCenter.gameCenter.addEventListener(GameCenterEvent.SCORE_REPORT_SUCCEEDED, SubmissionSucceed);
			GameCenter.gameCenter.addEventListener(GameCenterErrorEvent.SCORE_REPORT_FAILED, SubmissionFailed);
			
			descriptionText.text = "submitting score...";
			descriptionText.CenterOO();
			
			GameCenter.gameCenter.reportScoreForCategory(Global.score, Global.GetLeaderboardName());
		}
		
		private function SubmissionSucceed(e:Event):void
		{
			GameCenter.gameCenter.removeEventListener(GameCenterEvent.SCORE_REPORT_SUCCEEDED, SubmissionSucceed);
			GameCenter.gameCenter.removeEventListener(GameCenterErrorEvent.SCORE_REPORT_FAILED, SubmissionFailed);
			
			Global.SaveBestScore();
			ShowScore();
		}
		
		private function SubmissionFailed(e:Event):void
		{
			GameCenter.gameCenter.removeEventListener(GameCenterEvent.SCORE_REPORT_SUCCEEDED, SubmissionSucceed);
			GameCenter.gameCenter.removeEventListener(GameCenterErrorEvent.SCORE_REPORT_FAILED, SubmissionFailed);
			
			descriptionText.text = "submission failed";
			descriptionText.CenterOO();
		}
		
		private function ShowScore():void
		{
			if (backPressed)
			{
				return;
			}
			
			GameCenter.gameCenter.addEventListener(GameCenterEvent.LEADERBOARD_VIEW_CLOSED, LeaderBoardClose);
			
			descriptionText.text = "retrieving leaderboard...";
			descriptionText.CenterOO();
			
			GameCenter.gameCenter.showLeaderboardForCategory(Global.GetLeaderboardName());
		}
		
		private function LeaderBoardClose():void
		{
			GameCenter.gameCenter.removeEventListener(GameCenterEvent.LEADERBOARD_VIEW_CLOSED, LeaderBoardClose);
			Main.activate(null);
			
			BackFunction();
		}
		
		public function BackFunction():void
		{
			backPressed = true;
			backSfx.play();
			Engine.currentWorld.RemoveEntity(this);
			Engine.currentWorld.AddEntity(new returnClass(backgroundEntity, menuCoreEntity));
		}
		
		override public function Update():void 
		{
			super.Update();
			
			descriptionText.color = backgroundEntity.GetCurrentBackColor();
		}
		
		override public function RenderMissingFrame():void 
		{
			super.RenderMissingFrame();
			
			descriptionText.color = backgroundEntity.GetCurrentBackColor();
		}
	}

}