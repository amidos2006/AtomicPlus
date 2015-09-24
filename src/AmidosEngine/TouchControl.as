package AmidosEngine 
{
	import AtomicPlus.Global;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Amidos
	 */
	public class TouchControl 
	{
		public static const LEFT_SCREEN:int = 0;
		public static const RIGHT_SCREEN:int = 1;
		public static const ANY_SCREEN:int = 2;
		
		private static const UP:int = 0;
		private static const PRESSED:int = 1;
		private static const DOWN:int = 2;
		private static const RELEASED:int = 3;
		
		private static var touchState:Vector.<TouchPoint>;
		
		public static function Intialize():void
		{
			touchState = new Vector.<TouchPoint>();
		}
		
		public static function TouchPressed(position:int):Boolean
		{
			var result:Boolean = false;
			for (var i:int = 0; i < touchState.length; i++) 
			{
				switch (position) 
				{
					case LEFT_SCREEN:
						if (touchState[i].x <= GraphicsLoader.Width * Engine.mainSprite.scaleX / 2)
						{
							result = result || touchState[i].touchState == PRESSED;
						}
						break;
					case RIGHT_SCREEN:
						if (touchState[i].x > GraphicsLoader.Width * Engine.mainSprite.scaleX / 2)
						{
							result = result || touchState[i].touchState == PRESSED;
						}
						break;
					case ANY_SCREEN:
						result = result || touchState[i].touchState == PRESSED;
						break;
				}
			}
			
			return result;
		}
		
		public static function TouchReleased(position:int):Boolean
		{
			var result:Boolean = false;
			for (var i:int = 0; i < touchState.length; i++) 
			{
				switch (position) 
				{
					case LEFT_SCREEN:
						if (touchState[i].x <= GraphicsLoader.Width * Engine.mainSprite.scaleX / 2)
						{
							result = result || touchState[i].touchState == RELEASED;
						}
						break;
					case RIGHT_SCREEN:
						if (touchState[i].x > GraphicsLoader.Width * Engine.mainSprite.scaleX / 2)
						{
							result = result || touchState[i].touchState == RELEASED;
						}
						break;
					case ANY_SCREEN:
						result = result || touchState[i].touchState == RELEASED;
						break;
				}
			}
			
			return result;
		}
		
		public static function TouchUp(position:int):Boolean
		{
			var result:Boolean = true;
			for (var i:int = 0; i < touchState.length; i++) 
			{
				switch (position) 
				{
					case LEFT_SCREEN:
						if (touchState[i].x <= GraphicsLoader.Width * Engine.mainSprite.scaleX / 2)
						{
							result = false;
						}
						break;
					case RIGHT_SCREEN:
						if (touchState[i].x > GraphicsLoader.Width * Engine.mainSprite.scaleX / 2)
						{
							result = false;
						}
						break;
					case ANY_SCREEN:
						result = false;
						break;
				}
			}
			
			return result;
		}
		
		public static function TouchDown(position:int):Boolean
		{
			var result:Boolean = false;
			for (var i:int = 0; i < touchState.length; i++) 
			{
				switch (position) 
				{
					case LEFT_SCREEN:
						if (touchState[i].x <= GraphicsLoader.Width * Engine.mainSprite.scaleX / 2)
						{
							result = result || touchState[i].touchState == DOWN;
						}
						break;
					case RIGHT_SCREEN:
						if (touchState[i].x > GraphicsLoader.Width * Engine.mainSprite.scaleX / 2)
						{
							result = result || touchState[i].touchState == DOWN;
						}
						break;
					case ANY_SCREEN:
						result = result || touchState[i].touchState == DOWN;
						break;
				}
			}
			
			return result;
		}
		
		public static function TouchPressedPoints(position:int):Vector.<Point>
		{
			var points:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < touchState.length; i++) 
			{
				switch (position) 
				{
					case LEFT_SCREEN:
						if (touchState[i].x <= GraphicsLoader.Width / 2 && touchState[i].touchState == PRESSED)
						{
							points.push(new Point(touchState[i].x / Engine.mainSprite.scaleX, touchState[i].y / Engine.mainSprite.scaleY));
						}
						break;
					case RIGHT_SCREEN:
						if (touchState[i].x > GraphicsLoader.Width / 2 && touchState[i].touchState == PRESSED)
						{
							points.push(new Point(touchState[i].x / Engine.mainSprite.scaleX, touchState[i].y / Engine.mainSprite.scaleY));
						}
						break;
					case ANY_SCREEN:
						if(touchState[i].touchState == PRESSED)
						{
							points.push(new Point(touchState[i].x / Engine.mainSprite.scaleX, touchState[i].y / Engine.mainSprite.scaleY));
						}
						break;
				}
			}
			
			return points;
		}
		
		public static function UpdateTouchBegin(id:int, touchPoint:Point):void
		{
			touchState.push(new TouchPoint(id, PRESSED, touchPoint.x, touchPoint.y));
		}
		
		public static function UpdateTouchEnd(id:int, touchPoint:Point):void
		{
			for (var i:int = 0; i < touchState.length; i++) 
			{
				if (touchState[i].touchID == id)
				{
					touchState[i].touchState = RELEASED;
					touchState[i].isNew = true;
				}
			}
		}
		
		public static function Update():void
		{
			var deleteList:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < touchState.length; i++) 
			{
				if (touchState[i].isNew)
				{
					touchState[i].isNew = false;
				}
				else
				{
					if (touchState[i].touchState == PRESSED)
					{
						touchState[i].touchState = DOWN;
					}
					else if (touchState[i].touchState == RELEASED)
					{
						deleteList.push(i);
					}
				}
			}
			
			for (var j:int = 0; j < deleteList.length; j++) 
			{
				touchState.splice(deleteList[j], 1);
			}
		}
	}

}