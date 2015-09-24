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
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HelpEntity extends BaseEntity
	{
		private var backgroundEntity:BackgroundEntity;
		private var menuCoreEntity:MenuCoreEntity;
		
		private var helpText:Text;
		private var descriptionText:Text;
		private var creditsText:Text;
		private var xButtonEntity:XButtonEntity;
		private var returnClass:Class;
		
		private var backSfx:Sfx;
		
		public function HelpEntity(background:BackgroundEntity, menuCore:MenuCoreEntity, backClass:Class) 
		{
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			backgroundEntity = background;
			menuCoreEntity = menuCore;
			returnClass = backClass;
			
			backSfx = new Sfx(SoundLoader.GetSound("back"));
			
			descriptionText = new Text("collect squares\navoid bullets\nsurvive longest time", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			descriptionText.CenterOO();
			descriptionText.y += (20) * GraphicsLoader.ConversionRatio;
			
			helpText = new Text("help", backgroundEntity.GetCurrentBackColor(), Text.MEDIUM_FONT * GraphicsLoader.ConversionRatio);
			helpText.CenterOO();
			helpText.y = descriptionText.y - descriptionText.TextHeight / 2 - 20 * GraphicsLoader.ConversionRatio;
			
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
			
			helpText.Added();
			addChild(helpText);
			
			descriptionText.Added();
			addChild(descriptionText);
			
			creditsText.Added();
			addChild(creditsText);
			
			Engine.currentWorld.AddEntity(xButtonEntity);
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			helpText.Removed();
			removeChild(helpText);
			
			descriptionText.Removed();
			removeChild(descriptionText);
			
			creditsText.Removed();
			removeChild(creditsText);
			
			Engine.currentWorld.RemoveEntity(xButtonEntity);
		}
		
		public function BackFunction():void
		{
			backSfx.play();
			Engine.currentWorld.RemoveEntity(this);
			Engine.currentWorld.AddEntity(new returnClass(backgroundEntity, menuCoreEntity));
		}
		
		override public function Update():void 
		{
			super.Update();
			
			helpText.color = backgroundEntity.GetCurrentBackColor();
			descriptionText.color = backgroundEntity.GetCurrentBackColor();
		}
		
		override public function RenderMissingFrame():void 
		{
			super.RenderMissingFrame();
			
			helpText.color = backgroundEntity.GetCurrentBackColor();
			descriptionText.color = backgroundEntity.GetCurrentBackColor();
		}
	}

}