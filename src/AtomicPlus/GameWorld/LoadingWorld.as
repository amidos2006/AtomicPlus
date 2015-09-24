package AtomicPlus.GameWorld 
{
	import AmidosEngine.AlarmSystem;
	import AmidosEngine.BaseWorld;
	import AmidosEngine.Engine;
	import AmidosEngine.GraphicsLoader;
	import AmidosEngine.MusicLoader;
	import AmidosEngine.SoundLoader;
	import AmidosEngine.TouchControl;
	import AtomicPlus.GameEntity.*;
	import AtomicPlus.GameEntity.GameMenu.*;
	import AtomicPlus.Global;
	import flash.display.Bitmap;
	import flash.display.StageQuality;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author Amidos
	 */
	public class LoadingWorld extends BaseWorld
	{
		private var outerParts:int;
		private var innerParts:int;
		private var maxInnerParts:int;
		
		public function LoadingWorld(toMainMenu:Boolean = false, menuCore:MenuCoreEntity = null) 
		{
			super(10);
			
			innerParts = 0;
			maxInnerParts = GraphicsLoader.MaxLoadingParts;
			outerParts = 0;
		}
		
		override public function StartWorld():void 
		{
			super.StartWorld();
			
			GraphicsLoader.Intialize(Main.fullScreenWidth, Main.fullScreenHeight);
		}
		
		override public function EndWorld():void 
		{
			super.EndWorld();
			
			Main.currentStage.removeChild(Main.currentLoadingScreen);
		}
		
		override public function Update():void 
		{
			super.Update();
			
			switch (outerParts) 
			{
				case 0:
					Main.currentStage.quality = StageQuality.BEST;
					GraphicsLoader.IntializeByParts(innerParts);
					Main.currentStage.quality = StageQuality.LOW;
					break;
				case 1:
					SoundLoader.Intialize();
					break;
				case 2:
					MusicLoader.Intialize();
					MusicLoader.MusicVolume = 0.5;
					break;
				case 3:
					Engine.nextWorld = new StartingWorld();
					break;
			}
			
			innerParts += 1;
			if (innerParts >= maxInnerParts)
			{
				innerParts = 0;
				outerParts += 1;
				maxInnerParts = 1;
			}
		}
	}

}