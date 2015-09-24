package AtomicPlus.GameEntity 
{
	import AmidosEngine.BaseEntity;
	import AmidosEngine.GraphicsLoader;
	import AmidosEngine.Text;
	import AtomicPlus.Global;
	import AtomicPlus.LayerConstant;
	import flash.display.Bitmap;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HUDEntity extends BaseEntity
	{
		private var backgroundEntity:BackgroundEntity;
		
		private var scoreText:Text;
		private var scoreValueText:Text;
		private var damageText:Text;
		private var barFillBitmap:Image;
		private var barOutlineBitmap:Image;
		
		public function HUDEntity(background:BackgroundEntity) 
		{
			x = GraphicsLoader.Width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			y = GraphicsLoader.Height / 2 + Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio;
			
			backgroundEntity = background;
			
			scoreText = new Text("score", backgroundEntity.GetCurrentBackColor(), Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			scoreText.CenterOO();
			
			scoreValueText = new Text(Global.score.toString(), backgroundEntity.GetCurrentBackColor(), 
										Text.X_LARGE_FONT * GraphicsLoader.ConversionRatio);
			scoreValueText.CenterOO();
			
			scoreValueText.x = (4) * GraphicsLoader.ConversionRatio;
			scoreValueText.y = (15) * GraphicsLoader.ConversionRatio;
			scoreText.y = scoreValueText.y - (Text.X_LARGE_FONT) * GraphicsLoader.ConversionRatio / 2;
			
			barOutlineBitmap = new Image(GraphicsLoader.GetGraphics("damagebaroutline"));
			barOutlineBitmap.x = -barOutlineBitmap.width / 2 + Global.CENTER_SHIFT_X * GraphicsLoader.ConversionRatio;
			barOutlineBitmap.y = GraphicsLoader.Height / 2  - Global.CENTER_SHIFT_Y * GraphicsLoader.ConversionRatio - barOutlineBitmap.height - 10 * GraphicsLoader.ConversionRatio;
			
			barFillBitmap = new Image(GraphicsLoader.GetGraphics("damagebar"));
			barFillBitmap.x = barOutlineBitmap.x + 20 * GraphicsLoader.ConversionRatio;
			barFillBitmap.y = barOutlineBitmap.y + Global.STROKE_THICKNESS * GraphicsLoader.ConversionRatio;
			barFillBitmap.scaleX = 0;
			
			damageText = new Text("damage", 0xFFFFFF, Text.SMALL_FONT * GraphicsLoader.ConversionRatio);
			damageText.CenterOO();
			damageText.y = barOutlineBitmap.y - 10 * GraphicsLoader.ConversionRatio;
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function Added():void 
		{
			super.Added();
			
			addChild(scoreText);
			scoreText.Added();
			
			addChild(scoreValueText);
			scoreValueText.Added();
			
			addChild(barFillBitmap);
			addChild(barOutlineBitmap);
			
			addChild(damageText);
			damageText.Added();
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			removeChild(scoreText);
			scoreText.Removed();
			
			removeChild(scoreValueText);
			scoreValueText.Removed();
			
			removeChild(barFillBitmap);
			removeChild(barOutlineBitmap);
			
			removeChild(damageText);
			damageText.Removed();
		}
		
		override public function Update():void 
		{
			super.Update();
			
			scoreText.color = backgroundEntity.GetCurrentBackColor();
			
			scoreValueText.text = Global.score.toString();
			scoreValueText.color = backgroundEntity.GetCurrentBackColor();
			
			if (Global.playerEntity != null)
			{
				barFillBitmap.scaleX = Global.playerEntity.damage / Global.playerEntity.maxDamage;
			}
			else
			{
				barFillBitmap.scaleX = 1;
			}
			barFillBitmap.x = -barFillBitmap.width / 2;
		}
		
		override public function RenderMissingFrame():void 
		{
			super.RenderMissingFrame();
			
			scoreText.color = backgroundEntity.GetCurrentBackColor();
			scoreValueText.color = backgroundEntity.GetCurrentBackColor();
		}
	}

}