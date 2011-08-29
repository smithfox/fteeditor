package  
{
	import com.bit101.components.PushButton;
	import com.bit101.components.VScrollBar;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextLineCreationResult;
	import flash.text.engine.TextLineValidity;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author smithfox
	 */
	public class TextGroup 
	{
		private var display:TextDisplay;
		private var block:TextBlock = null;
		private var group:GroupElement;
		
		private var _format:ElementFormat = new ElementFormat();
		
		public function TextGroup($display:TextDisplay) 
		{
			//var s:VScrollBar
			this.display = $display;
		}
		
		protected var _listeningEnterFrame:Boolean = false;
		
		private var _blockInited:Boolean = false;
		public function initBlock():void {
			if ( ! block )  block = new TextBlock();
			if (! _blockInited ){
				var textElement:TextElement = new TextElement("", _format);

				var contentElements:Vector.<ContentElement> = new Vector.<ContentElement>();
				contentElements.push(textElement);
				var groupElement:GroupElement = new GroupElement(contentElements);
				block.content = groupElement;
				_blockInited = true;
			}
		}
		
		protected function invalidateProperties():void {
			var needRerender:Boolean = false;
			
			if ( this._formatChanged ) {
				_formatChanged = false;
				
				_format = new ElementFormat(new FontDescription(fontName,fontWeight));
				_format.fontSize = fontSize;
				_format.color = color;
				
				needRerender = true;
			}
            
			if ( this._contentChanged ) {
				_contentChanged = false;
				initBlock();
				needRerender = true;
			}

			if (needRerender && !_listeningEnterFrame ) {
				this.display.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 1.0, true);
				//this.display.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				_listeningEnterFrame = true;
			}
			
		}

		protected function enterFrameHandler(event:Event):void {
trace("enterFrameHandler");	
			this.display.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_listeningEnterFrame = false;
			render();
			//_render();
		}
		
		private var _lines:Dictionary = new Dictionary();
		
		private function render():void 
        {
			//remove all textlines
			while(display.numChildren)
				display.removeChildAt(0);
			
            var _y:int = _format.fontSize;
            var _w:Number = display.width;
            var _previousLine:TextLine = null;
			var _line:TextLine = block.firstInvalidLine;
			
			do {
				if (_line && (_line !== _previousLine) && (_lines[_line] == true) && (_line.validity != TextLineValidity.VALID) ) {
trace("recreateTextLine, _line.validaty="+_line.validity);
					_line = block.recreateTextLine(_line, _previousLine, _w);
				} else {
//trace("createTextLine");
					_line = block.createTextLine (_previousLine, _w);
					if(_line){
						_lines[_line] = true;
						
					}
				}
				
				if( _line ) {
					_line.y = _y;
					_y += _line.height;
					display.addChild(_line);
					_previousLine = _line;
				}
			} while (_line);
			
			display.height = _y;
        }
		
		//============= font properties ==========
		private var _formatChanged:Boolean = true;
		private var _fontSize:int = 12;
		public function set fontSize(v:int):void {
			if (_fontSize == v) return;
			else {
				_fontSize = v;
				_formatChanged = true;
				invalidateProperties();
			}
		}
		
		public function get fontSize():int {
			return this._fontSize;
		}
		
		private var _color:uint = 0x000000;
		public function set color(v:uint):void {
			if (_color == v) return;
			else {
				_color = v;
				_formatChanged = true;
				invalidateProperties();
			}
		}
		
		public function get color():uint {
			return this._color;
		}
		
		private var _fontName:String = "Arial";
		public function set fontName(v:String):void {
			if (_fontName == v) return;
			else {
				_fontName = v;
				_formatChanged = true;
				invalidateProperties();
			}
		}
		
		public function get fontName():String {
			return this._fontName;
		}
		
		private var _fontWeight:String="normal";
		public function set fontWeight(v:String):void {
			if (_fontWeight == v) return;
			else {
				_fontWeight = v;
				_formatChanged = true;
				invalidateProperties();
			}
		}
		
		public function get fontWeight():String {
			return this._fontWeight;
		}
		
		//================ appendText and appendGraphic ========
		private var _contentChanged:Boolean = true;
		public function appendText(text:String):void {
			initBlock();
			var textElement:TextElement = (block.content as GroupElement).getElementAt(0) as TextElement;
			textElement.replaceText(textElement.rawText.length, textElement.rawText.length, text);
			
			_contentChanged = true;
			invalidateProperties();
		}

		public function insertText(text:String):void {
			initBlock();
			var textElement:TextElement = (block.content as GroupElement).getElementAt(0) as TextElement;
			textElement.replaceText(0, 0, text);
			
			_contentChanged = true;
			invalidateProperties();
		}
		
		//public function appendGraphic(graphic:Sprite):void {
		//	
		//}
		
		
		//===========static function=============================
/*		
		private function _render():void {
			//var lines:Array = getValidLines(block);
			var line:TextLine;

			if(isInvalidBlock(block))
			{
				if(block.firstInvalidLine)
					line = block.firstInvalidLine.previousLine;
				else if(block.textLineCreationResult != TextLineCreationResult.COMPLETE)
					line = block.lastLine;

				createLines(display,block, line, display.width);
				//lines = lines.concat(createLines(block, line, display.width));
			}

			//return lines.concat();
		}
		

		private static const glines:Dictionary = new Dictionary();

		private static function checkIn(line:TextLine):void
		{
			line.userData = null;
			glines[line] = true;
		}

		private static function checkOut():TextLine
		{
			for(var line:* in glines)
			{
				delete glines[line];
				return line;
			}

			return null;
		}
		
		private static function getValidLines($block:TextBlock):Array
		{
			const lines:Array = [];
			var line:TextLine = $block.firstLine;
			var valid:Boolean = true;

			while(line)
			{
				if(line.validity != TextLineValidity.VALID)
					valid = false;

				if(valid)
					lines.push(line);
				else
					checkIn(line);

				line = line.nextLine;
			}

			return lines;
		}
		
		public static function isInvalidBlock($block:TextBlock):Boolean {
			return $block.firstLine == null ||
				$block.firstInvalidLine ||
				$block.textLineCreationResult != TextLineCreationResult.COMPLETE;
		}
		
		private static function createLines($display:Sprite, $block:TextBlock, $line:TextLine, $width:int):void
		{
			//const lines:Array = [];

			var line:TextLine = $line;
			var _y:int = 0;
			while(true)
			{
				//line = createTextLine($block, line, $width);
				var orphan:TextLine = checkOut();
				if(orphan){
					line = $block.recreateTextLine(orphan, line, $width, 0.0, true);
				} else {
					line = $block.createTextLine(line, $width, 0.0, true);
					if( line ){
						$display.addChild(line);
					}
				}

				if(line == null) {
					break;
				}
				else {
					line.y = _y;
					_y += line.height;
				}
				//lines.push(line);
			}

			//return lines;
		}
*/
	}

}