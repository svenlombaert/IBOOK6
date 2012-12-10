package be.devine.cp3.view.controls {
import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;


public class Scrollbar extends Sprite{

    private var track:Quad;
    private var thumb:Quad;
    private var _thumbPosition:Number;

    private var trackWidth:int;
    private var trackHeight:int;
    private var thumbHeight:int;
    private var trackColor:int;
    private var thumbColor:int;

    public function ScrollBar(w:int,  h:int, th:int, scrollColor:int, thumbColor:int) {
        trackHeight = h;
        trackWidth = w;
        thumbHeight = th;
        this.trackColor = scrollColor;
        this.thumbColor = thumbColor;

        thumbPosition = 0;

        track = new Quad(trackWidth, trackHeight,trackColor);

        thumb = new Quad(trackWidth, thumbHeight,thumbColor);

        //TODO touch event van maken.
        thumb.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        track.addEventListener(MouseEvent.CLICK, trackClickHandler);

        addChild(track);
        addChild(thumb);
    }

    private function mouseDownHandler(event:MouseEvent):void {
        thumb.startDrag(false, new Rectangle(0,0,0,track.height - thumb.height));
        stage.addEventListener(MouseEvent.MOUSE_UP,  mouseUpHandler);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        thumb.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
    }

    private function mouseMoveHandler(event:MouseEvent):void {
        onDrag();
    }

    private function mouseUpHandler(event:MouseEvent):void {
        thumb.stopDrag();
        thumb.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        onDrag();
    }

    private function trackClickHandler(event:MouseEvent):void {
        trace('klikje');
        thumb.y = mouseY - thumb.height;
        onDrag();
    }

    private function onDrag():void{
        thumbPosition = thumb.y/(track.height - thumb.height);
    }

    public function get thumbPosition():Number {
        return _thumbPosition;
    }

    public function set thumbPosition(value:Number):void {
        if(value != _thumbPosition){
            _thumbPosition = value;
            thumb.y = _thumbPosition * (track.height - thumb.height);
            dispatchEvent(new Event(Event.CHANGE));
        }
    }


}
}
