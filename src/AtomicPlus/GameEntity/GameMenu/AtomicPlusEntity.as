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
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import flash.desktop.NativeApplication;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Amidos
	 */
	public class AtomicPlusEntity extends BaseEntity
	{
		private var backgroundEntity:BackgroundEntity;
		private var menuCoreEntity:MenuCoreEntity;
		private var gameNameText:Text;
		private var touchScreenText:Text;
		private var creditsText:Text;
		private var flickerAlarm:Alarm;
		private var touchPoints:Vector.<Point>;
		
		private var selectedSfx:Sfx;
		
		public function AtomicPlusEntity(background:BackgroundEntity, menuCore:MenuCoreEntity) 
		{
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			backgroundEntity = background;
			menuCoreEntity = menuCore;
			
			selectedSfx = new Sfx(SoundLoader.GetSound("selected"));
			
			gameNameText = new Text("atomic+", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			gameNameText.CenterOO();
			gameNameText.y += 1 * GraphicsLoader.ConversionRatio;
			
			creditsText = new Text("game by amidos\nmusic by agent whiskers", 0xFFFFFF, Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			creditsText.CenterOO();
			creditsText.y += GraphicsLoader.Height / 2 - (Global.CENTER_SHIFT_Y + Text.SMALL_FONT) * GraphicsLoader.ConversionRatio;
			
			touchScreenText = new Text("touch center to start", 0xFFFFFF, Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			touchScreenText.CenterOO();
			touchScreenText.y += 120 * GraphicsLoader.ConversionRatio;
			
			flickerAlarm = new Alarm(400, Flicker, Alarm.LOOPING);
			
			layer = LayerConstant.HUD_LAYER;
			
			SetHitBox(2 * (Global.CORE_RADIUS) * GraphicsLoader.ConversionRatio, 
						2 * (Global.CORE_RADIUS) * GraphicsLoader.ConversionRatio, 
						-(Global.CORE_RADIUS) * GraphicsLoader.ConversionRatio, 
						-(Global.CORE_RADIUS) * GraphicsLoader.ConversionRatio);
		}
		
		private function Flicker():void
		{
			touchScreenText.alpha = 1 - touchScreenText.alpha;
		}
		
		override public function Added():void 
		{
			super.Added();
			
			gameNameText.Added();
			addChild(gameNameText);
			
			touchScreenText.Added();
			addChild(touchScreenText);
			
			creditsText.Added();
			addChild(creditsText);
			
			AlarmSystem.AddAlarm(flickerAlarm, true);
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			gameNameText.Removed();
			removeChild(gameNameText);
			
			touchScreenText.Removed();
			removeChild(touchScreenText);
			
			creditsText.Removed();
			removeChild(creditsText);
			
			AlarmSystem.RemoveAlarm(flickerAlarm);
		}
		
		override public function Update():void 
		{
			super.Update();
			
			gameNameText.color = backgroundEntity.GetCurrentBackColor();
			
			touchPoints = TouchControl.TouchPressedPoints(TouchControl.ANY_SCREEN);
			for (var k:int = 0; k < touchPoints.length; k++) 
			{
				if (CheckCollisionWithPoint(touchPoints[k].x, touchPoints[k].y, x, y))
				{
					selectedSfx.play();
					Engine.currentWorld.RemoveEntity(this);
					Engine.currentWorld.AddEntity(new MainMenuEntity(backgroundEntity, menuCoreEntity));
					backgroundEntity.ChangeBackgroundColor();
					menuCoreEntity.Enlarge(null);
				}
			}
		}
	}

}