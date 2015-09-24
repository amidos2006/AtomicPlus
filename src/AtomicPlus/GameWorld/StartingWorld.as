package AtomicPlus.GameWorld 
{
	import AmidosEngine.BaseWorld;
	import AmidosEngine.Engine;
	import AmidosEngine.TouchControl;
	import AtomicPlus.GameEntity.*;
	import AtomicPlus.GameEntity.GameMenu.*;
	import AtomicPlus.Global;
	/**
	 * ...
	 * @author Amidos
	 */
	public class StartingWorld extends BaseWorld
	{
		private var overlayerEntity:OverlayerEntity;
		private var backgroundEntity:BackgroundEntity;
		private var menuCoreEntity:MenuCoreEntity;
		private var smallOrbitsEntity:OrbitsEntity;
		private var largeOrbitsEntity:OrbitsEntity;
		private var gotoMainMenu:Boolean;
		
		public function StartingWorld(toMainMenu:Boolean = false, menuCore:MenuCoreEntity = null) 
		{
			super(10);
			
			gotoMainMenu = toMainMenu;
			
			overlayerEntity = new OverlayerEntity();
			backgroundEntity = new BackgroundEntity();
			if (menuCore != null)
			{
				menuCoreEntity = menuCore;
			}
			else
			{
				menuCoreEntity = new MenuCoreEntity();
			}
			smallOrbitsEntity = new OrbitsEntity(OrbitsEntity.SMALL);
			largeOrbitsEntity = new OrbitsEntity(OrbitsEntity.LARGE);
		}
		
		override public function StartWorld():void 
		{
			super.StartWorld();
			
			//if (!Global.IsiPhone4())
			{
				AddEntity(overlayerEntity);
			}
			AddEntity(backgroundEntity);
			AddEntity(menuCoreEntity);
			AddEntity(smallOrbitsEntity);
			AddEntity(largeOrbitsEntity);
			
			if (gotoMainMenu)
			{
				menuCoreEntity.Enlarge(null);
				AddEntity(new MainMenuEntity(backgroundEntity, menuCoreEntity));
			}
			else if (Global.firstRun)
			{
				Global.firstRun = false;
				AddEntity(new HeadphonesEntity(backgroundEntity, menuCoreEntity));
			}
			else
			{
				AddEntity(new AtomicPlusEntity(backgroundEntity, menuCoreEntity));
			}
		}
		
		override public function Update():void 
		{
			super.Update();
		}
	}

}