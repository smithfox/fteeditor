package  
{
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.bit101.components.VScrollBar;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	public class Main extends Sprite
	{
		//The container of all text
        private var display:TextDisplay;
		private var textGroup:TextGroup;
		
		public function Main() {
			super();
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var _w:int = 500;
			var _h:int = 200;
			
			display = new TextDisplay(500, 200);
			
			display.y = 25;
			
			display.scrollRect = new Rectangle(0, 0, _w, _h);
			addChild(display);
			
			var scrollbar:VScrollBar = new VScrollBar(this, _w + 1, 25, display.setScrollRectByBar);

trace("display.height=" + display.height);
			scrollbar.height = _h;
			scrollbar.minimum = 0;
			scrollbar.pageSize = _h;
			scrollbar.lineSize = 10;
			
			display.scrollbar = scrollbar;
			
			initMenus();
			
			textGroup = new TextGroup(display);
			textGroup.fontSize = 18;
			//textGroup.appendText("<Hello>");
			
		}
		
		private function initMenus():void {
			var _x:int = 0;
			var _y:int = 0;
			var _h:int = 20;
			
			var textInput:TextField = new TextField();
			textInput.x = _x;
			textInput.y = _y;
			textInput.height = _h;
			textInput.selectable = true;
			textInput.border = true;
			textInput.type = TextFieldType.INPUT;
			textInput.width = 200;
			_x += 210;
			this.addChild(textInput);
			
			var insertTextButton:PushButton = new PushButton(this, _x, _y, "insert", 
				function (event:Event):void {
					textGroup.insertText(textInput.text);
				}
			);
			
			insertTextButton.height = _h;
			insertTextButton.width = 50;
			_x += 60;

			var appenTextButton:PushButton = new PushButton(this, _x, _y, "append", 
				function (event:Event):void {
					textGroup.appendText(textInput.text);
trace("this.display.height=" + display.height);
				}
			);
			appenTextButton.height = _h;
			appenTextButton.width = 50;
			_x += 60;
			
			
			var button2:PushButton = new PushButton(this, _x, _y, "\\n", function (event:Event):void {
				textGroup.appendText("\n");
			});
			button2.height = _h;
			button2.width = 25;
			_x += 35;
			
			
			var button3:PushButton = new PushButton(this, _x, _y, "\\r", function (event:Event):void {
				textGroup.appendText("\r");
			});
			button3.height = _h;
			button3.width = 25;
			_x += 35;
			
			
			var button4:PushButton = new PushButton(this, _x, _y, "tab", function (event:Event):void {
				textGroup.appendText("\t");
			});
			button4.height = _h;
			button4.width = 25;
			_x += 35;
			
		}
	}

}