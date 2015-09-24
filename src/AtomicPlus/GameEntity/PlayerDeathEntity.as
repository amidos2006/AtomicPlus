package AtomicPlus.GameEntity 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.Engine;
	import AtomicPlus.GameWorld.EndingWorld;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class PlayerDeathEntity extends BaseEntity
	{
		private var alphaSpeed:Number;
		private var scaleSpeed:Number;
		
		private var frontBitmap:Image;
		private var coreEntity:CoreEntity;
		
		public function PlayerDeathEntity(playerEntity:PlayerEntity, core:CoreEntity) 
		{
			x = playerEntity.x;
			y = playerEntity.y;
			
			coreEntity = core;
			
			alphaSpeed = -0.15;
			scaleSpeed = 0.3;
			
			bitmap = new Image(playerEntity.bitmap.texture);
			bitmap.color = playerEntity.bitmap.color;
			CenterOO();
			
			frontBitmap = new Image(playerEntity.frontBitmap.texture);
			frontBitmap.x = bitmap.x;
			frontBitmap.y = bitmap.y;
			
			alpha = 1;
			scaleX = 1;
			scaleY = scaleX;
			
			layer = LayerConstant.EFFECT_LAYER;
		}
		
		override public function Added():void 
		{
			super.Added();
			
			addChild(frontBitmap);
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			removeChild(frontBitmap);
		}
		
		override public function Update():void 
		{
			super.Update();
			
			scaleX += scaleSpeed;
			scaleY = scaleX;
			
			alpha += alphaSpeed;
			if (alpha <= 0)
			{
				Engine.currentWorld.RemoveEntity(this);
				Engine.currentWorld.RemoveEntity(coreEntity);
				Engine.nextWorld = new EndingWorld();
			}
		}
	}

}