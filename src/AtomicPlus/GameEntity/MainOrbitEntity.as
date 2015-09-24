package AtomicPlus.GameEntity 
{
	import adobe.utils.CustomActions;
	import AmidosEngine.BaseEntity;
	import AmidosEngine.Engine;
	import AmidosEngine.GraphicsLoader;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MainOrbitEntity extends BaseEntity
	{
		private var thicknessRatio:Number;
		private var thicknessSpeed:Number;
		
		private var lastRenderRadius:Number;
		private var lastThickness:Number;
		private var shape:Shape;
		private var imagesArray:Vector.<Image>;
		private var indeces:Vector.<int>;
		private var currentIndex:int;
		
		public var radius:Number;
		
		public function MainOrbitEntity() 
		{
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			shape = new Shape();
			
			thicknessRatio = 0;
			thicknessSpeed = 0.3;
			
			imagesArray = new Vector.<Image>();
			indeces = new Vector.<int>();
			currentIndex = 0;
			for (var i:int = Global.MIN_RADIUS; i < Global.MAX_RADIUS; i+= GraphicsLoader.OrbitStep) 
			{
				imagesArray.push(new Image(GraphicsLoader.GetGraphics("mainorbit" + i.toString())));
				imagesArray[imagesArray.length - 1].alignPivot();
				imagesArray[imagesArray.length - 1].alpha = 0;
				indeces.push(i);
			}
			imagesArray[currentIndex].alpha = 1;
			
			radius = 0;
			lastRenderRadius = -1;
			lastThickness = -1;
			
			layer = LayerConstant.MAIN_ORBIT_LAYER;
		}
		
		override public function Added():void 
		{
			super.Added();
			
			for (var i:int = 0; i < imagesArray.length; i++) 
			{
				addChild(imagesArray[i]);
			}
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			for (var i:int = 0; i < imagesArray.length; i++) 
			{
				removeChild(imagesArray[i]);
			}
		}
		
		public function Destroy():void
		{
			thicknessSpeed = -Math.abs(thicknessSpeed);
		}
		
		override public function Update():void 
		{
			super.Update();
			
			thicknessRatio += thicknessSpeed;
			if (thicknessRatio > 1)
			{
				thicknessRatio = 1;
			}
			
			if (thicknessRatio <= 0 && thicknessSpeed < 0)
			{
				Engine.currentWorld.RemoveEntity(this);
			}
		}
		
		public function Render():void 
		{
			if (lastRenderRadius != radius || lastThickness != thicknessRatio)
			{
				if (currentIndex + 1 < indeces.length)
				{
					if (radius >= indeces[currentIndex + 1])
					{
						imagesArray[currentIndex].alpha = 0;
						currentIndex += 1;
						imagesArray[currentIndex].alpha = 1;
					}
				}
				
				if (radius < indeces[currentIndex])
				{
					imagesArray[currentIndex].alpha = 0;
					currentIndex -= 1;
					if (currentIndex < 0)
					{
						currentIndex = 0;
					}
					imagesArray[currentIndex].alpha = 1;
				}
				
				imagesArray[currentIndex].scaleX = radius / indeces[currentIndex];
				imagesArray[currentIndex].scaleY = imagesArray[currentIndex].scaleX;
			}
			
			lastRenderRadius = radius;
			lastThickness = thicknessRatio;
		}
	}

}