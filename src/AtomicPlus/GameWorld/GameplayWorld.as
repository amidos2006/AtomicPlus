package AtomicPlus.GameWorld 
{
	import AmidosEngine.BaseWorld;
	import AmidosEngine.Engine;
	import AmidosEngine.GraphicsLoader;
	import AmidosEngine.MusicLoader;
	import AmidosEngine.Sfx;
	import AmidosEngine.SoundLoader;
	import AmidosEngine.Text;
	import AmidosEngine.TouchControl;
	import AtomicPlus.GameEntity.*;
	import AtomicPlus.GameEntity.GameMenu.XButtonEntity;
	import AtomicPlus.Global;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameplayWorld extends BaseWorld
	{
		private var overlayerEntity:OverlayerEntity;
		private var hitOverlayerEntity:HitOverlayerEntity;
		private var backgroundEntity:BackgroundEntity;
		private var hudEntity:HUDEntity;
		private var sqaureSpawnerEntity:SquareSpawnerEntity;
		private var coreEntity:CoreEntity;
		private var smallOrbitsEntity:OrbitsEntity;
		private var largeOrbitsEntity:OrbitsEntity;
		private var xButtonEntity:XButtonEntity;
		
		private var backSfx:Sfx;
		
		public function GameplayWorld() 
		{
			super(10);
			
			Global.score = 0;
			backSfx = new Sfx(SoundLoader.GetSound("back"));
			
			overlayerEntity = new OverlayerEntity();
			hitOverlayerEntity = new HitOverlayerEntity();
			backgroundEntity = new BackgroundEntity();
			hudEntity = new HUDEntity(backgroundEntity);
			smallOrbitsEntity = new OrbitsEntity(OrbitsEntity.SMALL);
			largeOrbitsEntity = new OrbitsEntity(OrbitsEntity.LARGE);
			sqaureSpawnerEntity = new SquareSpawnerEntity();
			coreEntity = new CoreEntity(sqaureSpawnerEntity);
			xButtonEntity = new XButtonEntity(Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, 
												Text.LARGE_FONT / 2 * GraphicsLoader.ConversionRatio, BackFunction);
		}
		
		public function StartGame():void
		{
			var mainOrbitEntity:MainOrbitEntity = new MainOrbitEntity();
			Global.playerEntity = new PlayerEntity(backgroundEntity, mainOrbitEntity, sqaureSpawnerEntity, coreEntity, hitOverlayerEntity);
			
			AddEntity(Global.playerEntity);
			AddEntity(mainOrbitEntity);
			
			MusicLoader.PlayMusic(Global.gameplayType);
		}
		
		private function BackFunction():void
		{
			MusicLoader.StopRunningMusic();
			backSfx.play();
			Engine.currentWorld.RemoveEntity(coreEntity);
			Engine.nextWorld = new StartingWorld(true);
		}
		
		override public function StartWorld():void 
		{
			super.StartWorld();
			
			//if (!Global.IsiPhone4())
			{
				AddEntity(overlayerEntity);
			}
			AddEntity(hitOverlayerEntity);
			AddEntity(backgroundEntity);
			AddEntity(hudEntity);
			AddEntity(coreEntity);
			AddEntity(smallOrbitsEntity);
			AddEntity(largeOrbitsEntity);
			AddEntity(sqaureSpawnerEntity);
			AddEntity(xButtonEntity);
			
			StartGame();
		}
		
		override public function Update():void 
		{
			super.Update();
		}
	}

}