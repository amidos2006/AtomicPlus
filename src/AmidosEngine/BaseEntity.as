package AmidosEngine 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BaseEntity extends Sprite
	{
		public var bitmap:Image;
		public var layer:int;
		
		public var collisionRect:Rectangle;
		public var collisionName:String;
		public var isCreated:Boolean;
		public var isRemoved:Boolean;
		
		public function BaseEntity() 
		{
			layer = 0;
			collisionName = "";
			isCreated = true;
			isRemoved = false;
		}
		
		public function Added():void
		{
			if (bitmap != null)
			{
				addChild(bitmap);
			}
		}
		
		public function Removed():void
		{
			if (bitmap != null)
			{
				removeChild(bitmap);
			}
		}
		
		public function CenterOO():void
		{
			bitmap.x = -bitmap.width / 2;
			bitmap.y = -bitmap.height / 2;
		}
		
		public function SetHitBox(width:int, height:int, x:int = 0, y:int = 0):void
		{
			collisionRect = new Rectangle(x, y, width, height);
		}
		
		public function CheckCollision(nameCheck:String, xCheck:int, yCheck:int):BaseEntity
		{
			return Engine.currentWorld.CheckCollision(nameCheck, xCheck, yCheck, this);
		}
		
		public function CheckCollisionWithPoint(xPoint:int, yPoint:int, xCheck:int, yCheck:int):Boolean
		{
			var thisHitBox:Rectangle = new Rectangle(collisionRect.x + xCheck, collisionRect.y + yCheck, 
														collisionRect.width, collisionRect.height);
			return thisHitBox.containsPoint(new Point(xPoint, yPoint));
		}
		
		public function CheckCollisionWithEntity(xCheck:int, yCheck:int, other:BaseEntity):Boolean
		{
			var thisHitBox:Rectangle = new Rectangle(collisionRect.x + xCheck, collisionRect.y + yCheck, 
														collisionRect.width, collisionRect.height);
			var otherHitBox:Rectangle = new Rectangle(other.collisionRect.x + other.x, other.collisionRect.y + other.y, 
														other.collisionRect.width, other.collisionRect.height);
			return thisHitBox.intersects(otherHitBox);
		}
		
		public function Update():void
		{
			
		}
		
		public function RenderMissingFrame():void
		{
			
		}
	}

}