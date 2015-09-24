package AtomicPlus.GameEntity 
{
	import AmidosEngine.Alarm;
	import AmidosEngine.BaseEntity;
	import AmidosEngine.Engine;
	import AmidosEngine.GraphicsLoader;
	import AmidosEngine.HitBoxDrawer;
	import AmidosEngine.MusicLoader;
	import AmidosEngine.Sfx;
	import AmidosEngine.SoundLoader;
	import AmidosEngine.TouchControl;
	import AtomicPlus.CollisionName;
	import AtomicPlus.GameDifficulty;
	import AtomicPlus.GameEntity.BulletGenerator.BaseBulletEntity;
	import AtomicPlus.GameEntity.BulletGenerator.BaseShooterEntity;
	import AtomicPlus.GameplayType;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class PlayerEntity extends BaseEntity
	{
		private const HITBOX_CORRECTION:int = 2;
		private const MIN_DIFF_DAMAGE:Number = 0.25;
		private const MAX_DIFF_DAMAGE:Number = 1;
		private const MAX_NUMBER_SCORE:Number = 50;
		
		private var backgroundEntity:BackgroundEntity;
		private var mainOrbitEntity:MainOrbitEntity;
		private var squareSpawnerEntity:SquareSpawnerEntity;
		private var coreEntity:CoreEntity;
		private var hitEntity:HitOverlayerEntity;
		private var colorTransform:ColorTransform;
		private var scaleSpeed:Number;
		private var difficultyDamage:Number;
		
		private var boxSfx:Sfx;
		private var dieSfx:Sfx;
		private var hitLowSfx:Sfx;
		private var hitHighSfx:Sfx;
		
		public var radius:Number;
		public var radiusSpeed:Number;
		public var fixedRadiusSpeed:Number;
		public var targetOrbitDirection:int;
		public var targetOrbit:int;
		public var angle:Number;
		public var angleSpeed:Number;
		public var fixedAngleSpeed:Number;
		public var frontBitmap:Image;
		public var damage:Number;
		public var maxDamage:Number;
		public var currentRotationDirection:int;
		
		public function PlayerEntity(background:BackgroundEntity, mainOrbit:MainOrbitEntity, squareSpawner:SquareSpawnerEntity, core:CoreEntity, hitLayer:HitOverlayerEntity) 
		{	
			backgroundEntity = background;
			mainOrbitEntity = mainOrbit;
			squareSpawnerEntity = squareSpawner;
			coreEntity = core;
			hitEntity = hitLayer;
			
			boxSfx = new Sfx(SoundLoader.GetSound("box"));
			dieSfx = new Sfx(SoundLoader.GetSound("explosion"));
			hitLowSfx = new Sfx(SoundLoader.GetSound("hitlow"));
			hitHighSfx = new Sfx(SoundLoader.GetSound("hithigh"));
			
			radius = Global.MIN_RADIUS;
			radiusSpeed = -10;
			if (Global.gameplayType == GameplayType.ORBITAL || Global.gameplayType == GameplayType.FIXER || 
				Global.gameplayType == GameplayType.FIXORBITAL)
			{
				radiusSpeed = -5;
			}
			fixedRadiusSpeed = radiusSpeed;
			angle = -90;
			angleSpeed = 7;
			fixedAngleSpeed = angleSpeed;
			targetOrbit = 0;
			targetOrbitDirection = 1;
			scaleSpeed = 0.1;
			currentRotationDirection = 1;
			damage = 0;
			difficultyDamage = MIN_DIFF_DAMAGE;
			maxDamage = 100;
			
			colorTransform = new ColorTransform();
			
			bitmap = new Image(GraphicsLoader.GetGraphics("playerback"));
			CenterOO();
			layer = LayerConstant.PLAYER_LAYER;
			
			frontBitmap = new Image(GraphicsLoader.GetGraphics("playerfront"));
			frontBitmap.x = bitmap.x;
			frontBitmap.y = bitmap.y;
			
			scaleX = 0;
			scaleY = scaleX;
			
			SetHitBox(2 * (Global.PLAYER_RADIUS - HITBOX_CORRECTION) * GraphicsLoader.ConversionRatio, 
						2 * (Global.PLAYER_RADIUS - HITBOX_CORRECTION) * GraphicsLoader.ConversionRatio, 
						-(Global.PLAYER_RADIUS - HITBOX_CORRECTION) * GraphicsLoader.ConversionRatio, 
						-(Global.PLAYER_RADIUS - HITBOX_CORRECTION) * GraphicsLoader.ConversionRatio);
			collisionName = CollisionName.PLAYER_NAME;
		}
		
		override public function Added():void 
		{
			super.Added();
			
			bitmap.color = backgroundEntity.GetCurrentBackColor();
			addChild(frontBitmap);
			
			squareSpawnerEntity.GenerateSquare(0, angle);
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			removeChild(frontBitmap);
			
			dieSfx.play();
			MusicLoader.StopRunningMusic();
			Engine.currentWorld.AddEntity(new PlayerDeathEntity(this, coreEntity));
			mainOrbitEntity.Destroy();
			squareSpawnerEntity.DestroyAllSquares();
			Global.playerEntity = null;
		}
		
		private function UpdatePosition():void
		{
			if (Global.gameplayType == GameplayType.ORBITAL || Global.gameplayType == GameplayType.FIXER || 
				Global.gameplayType == GameplayType.FIXORBITAL)
			{
				radius += radiusSpeed;
				if (radius < Global.MIN_RADIUS)
				{
					radius = Global.MIN_RADIUS;
					radiusSpeed *= -1;
				}
				if (radius > Global.MAX_RADIUS)
				{
					radius = Global.MAX_RADIUS;
					radiusSpeed *= -1;
				}
			}
			else if (Global.gameplayType == GameplayType.DISCRETE || Global.gameplayType == GameplayType.DISCONE)
			{
				var targetRadius:Number = Global.GetCurrentOrbitRadius(targetOrbit);
				if (targetRadius > radius)
				{
					radiusSpeed = Math.abs(radiusSpeed);
					radius += radiusSpeed;
					if (radius > targetRadius)
					{
						radius = targetRadius;
					}
				}
				if (targetRadius < radius)
				{
					radiusSpeed = -Math.abs(radiusSpeed);
					radius += radiusSpeed;
					if (radius < targetRadius)
					{
						radius = targetRadius;
					}
				}
			}
			else
			{
				radius += radiusSpeed;
				if (radius < Global.MIN_RADIUS)
				{
					radius = Global.MIN_RADIUS;
				}
				if (radius > Global.MAX_RADIUS)
				{
					radius = Global.MAX_RADIUS;
				}
			}
			
			angle += currentRotationDirection * angleSpeed;
			if (angle < 0)
			{
				angle += 360;
			}
			if (angle >= 360)
			{
				angle -= 360;
			}
			
			var radianAngle:Number = angle * Math.PI / 180;
			
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio + radius * GraphicsLoader.ConversionRatio * Math.cos(radianAngle);
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio + radius * GraphicsLoader.ConversionRatio * Math.sin(radianAngle);
		}
		
		private function UpdateControls():void
		{
			switch (Global.gameplayType) 
			{
				case GameplayType.AUTO:
					if (TouchControl.TouchPressed(TouchControl.ANY_SCREEN) || TouchControl.TouchDown(TouchControl.ANY_SCREEN))
					{
						radiusSpeed = Math.abs(radiusSpeed);
					}
					if (TouchControl.TouchUp(TouchControl.ANY_SCREEN))
					{
						radiusSpeed = -Math.abs(radiusSpeed);
					}
					break;
				case GameplayType.ORBITAL:
					if (TouchControl.TouchPressed(TouchControl.ANY_SCREEN) || TouchControl.TouchDown(TouchControl.ANY_SCREEN))
					{
						angleSpeed = -Math.abs(angleSpeed);
					}
					if (TouchControl.TouchUp(TouchControl.ANY_SCREEN))
					{
						angleSpeed = Math.abs(angleSpeed);
					}
					break;
				case GameplayType.FIXER:
					if (radiusSpeed != 0)
					{
						fixedRadiusSpeed = radiusSpeed;
						fixedAngleSpeed = angleSpeed;
					}
					if (TouchControl.TouchPressed(TouchControl.ANY_SCREEN) || TouchControl.TouchDown(TouchControl.ANY_SCREEN))
					{
						radiusSpeed = 0;
						angleSpeed = 1.25 * fixedAngleSpeed;
					}
					if (TouchControl.TouchUp(TouchControl.ANY_SCREEN))
					{
						radiusSpeed = fixedRadiusSpeed;
						angleSpeed = fixedAngleSpeed;
					}
					break;
				case GameplayType.FULL:
					if (TouchControl.TouchPressed(TouchControl.RIGHT_SCREEN) || TouchControl.TouchDown(TouchControl.RIGHT_SCREEN))
					{
						radiusSpeed = Math.abs(radiusSpeed);
					}
					if (TouchControl.TouchUp(TouchControl.RIGHT_SCREEN))
					{
						radiusSpeed = -Math.abs(radiusSpeed);
					}
					
					if (TouchControl.TouchPressed(TouchControl.LEFT_SCREEN) || TouchControl.TouchDown(TouchControl.LEFT_SCREEN))
					{
						angleSpeed = -Math.abs(angleSpeed);
					}
					if (TouchControl.TouchUp(TouchControl.LEFT_SCREEN))
					{
						angleSpeed = Math.abs(angleSpeed);
					}
					break;
				case GameplayType.RADIOFIXER:
					if (radiusSpeed != 0)
					{
						fixedRadiusSpeed = radiusSpeed;
						fixedAngleSpeed = angleSpeed;
					}
					if (TouchControl.TouchPressed(TouchControl.LEFT_SCREEN) || TouchControl.TouchDown(TouchControl.LEFT_SCREEN))
					{
						radiusSpeed = 0;
						angleSpeed = 1.25 * fixedAngleSpeed;
					}
					
					if (TouchControl.TouchPressed(TouchControl.RIGHT_SCREEN) || TouchControl.TouchDown(TouchControl.RIGHT_SCREEN))
					{
						radiusSpeed = Math.abs(fixedRadiusSpeed);
						angleSpeed = fixedAngleSpeed;
					}
					if (TouchControl.TouchUp(TouchControl.RIGHT_SCREEN) && TouchControl.TouchUp(TouchControl.LEFT_SCREEN))
					{
						radiusSpeed = -Math.abs(fixedRadiusSpeed);
						angleSpeed = fixedAngleSpeed;
					}
					break;
				case GameplayType.FIXORBITAL:
					if (radiusSpeed != 0)
					{
						fixedRadiusSpeed = radiusSpeed;
						fixedAngleSpeed = angleSpeed;
					}
					if (TouchControl.TouchPressed(TouchControl.RIGHT_SCREEN) || TouchControl.TouchDown(TouchControl.RIGHT_SCREEN))
					{
						radiusSpeed = 0;
						angleSpeed = 1.25 * fixedAngleSpeed;
					}
					if (TouchControl.TouchUp(TouchControl.RIGHT_SCREEN))
					{
						radiusSpeed = fixedRadiusSpeed;
						angleSpeed = fixedAngleSpeed;
					}
					
					if (TouchControl.TouchPressed(TouchControl.LEFT_SCREEN) || TouchControl.TouchDown(TouchControl.LEFT_SCREEN))
					{
						angleSpeed = -Math.abs(angleSpeed);
					}
					if (TouchControl.TouchUp(TouchControl.LEFT_SCREEN))
					{
						angleSpeed = Math.abs(angleSpeed);
					}
					break;
				case GameplayType.DISCONE:
					if (TouchControl.TouchPressed(TouchControl.ANY_SCREEN))
					{
						targetOrbit += targetOrbitDirection;
						if (targetOrbit > Global.NUMBER_OF_ORBITS - 1)
						{
							targetOrbitDirection *= -1;
							targetOrbit = Global.NUMBER_OF_ORBITS - 2;
						}
						
						if (targetOrbit < 0)
						{
							targetOrbitDirection *= -1;
							targetOrbit = 1;
						}
					}
					break;
				case GameplayType.DISCRETE:
					if (TouchControl.TouchPressed(TouchControl.RIGHT_SCREEN))
					{
						targetOrbit += 1;
						if (targetOrbit > Global.NUMBER_OF_ORBITS - 1)
						{
							targetOrbit = Global.NUMBER_OF_ORBITS - 1;
						}
					}
					
					if (TouchControl.TouchPressed(TouchControl.LEFT_SCREEN))
					{
						targetOrbit -= 1;
						if (targetOrbit < 0)
						{
							targetOrbit = 0;
						}
					}
					break;
				case GameplayType.MANUAL:
					if (radiusSpeed != 0)
					{
						fixedRadiusSpeed = radiusSpeed;
					}
					if (TouchControl.TouchPressed(TouchControl.RIGHT_SCREEN) || TouchControl.TouchDown(TouchControl.RIGHT_SCREEN))
					{
						radiusSpeed = Math.abs(fixedRadiusSpeed);
					}
					
					if (TouchControl.TouchPressed(TouchControl.LEFT_SCREEN) || TouchControl.TouchDown(TouchControl.LEFT_SCREEN))
					{
						radiusSpeed = -Math.abs(fixedRadiusSpeed);
					}
					
					if (TouchControl.TouchUp(TouchControl.RIGHT_SCREEN) && TouchControl.TouchUp(TouchControl.LEFT_SCREEN))
					{
						radiusSpeed = 0;
					}
					break;
				case GameplayType.MANUALFULL:
					if (radiusSpeed != 0)
					{
						fixedRadiusSpeed = radiusSpeed;
					}
					
					var rightScreenPressed:Boolean = TouchControl.TouchPressed(TouchControl.RIGHT_SCREEN) || TouchControl.TouchDown(TouchControl.RIGHT_SCREEN);
					var leftScreenPressed:Boolean = TouchControl.TouchPressed(TouchControl.LEFT_SCREEN) || TouchControl.TouchDown(TouchControl.LEFT_SCREEN);
					
					if (rightScreenPressed && leftScreenPressed)
					{
						angleSpeed = -Math.abs(angleSpeed);
						radiusSpeed = 0;
					}
					else
					{
						angleSpeed = Math.abs(angleSpeed);
						if (rightScreenPressed)
						{
							radiusSpeed = Math.abs(fixedRadiusSpeed);
						}
						
						if (leftScreenPressed)
						{
							radiusSpeed = -Math.abs(fixedRadiusSpeed);
						}
					}
					
					if (TouchControl.TouchUp(TouchControl.RIGHT_SCREEN) && TouchControl.TouchUp(TouchControl.LEFT_SCREEN))
					{
						angleSpeed = Math.abs(angleSpeed);
						radiusSpeed = 0;
					}
					break;
			}
		}
		
		override public function Update():void 
		{
			super.Update();
			
			UpdateControls();
			UpdatePosition();
			
			mainOrbitEntity.radius = radius;
			mainOrbitEntity.Render();
			
			scaleX += scaleSpeed;
			if (scaleX > 1)
			{
				scaleX = 1;
			}
			scaleY = scaleX;
			
			var squareEntity:SquareEntity = CheckCollision(CollisionName.SQUARE_NAME, x, y) as SquareEntity;
			if (squareEntity)
			{
				boxSfx.play();
				Global.score += 1;
				Engine.currentWorld.RemoveEntity(squareEntity);
				if (Global.gameplayType == GameplayType.AUTO || Global.gameplayType == GameplayType.FIXER || 
					Global.gameplayType == GameplayType.RADIOFIXER || Global.gameplayType == GameplayType.DISCONE ||
					Global.gameplayType == GameplayType.DISCRETE || Global.gameplayType == GameplayType.MANUAL)
				{
					currentRotationDirection *= -1;
				}
				damage += squareEntity.damageRestored;
				backgroundEntity.ChangeBackgroundColor();
				squareSpawnerEntity.GenerateSquare(squareEntity.currentOrbitNumber, squareEntity.currentAngle);
				coreEntity.ChangeShooter();
			}
			
			var bulletEntity:BaseBulletEntity = CheckCollision(CollisionName.BULLET_NAME, x, y) as BaseBulletEntity;
			if (bulletEntity)
			{
				damage += bulletEntity.damage;
				if (damage <= maxDamage / 2)
				{
					hitLowSfx.play();
				}
				else
				{
					hitHighSfx.play();
				}
				hitEntity.GotHit();
				Engine.currentWorld.RemoveEntity(bulletEntity);
			}
			
			bitmap.color = backgroundEntity.GetCurrentBackColor();
			
			if (Global.gameDifficulty == GameDifficulty.HARD)
			{
				difficultyDamage = Math.min(MIN_DIFF_DAMAGE + (Global.score / MAX_NUMBER_SCORE) * (MAX_DIFF_DAMAGE - MIN_DIFF_DAMAGE), 1);
				damage += difficultyDamage;
			}
			if (damage >= maxDamage)
			{
				damage = maxDamage;
				Engine.currentWorld.RemoveEntity(this);
			}
			if (damage < 0)
			{
				damage = 0;
			}
		}
	}

}