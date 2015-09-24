package AmidosEngine 
{
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Layer extends Sprite
	{
		private var updateList:Vector.<BaseEntity>;
		
		public function Layer() 
		{
			updateList = new Vector.<BaseEntity>();
		}
		
		public function AddEntity(entity:BaseEntity):void
		{
			updateList.push(entity);
			addChild(entity);
		}
		
		public function RemoveEntity(entity:BaseEntity):void
		{
			//for (var i:int = 0; i < updateList.length; i++) 
			//{
				//if (updateList[i] == entity)
				//{
					//removeList.push(i);
				//}
			//}
			
			entity.isRemoved = true;
		}
		
		public function RemoveAllEntities():void
		{
			removeChildren();
			updateList.length = 0;
		}
		
		public function Update():void
		{
			for (var i:int = 0; i < updateList.length; i++) 
			{
				if (updateList[i].isCreated)
				{
					updateList[i].isCreated = false;
					updateList[i].RenderMissingFrame();
				}
				else
				{
					if (!updateList[i].isRemoved)
					{
						updateList[i].Update();
					}
				}
			}
			
			for (var j:int = updateList.length - 1; j >= 0; j--) 
			{
				if (updateList[j].isRemoved)
				{
					removeChild(updateList[j]);
					updateList.splice(j, 1);
				}
			}
		}
	}

}