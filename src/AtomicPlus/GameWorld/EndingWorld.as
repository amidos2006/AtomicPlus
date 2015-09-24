package AtomicPlus.GameWorld 
{
	import AmidosEngine.BaseWorld;
	import AmidosEngine.Engine;
	import AmidosEngine.GraphicsLoader;
	import AmidosEngine.Text;
	import AmidosEngine.TouchControl;
	import AtomicPlus.GameEntity.*;
	import AtomicPlus.GameEntity.GameMenu.*;
	import AtomicPlus.Global;
	/**
	 * ...
	 * @author Amidos
	 */
	public class EndingWorld extends BaseWorld
	{
		private var overlayerEntity:OverlayerEntity;
		private var backgroundEntity:BackgroundEntity;
		private var menuCoreEntity:MenuCoreEntity;
		private var smallOrbitsEntity:OrbitsEntity;
		private var largeOrbitsEntity:OrbitsEntity;
		private var endingEntity:EndingEntity;
		
		public function EndingWorld() 
		{
			super(10);
			
			overlayerEntity = new OverlayerEntity();
			backgroundEntity = new BackgroundEntity();
			menuCoreEntity = new MenuCoreEntity();
			smallOrbitsEntity = new OrbitsEntity(OrbitsEntity.SMALL);
			largeOrbitsEntity = new OrbitsEntity(OrbitsEntity.LARGE);
			endingEntity = new EndingEntity(backgroundEntity, menuCoreEntity);
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
			AddEntity(endingEntity);
			
			menuCoreEntity.Enlarge(null);
		}
		
		override public function Update():void 
		{
			super.Update();
		}
	}

}