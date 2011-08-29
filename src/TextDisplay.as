package  
{
	import com.bit101.components.VScrollBar;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class TextDisplay extends Sprite
	{
		public var scrollbar:VScrollBar;
		private var _viewHeight:Number;
		private var _viewWidth:Number;
		
		public function TextDisplay(w:Number, h:Number) {
			this._height = this._viewHeight = h;
			this._width = this._viewWidth = w;
			
			this.redrawBorder();
		}
		
		private var _width:Number;
		override public function get width():Number {
			return this._width;
		}
		
		override public function set width(value:Number):void {
			_width = value;
			super.width = _width;
		}
		
		private var _height:Number;
		override public function get height():Number {
			return _height;
		}
		
		override public function set height(value:Number):void {
			_height = value;
			redrawBorder();
			
			var max:Number = this.height - _viewHeight;
			if (max < 0) max = 0;
			scrollbar.maximum = max;
			scrollbar.setThumbPercent(_viewHeight / this.height);
			scrollbar.value = scrollbar.maximum;
			setScrollRectByBar(null);
		}
		
		private function redrawBorder():void {
			var g:Graphics = this.graphics;
			g.clear();
			
			g.lineStyle(1);
			
			var _h:Number = (this.height > this._viewHeight)? this.height:_viewHeight;
			g.drawRect(0, 0, this.width-1, _h-1);
			//g.endFill();
		}
		
		public function setScrollRectByBar(event:Event):void {
			//trace("scrollbar.value=" + scrollbar.value);
			this.scrollRect = new Rectangle(0, scrollbar.value, _viewWidth, _viewHeight);
		}
	}

}