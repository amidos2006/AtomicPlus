package AmidosEngine 
{
	import adobe.utils.CustomActions;
	import starling.display.Sprite;
	import flash.system.System;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BaseWorld extends Sprite
	{
		public var currentNumberOfLayers:int;
		
		private var worldLayers:Vector.<Layer>;
		private var collisionEntities:Array;
		
		public function BaseWorld(numberOfLayers:int)
		{
			currentNumberOfLayers = numberOfLayers;
			
			collisionEntities = new Array();
			worldLayers = new Vector.<Layer>();
			for (var i:int = 0; i < currentNumberOfLayers; i++) 
			{
				worldLayers.push(new Layer());
				addChild(worldLayers[i]);
			}
		}
		
		public function StartWorld():void
		{
			
		}
		
		public function EndWorld():void
		{
			for (var i:int = 0; i < worldLayers.length; i++) 
			{
				worldLayers[i].RemoveAllEntities();
				removeChild(worldLayers[i]);
			}
			worldLayers.length = 0;
			
			for each (var vector:Vector.<BaseEntity> in collisionEntities) 
			{
				vector.length = 0;
			}
			collisionEntities.length = 0;
		}
		
		public function CheckCollision(name:String, xCheck:int, yCheck:int, entity:BaseEntity):BaseEntity
		{
			for each (var other:BaseEntity in collisionEntities[name]) 
			{
				if (entity.CheckCollisionWithEntity(xCheck, yCheck, other))
				{
					return other;
				}
			}
			
			return null;
		}
		
		public function AddEntity(entity:BaseEntity):void
		{
			worldLayers[entity.layer].AddEntity(entity);
			
			if (!(entity.collisionName in collisionEntities))
			{
				collisionEntities[entity.collisionName] = new Vector.<BaseEntity>();
			}
			collisionEntities[entity.collisionName].push(entity);
			
			entity.Added();
		}
		
		public function RemoveEntity(entity:BaseEntity):void
		{
			worldLayers[entity.layer].RemoveEntity(entity);
			
			var collisionList:Vector.<BaseEntity> = collisionEntities[entity.collisionName];
			for (var i:int = 0; i < collisionList.length; i++) 
			{
				if (collisionList[i] == entity)
				{
					collisionList.splice(i, 1);
					break;
				}
			}
			
			entity.Removed();
		}
		
		public function Update():void
		{
			for (var i:int = 0; i < worldLayers.length; i++) 
			{
				worldLayers[i].Update();
			}
		}
	}

}