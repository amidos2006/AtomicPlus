package AtomicPlus.GameEntity 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.Engine;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class SquareDeathEntity extends BaseEntity
	{
		private var alphaSpeed:Number;
		private var scaleSpeed:Number;
		
		public function SquareDeathEntity(squareEntity:SquareEntity) 
		{
			x = squareEntity.x;
			y = squareEntity.y;
			
			alphaSpeed = -0.15;
			scaleSpeed = 0.3;
			
			bitmap = new Image(squareEntity.bitmap.texture);
			CenterOO();
			
			alpha = 1;
			scaleX = 1;
			scaleY = scaleX;
			
			rotation = squareEntity.rotation;
			layer = LayerConstant.EFFECT_LAYER;
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
				return;
			}
		}
	}

}