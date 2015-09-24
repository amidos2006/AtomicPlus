package AtomicPlus.GameEntity 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.Engine;
	import AmidosEngine.GraphicsLoader;
	import AtomicPlus.Global;
	/**
	 * ...
	 * @author Amidos
	 */
	public class SquareSpawnerEntity extends BaseEntity
	{
		private const ANGLE_VALUE:int = 45;
		
		private var currentSquareEntity:SquareEntity;
		
		public function SquareSpawnerEntity() 
		{
			currentSquareEntity = null;
		}
		
		public function GenerateSquare(oldOrbitNumber:int, oldAngle:Number):void
		{
			var newOrbitNumber:int = (oldOrbitNumber + Global.GetRandom(Global.NUMBER_OF_ORBITS - 1) + 1) % Global.NUMBER_OF_ORBITS;
			var newAngle:int = (oldAngle + 180 - ANGLE_VALUE + Global.GetRandom(2 * ANGLE_VALUE)) % 360;
			
			currentSquareEntity = new SquareEntity(newOrbitNumber, newAngle);
			Engine.currentWorld.AddEntity(currentSquareEntity);
		}
		
		public function GetCurrentSquareOrbit():int
		{
			if (currentSquareEntity != null)
			{
				return currentSquareEntity.currentOrbitNumber;
			}
			return 0;
		}
		
		public function GetSquareAngle():Number
		{
			if (currentSquareEntity != null)
			{
				var centerX:Number = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
				var centerY:Number = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
				var angle:Number = Math.atan2(currentSquareEntity.y - centerY, currentSquareEntity.x - centerX) * 180 / Math.PI;
				
				return angle;
			}
			return 0;
		}
		
		public function DestroyAllSquares():void
		{
			if (currentSquareEntity != null)
			{
				Engine.currentWorld.RemoveEntity(currentSquareEntity);
				currentSquareEntity = null;
			}
		}
	}

}