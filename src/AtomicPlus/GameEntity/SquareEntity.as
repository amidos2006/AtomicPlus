package AtomicPlus.GameEntity 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.Engine;
	import AmidosEngine.GraphicsLoader;
	import AmidosEngine.HitBoxDrawer;
	import AtomicPlus.CollisionName;
	import AtomicPlus.GameDifficulty;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class SquareEntity extends BaseEntity
	{
		private const DAMAGE_RESTORED_EASY:int = -10;
		private const DAMAGE_RESTORED_HARD:int = -30;
		private const HITBOX_CORRECTION:int = 2;
		
		public var currentOrbitNumber:int;
		public var currentAngle:Number;
		public var damageRestored:Number;
		
		private var rotationSpeed:Number;
		private var scaleSpeed:Number;
		
		public function SquareEntity(orbitNumber:int, angle:Number) 
		{	
			currentOrbitNumber = orbitNumber;
			currentAngle = angle;
			if (Global.gameDifficulty == GameDifficulty.EASY)
			{
				damageRestored = DAMAGE_RESTORED_EASY;
			}
			else if (Global.gameDifficulty == GameDifficulty.HARD)
			{
				damageRestored = DAMAGE_RESTORED_HARD;
			}
			
			var radiusLength:Number = Global.GetCurrentOrbitRadius(orbitNumber) * GraphicsLoader.ConversionRatio;
			var radianAngle:Number = angle * Math.PI / 180;
			
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio + radiusLength * Math.cos(radianAngle);
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio + radiusLength * Math.sin(radianAngle);
			
			bitmap = new Image(GraphicsLoader.GetGraphics("box" + Global.GetCurrentColorNumber()));
			CenterOO();
			
			scaleX = 0;
			scaleY = scaleX;
			scaleSpeed = 0.1;
			
			rotation = Global.GetRandom(360);
			rotationSpeed = 10 * Math.PI / 180;
			
			layer = LayerConstant.SQUARE_LAYER;
			
			SetHitBox((Global.BOX_LENGTH - HITBOX_CORRECTION) * GraphicsLoader.ConversionRatio, 
						(Global.BOX_LENGTH - HITBOX_CORRECTION) * GraphicsLoader.ConversionRatio, 
						-(Global.BOX_LENGTH - HITBOX_CORRECTION) / 2 * GraphicsLoader.ConversionRatio, 
						-(Global.BOX_LENGTH - HITBOX_CORRECTION) / 2 * GraphicsLoader.ConversionRatio);
			collisionName = CollisionName.SQUARE_NAME;
		}
		
		override public function Added():void 
		{
			super.Added();
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			Engine.currentWorld.AddEntity(new SquareDeathEntity(this));
		}
		
		override public function Update():void 
		{
			super.Update();
			
			rotation += rotationSpeed;
			
			scaleX += scaleSpeed;
			if (scaleX > 1)
			{
				scaleX = 1;
			}
			scaleY = scaleX;
		}
	}

}