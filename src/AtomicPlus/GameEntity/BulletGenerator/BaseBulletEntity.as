package AtomicPlus.GameEntity.BulletGenerator 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.Engine;
	import AmidosEngine.GraphicsLoader;
	import AtomicPlus.CollisionName;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BaseBulletEntity extends BaseEntity
	{	
		public var rotationDirection:int;
		public var damage:int;
		
		public function BaseBulletEntity(xIn:Number, yIn:Number) 
		{
			x = xIn;
			y = yIn;
			
			rotationDirection = 1;
			damage = 10;
			
			bitmap = new Image(GraphicsLoader.GetGraphics("bullet"));
			CenterOO();
			
			layer = LayerConstant.BULLET_LAYER;
			
			SetHitBox(bitmap.width, bitmap.height, bitmap.x, bitmap.y);
			collisionName = CollisionName.BULLET_NAME;
		}
		
		override public function Update():void 
		{
			super.Update();
			
			if (x < -bitmap.width || x > GraphicsLoader.Width + bitmap.width || 
				y < -bitmap.height || y > GraphicsLoader.Height + bitmap.height)
			{
				Engine.currentWorld.RemoveEntity(this);
			}
		}
	}

}