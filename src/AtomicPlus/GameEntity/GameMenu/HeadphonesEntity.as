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
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HeadphonesEntity extends BaseEntity
	{
		private var backgroundEntity:BackgroundEntity;
		private var menuCoreEntity:MenuCoreEntity;
		private var bestplayText:Text;
		private var creditsText:Text;
		private var endAlarm:Alarm;
		
		public function HeadphonesEntity(background:BackgroundEntity, menuCore:MenuCoreEntity) 
		{
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			backgroundEntity = background;
			menuCoreEntity = menuCore;
			
			bitmap = new Image(GraphicsLoader.GetGraphics("headphones"));
			bitmap.scaleX = GraphicsLoader.ConversionRatio;
			bitmap.scaleY = GraphicsLoader.ConversionRatio;
			CenterOO();
			bitmap.y -= 25 * GraphicsLoader.ConversionRatio;
			
			bestplayText = new Text("best played\nwith headphones", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			bestplayText.CenterOO();
			bestplayText.y += 90 * GraphicsLoader.ConversionRatio;
			
			creditsText = new Text("game by amidos\nmusic by agent whiskers", 0xFFFFFF, Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			creditsText.CenterOO();
			creditsText.y += GraphicsLoader.Height / 2 - (Global.CENTER_SHIFT_Y + Text.SMALL_FONT) * GraphicsLoader.ConversionRatio;
			
			endAlarm = new Alarm(2000, EndFunction, Alarm.ONE_SHOT);
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		private function EndFunction():void
		{
			Engine.currentWorld.RemoveEntity(this);
			menuCoreEntity.Shrink(null);
			Engine.currentWorld.AddEntity(new AtomicPlusEntity(backgroundEntity, menuCoreEntity));
		}
		
		override public function Added():void 
		{
			super.Added();
			
			bitmap.color = backgroundEntity.GetCurrentBackColor();
			
			menuCoreEntity.Enlarge(null);
			
			bestplayText.Added();
			addChild(bestplayText);
			
			creditsText.Added();
			addChild(creditsText);
			
			AlarmSystem.AddAlarm(endAlarm, true);
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			bestplayText.Removed();
			removeChild(bestplayText);
			
			creditsText.Removed();
			removeChild(creditsText);
			
			AlarmSystem.RemoveAlarm(endAlarm);
		}
		
		override public function Update():void 
		{
			super.Update();
			
			bestplayText.color = backgroundEntity.GetCurrentBackColor();
		}
	}

}