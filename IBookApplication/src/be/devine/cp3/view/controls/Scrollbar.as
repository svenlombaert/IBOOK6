package be.devine.cp3.view.controls {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.style.Style;

import flash.events.Event;
import flash.geom.Point;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;


public class Scrollbar extends Sprite{

    private var track:Quad;
    private var thumb:Quad;
    private var _thumbPosition:Number;
    private var _draggedObject:DisplayObject;

    private var trackWidth:int;
    private var trackHeight:int;
    private var thumbWidth:int;
    private var appModel:AppModel;


    public function Scrollbar(w:int,  h:int, tw:int) {
        appModel = AppModel.getInstance();
        trackHeight = h;
        trackWidth = w;
        thumbWidth = tw;
        track = new Quad(trackWidth, trackHeight,Style.TRACKCOLOR);
        thumb = new Quad(thumbWidth, trackHeight,Style.THUMBCOLOR);
        appModel.addEventListener(AppModel.THUMBSCROLLBARPOSITION_CHANGED, thumbPostionChanged);
        thumb.x = appModel.thumbScrollbarPosition * (track.width - thumb.width);
        thumb.addEventListener(TouchEvent.TOUCH, touchHandler);

        addChild(track);
        addChild(thumb);
    }

    private function touchHandler(event:TouchEvent):void {
        var touchObject:DisplayObject = event.currentTarget as DisplayObject;
        var touch:Touch = event.getTouch(touchObject);
        var resultPoint:Point = new Point();

        if(touch != null){
            switch(touch.phase){
                case TouchPhase.BEGAN:
                        trace('began');
                        _draggedObject = event.currentTarget as DisplayObject;
                    break;
                case TouchPhase.MOVED:
                        trace('moved');
                        if(_draggedObject != null){
                            var localPos:Point = globalToLocal(new Point(touch.globalX, touch.globalY), resultPoint);
                            _draggedObject.x = localPos.x;
                            if(_draggedObject.x >= track.width - thumb.width){
                                _draggedObject.x = track.width - thumb.width;
                            }else if(_draggedObject.x <= 0){
                                _draggedObject.x = 0;
                            }
                            appModel.thumbScrollbarPosition = thumb.x / (track.width - thumb.width);
                        }
                    break;
                case TouchPhase.ENDED:
                        _draggedObject = null;
                    break;
            }
        }
    }

    private function thumbPostionChanged(event:flash.events.Event):void {
        thumb.x = appModel.thumbScrollbarPosition * (track.width - thumb.width);
    }
}
}
