package AtomicPlus.GameEntity 
{
	import AmidosEngine.Alarm;
	import AmidosEngine.AlarmSystem;
	import AmidosEngine.BaseEntity;
	import AmidosEngine.Engine;
	import AmidosEngine.GraphicsLoader;
	import AmidosEngine.Sfx;
	import AmidosEngine.SoundLoader;
	import AmidosEngine.TouchControl;
	import AtomicPlus.GameEntity.BulletGenerator.BaseShooterEntity;
	import AtomicPlus.GameEntity.BulletGenerator.LinearBulletEntity;
	import AtomicPlus.GameEntity.BulletGenerator.RotationalBulletEntity;
	import AtomicPlus.GameEntity.BulletGenerator.ShooterRateOfShooting;
	import AtomicPlus.GameEntity.BulletGenerator.ShooterSpawnerMovement;
	import AtomicPlus.GameEntity.BulletGenerator.SinBulletEntity;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class CoreEntity extends BaseEntity
	{
		private const ENTERING:int = 0;
		private const INGAME:int = 1;
		private const STARTING_ALARM:Number = 200;
		
		private var shootSfx:Sfx;
		
		private var minScale:Number;
		private var shootingScale:Number;
		private var maxScale:Number;
		private var scaleSpeed:Number;
		private var enteringScaleSpeed:Number;
		private var exititngScaleSpeed:Number;
		private var state:int;
		
		private var shootingAlarm:Alarm;
		private var shootingTime:Number;
		private var currentShooter:BaseShooterEntity;
		private var squareSpawnerEntity:SquareSpawnerEntity;
		
		public function CoreEntity(squareSpawner:SquareSpawnerEntity) 
		{
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			squareSpawnerEntity = squareSpawner;
			
			state = ENTERING;
			
			shootSfx = new Sfx(SoundLoader.GetSound("shooting"));
			
			minScale = Global.CORE_RADIUS / (Global.GetCurrentOrbitRadius(1) + 30);
			shootingScale = minScale + 30 / (Global.GetCurrentOrbitRadius(1) + 30);
			maxScale = 1;
			scaleSpeed = -0.025;
			enteringScaleSpeed = -0.1;
			exititngScaleSpeed = 0.1;
			
			bitmap = new Image(GraphicsLoader.GetGraphics("core"));
			
			bitmap.scaleX = maxScale;
			bitmap.scaleY = bitmap.scaleX;
			CenterOO();
			
			shootingAlarm = new Alarm(STARTING_ALARM, Shoot, Alarm.LOOPING);
			ChangeShooter();
			
			layer = LayerConstant.CORE_LAYER;
		}
		
		override public function Added():void 
		{
			super.Added();
			AlarmSystem.AddAlarm(shootingAlarm, true);
		}
		
		override public function Removed():void 
		{
			super.Removed();
			StopShooting();
			AlarmSystem.RemoveAlarm(shootingAlarm);
		}
		
		public function Shoot():void
		{
			shootSfx.play();
			if (Global.playerEntity != null)
			{
				currentShooter.SetRotationDirection(Global.playerEntity.currentRotationDirection);
			}
			currentShooter.Shoot();
			shootingAlarm.ChangeTime(shootingTime);
			
			bitmap.scaleX = shootingScale;
			bitmap.scaleY = bitmap.scaleX;
			CenterOO();
		}
		
		public function ChangeShooter():void
		{
			shootingAlarm.ChangeTime(STARTING_ALARM);
			shootingTime = (Number)(Global.GetaValue(ShooterRateOfShooting.values));
			if (currentShooter != null)
			{
				currentShooter.StopShooting();
			}
			
			var shooterClass:Class = (Class)(Global.GetaValue(ShooterSpawnerMovement.values));
			
			currentShooter = new shooterClass(squareSpawnerEntity);
			var currentDifficulty:int = ShooterSpawnerMovement.GetDiffculty(shooterClass) + 
				ShooterRateOfShooting.GetDiffculty(shootingTime) * currentShooter.GetDifficulty();
			if (!DiffcultyCurve.CorrectDifficulty(Global.score, currentDifficulty))
			{
				ChangeShooter();
			}
		}
		
		private function StopShooting():void
		{
			currentShooter.StopShooting();
		}
		
		override public function Update():void 
		{
			super.Update();
			
			switch (state)
			{
				case ENTERING:
					bitmap.scaleX += enteringScaleSpeed;
					if (bitmap.scaleX < minScale)
					{
						bitmap.scaleX = minScale;
						state = INGAME;
					}
					bitmap.scaleY = bitmap.scaleX;
					CenterOO();
					break;
				case INGAME:
					bitmap.scaleX += scaleSpeed;
					if (bitmap.scaleX < minScale)
					{
						bitmap.scaleX = minScale;
					}
					bitmap.scaleY = bitmap.scaleX;
					CenterOO();
					break;
			}
		}
	}

}