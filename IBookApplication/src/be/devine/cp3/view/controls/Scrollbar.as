package be.devine.cp3.view.controls {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.config.Config;
import be.devine.cp3.utils.mask.PixelMaskDisplayObject;
import be.devine.cp3.view.ViewModeController;

import flash.display.BitmapData;

import flash.display.Shape;

import flash.geom.Point;

import starling.animation.Transitions;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;


public class Scrollbar extends Sprite{

    private var track:Quad;
    private var thumb:Quad;

    private var trackWidth:int;
    private var trackHeight:int;
    private var thumbWidth:int;
    private var _thumbPosition:Number;

    private var startDragLocation:Point;
    private var _draggedObject:DisplayObject;

    private var maskedThumb:PixelMaskDisplayObject;
    private var maskedTrack:PixelMaskDisplayObject;

    public static const THUMBPOSITION_CHANGED:String = "thumbPositionChanged";


    public function Scrollbar(w:int,  h:int, tw:int) {
        trackHeight = h;
        trackWidth = w;
        thumbWidth = tw;
        startDragLocation = new Point();

        track = new Quad(trackWidth, trackHeight,Config.TRACKCOLOR);
        thumb = new Quad(thumbWidth, trackHeight,Config.THUMBCOLOR);

        maskedTrack = new PixelMaskDisplayObject();
        maskedTrack.addChild(track);
        maskedTrack.mask = drawRoundedMask(trackWidth, trackHeight, trackHeight);

        maskedThumb = new PixelMaskDisplayObject();
        maskedThumb.addChild(thumb);
        maskedThumb.mask = drawRoundedMask(thumbWidth, trackHeight, trackHeight);

        maskedThumb.addEventListener(TouchEvent.TOUCH, touchHandler);

        addChild(maskedTrack);
        addChild(maskedThumb);
    }

    private function touchHandler(event:TouchEvent):void {
        var touchObject:DisplayObject = event.currentTarget as DisplayObject;
        var touch:Touch = event.getTouch(touchObject);
        var resultPoint:Point = new Point();

        if(touch != null){
            switch(touch.phase){
                case TouchPhase.BEGAN:
                        _draggedObject = event.currentTarget as DisplayObject;
                        touch.getLocation(touchObject, startDragLocation);
                    break;
                case TouchPhase.MOVED:
                        if(_draggedObject != null){
                            var localPos:Point = globalToLocal(new Point(touch.globalX, touch.globalY), resultPoint);
                            _draggedObject.x = localPos.x - startDragLocation.x;
                            if(_draggedObject.x >= maskedTrack.width - maskedThumb.width){
                                _draggedObject.x = maskedTrack.width - maskedThumb.width;
                            }else if(_draggedObject.x <= 0){
                                _draggedObject.x = 0;
                            }
                            thumbPosition = maskedThumb.x / (maskedTrack.width - maskedThumb.width);
                        }
                    break;
                case TouchPhase.ENDED:
                        _draggedObject = null;
                    break;
            }
        }
    }

    private function drawRoundedMask(width:int,  height:int,  radius:int): Image{
        var maskShape:Shape = new Shape();
        maskShape.graphics.beginFill(0x000000);
        maskShape.graphics.drawRoundRect(0, 0, width, height, radius, radius);
        maskShape.graphics.endFill();

        var bmp:BitmapData = new BitmapData(maskShape.width, maskShape.height, true, 0x000000);
        bmp.draw(maskShape);

        return new Image(Texture.fromBitmapData(bmp));
    }

    public function get thumbPosition():Number {
        return _thumbPosition;
    }

    public function set thumbPosition(value:Number):void {
        trace('[scrollbar] thumbpos changed', value);
        if(_thumbPosition != value){
            trace('dispatch event');
            _thumbPosition = value;
            maskedThumb.x = _thumbPosition * (maskedTrack.width - maskedThumb.width);
            dispatchEvent(new Event(THUMBPOSITION_CHANGED));
        }
    }
}
}
