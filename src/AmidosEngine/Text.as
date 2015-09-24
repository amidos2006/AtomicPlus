package AmidosEngine 
{
	import flash.text.AntiAliasType;
	import starling.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Text extends BaseEntity
	{
		public static const X_LARGE_FONT:int = 90;
		public static const LARGE_FONT:int = 70;
		public static const MEDIUM_FONT:int = 50;
		public static const SMALL_FONT:int = 30;
		
		private var textField:TextField;
		private var textFormat:TextFormat;
		
		public function set text(string:String):void
		{
			textField.text = string;
		}
		
		public function get text():String
		{
			return textField.text;
		}
		
		public function set color(newColor:uint):void
		{
			textField.color = newColor;
		}
		
		public function get color():uint
		{
			return uint(textFormat.color);
		}
		
		public function get TextHeight():Number
		{
			return textField.height;
		}
		
		public function get TextWidth():Number
		{
			return textField.width;
		}
		
		public function Text(inputText:String, color:uint, fontSize:int = MEDIUM_FONT, align:String = "center") 
		{
			var lines:Array = inputText.split('\n');
			var characters:int = 0;
			for (var i:int = 0; i < lines.length; i++) 
			{
				if (characters < lines[i].length)
				{
					characters = lines[i].length;
				}
			}
			
			textField = new TextField(Math.max(characters * fontSize, 200 * GraphicsLoader.ConversionRatio), 1.1 * (lines.length) * fontSize, 
				inputText, Engine.font.fontName, fontSize, color);
			textField.hAlign = align;
		}
		
		override public function Added():void 
		{
			super.Added();
			
			addChild(textField);
		}
		
		override public function Removed():void 
		{
			super.Removed();
			
			removeChild(textField);
		}
		
		override public function CenterOO():void 
		{
			textField.x = -textField.width / 2;
			textField.y = -textField.height / 2;
		}
	}

}