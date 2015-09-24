package AmidosEngine 
{
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.Font;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import flash.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Engine extends Sprite
	{
		[Embed(source = "../../assets/visitor1.ttf", embedAsCFF = "false", fontFamily = 'gameFont')]private static var fontClass:Class;
		public static var font:Font = new fontClass() as Font;
		
		public static var mainSprite:Sprite;
		public static var currentWorld:BaseWorld;
		public static var nextWorld:BaseWorld;
		
		public function Engine():void
		{
			mainSprite = this;
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, Update);
			
			//New Controls
			Starling.current.stage.addEventListener(starling.events.TouchEvent.TOUCH, onTouch);
			//Old Controls
			//Main.currentStage.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN, touchBegin);
			//Main.currentStage.addEventListener(flash.events.TouchEvent.TOUCH_END, touchEnd);
		}
		
		public static function Intialize():void
		{
			currentWorld = null;
			nextWorld = null;
		}
		
		public static function Update(e:EnterFrameEvent):void
		{
			TouchControl.Update();
			AlarmSystem.Update();
			
			if (currentWorld != nextWorld)
			{
				if (currentWorld != null)
				{
					currentWorld.EndWorld();
					mainSprite.removeChild(currentWorld);
				}
				
				currentWorld = nextWorld;
				currentWorld.StartWorld();
				mainSprite.addChild(currentWorld);
			}
			
			if (currentWorld != null)
			{
				currentWorld.Update();
			}
		}
		
		private function onTouch(event:starling.events.TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.BEGAN);
			var i:int = 0;
			var j:int = 0;
			var localPos:Point;
			
			if (touches.length > 0)
			{
				for (i = 0; i < touches.length; i++) 
				{
					localPos = touches[i].getLocation(Starling.current.stage);
					TouchControl.UpdateTouchBegin(touches[i].id, new Point(localPos.x, localPos.y));
					
				}
			}
			
			touches = event.getTouches(this, TouchPhase.ENDED);
			i = 0;
			j = 0;
			if (touches.length > 0)
			{
				for (i = 0; i < touches.length; i++) 
				{
					localPos = touches[i].getLocation(this);
					TouchControl.UpdateTouchEnd(touches[i].id, new Point(localPos.x, localPos.y));
				}
			}
		}
		
		private function touchBegin(touchEvent:flash.events.TouchEvent):void
		{
			TouchControl.UpdateTouchBegin(touchEvent.touchPointID, new Point(touchEvent.stageX, touchEvent.stageY));
		}
		
		private function touchEnd(touchEvent:flash.events.TouchEvent):void
		{
			TouchControl.UpdateTouchEnd(touchEvent.touchPointID, new Point(touchEvent.stageX, touchEvent.stageY));
		}
	}

}