package be.devine.cp3.view.controls {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.style.Style;
import be.devine.cp3.utils.mask.PixelMaskDisplayObject;

import flash.display.BitmapData;

import flash.display.Shape;

import flash.events.Event;
import flash.geom.Point;

import starling.animation.Transitions;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;


public class Scrollbar extends Sprite{

    private var track:Quad;
    private var thumb:Quad;
    private var _draggedObject:DisplayObject;

    private var trackWidth:int;
    private var trackHeight:int;
    private var thumbWidth:int;
    private var appModel:AppModel;
    private var startDragLocation:Point;

    private var maskedThumb:PixelMaskDisplayObject;
    private var maskedTrack:PixelMaskDisplayObject;


    public function Scrollbar(w:int,  h:int, tw:int) {
        appModel = AppModel.getInstance();
        trackHeight = h;
        trackWidth = w;
        thumbWidth = tw;
        startDragLocation = new Point();
        this.appModel.addEventListener(AppModel.SELECTEDPAGEINDEX_CHANGED, selectedPageIndexChangedHandler);

        track = new Quad(trackWidth, trackHeight,Style.TRACKCOLOR);
        thumb = new Quad(thumbWidth, trackHeight,Style.THUMBCOLOR);

        maskedTrack = new PixelMaskDisplayObject();
        maskedTrack.addChild(track);
        maskedTrack.mask = drawRoundedMask(trackWidth, trackHeight, trackHeight);

        maskedThumb = new PixelMaskDisplayObject();
        maskedThumb.addChild(thumb);
        maskedThumb.mask = drawRoundedMask(thumbWidth, trackHeight, trackHeight);

        appModel.addEventListener(AppModel.THUMBSCROLLBARPOSITION_CHANGED, thumbPostionChanged);
        maskedThumb.x = appModel.thumbScrollbarPosition * (track.width - thumb.width);
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
                        trace('began');
                        _draggedObject = event.currentTarget as DisplayObject;
                        touch.getLocation(touchObject, startDragLocation);
                    break;
                case TouchPhase.MOVED:
                        trace('moved');
                        if(_draggedObject != null){
                            var localPos:Point = globalToLocal(new Point(touch.globalX, touch.globalY), resultPoint);
                            _draggedObject.x = localPos.x - startDragLocation.x;
                            if(_draggedObject.x >= maskedTrack.width - maskedThumb.width){
                                _draggedObject.x = maskedTrack.width - maskedThumb.width;
                            }else if(_draggedObject.x <= 0){
                                _draggedObject.x = 0;
                            }
                            appModel.thumbScrollbarPosition = maskedThumb.x / (maskedTrack.width - maskedThumb.width);
                        }
                    break;
                case TouchPhase.ENDED:
                        _draggedObject = null;
                    break;
            }
        }
    }

    private function thumbPostionChanged(event:Event):void {
        var tween:Tween = new Tween(maskedThumb, 0.3, Transitions.EASE_OUT);
        tween.animate("x", appModel.thumbScrollbarPosition * (maskedTrack.width - maskedThumb.width));
        Starling.juggler.add(tween);
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

    private function selectedPageIndexChangedHandler(event:Event):void {
        //TODO: vragen aan wouter om geselecteerd item in het midden te krijgen
        appModel.thumbScrollbarPosition = appModel.selectedPageIndex/(appModel.pages.length-1);
    }
}
}
