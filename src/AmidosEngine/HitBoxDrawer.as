package AmidosEngine 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HitBoxDrawer extends Sprite
	{
		
		public function HitBoxDrawer(entity:BaseEntity) 
		{
			graphics.lineStyle(1, 0xFF0000);
			graphics.drawRect(entity.collisionRect.x, entity.collisionRect.y, entity.collisionRect.width, entity.collisionRect.height);
		}
	}

}