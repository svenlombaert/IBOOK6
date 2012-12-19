/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 10/12/12
 * Time: 10:53
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.viewmodes {
import be.devine.cp3.config.Config;
import be.devine.cp3.model.AppModel;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.display.Loader;
import flash.events.Event;
import flash.geom.Point;
import flash.net.URLRequest;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;

//TODO: inladen vanuit map.
public class Thumbnail extends Sprite {
    public static const MAXWIDTH:uint = 220;
    public static const MAXHEIGHT:uint = 140;

    private var pageNumber:int;
    private var hoverOverlay:Sprite;
    private var thumb:Image;
    private var loader:Loader;
    private var _active:Boolean = false;

    public static const THUMBNAIL_CLICKED:String = "thumbnailClicked";

    //TODO: hover met paginanummer
    public function Thumbnail(url:String, pageNumber:int) {
        trace('maak thumb');
        this.pageNumber = pageNumber+1;
        trace(url);
        //flatten page
        loader = new Loader();
        loader.load(new URLRequest(url));
        loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoadedHandler);

        thumb = Image.fromBitmap(new Bitmap(new BitmapData(MAXWIDTH, MAXHEIGHT)));
        hoverOverlay = new Sprite();

        this.useHandCursor = true;
        this.addEventListener(TouchEvent.TOUCH, touchHandler);
    }

    private function touchHandler(event:TouchEvent):void {
        var touchObject:DisplayObject = event.currentTarget as DisplayObject;

        if (event.getTouch(touchObject, TouchPhase.BEGAN)) {
            dispatchEvent(new starling.events.Event(THUMBNAIL_CLICKED));
        }

        if (event.getTouch(touchObject, TouchPhase.HOVER)) {
            hoverOverlay.visible = true;
        } else {
            var touch:Touch = event.getTouch(touchObject);
            var location:Point = new Point();
            if (touch != null) {
                location = touch.getLocation(touchObject);
            } else {
                var globalPoint:Point = new Point(Starling.current.nativeStage.mouseX, Starling.current.nativeStage.mouseY);
                globalToLocal(globalPoint, location);
            }

            if (this.hitTest(location) == null) {
                hoverOverlay.visible = false;
            }
        }
    }

    private function createHoverOverlay():void {
        var text:TextField = new TextField(MAXWIDTH, MAXHEIGHT, "p" + this.pageNumber, Config.FONTBOLD, 42, Config.HOVERTHUMBNAILCOLOR);
        hoverOverlay.addChild(text);
        hoverOverlay.visible = false;
        addChild(hoverOverlay);
        display();
    }

    private function display():void {
        if (active) {
            thumb.alpha = 1;
            hoverOverlay.visible = true;
            this.removeEventListener(TouchEvent.TOUCH, touchHandler);
        } else {
            thumb.alpha = 0.3;
            hoverOverlay.visible = false;
            this.addEventListener(TouchEvent.TOUCH, touchHandler);
        }
    }

    private function imageLoadedHandler(event:flash.events.Event):void {
        var texture:Texture = Texture.fromBitmap(loader.content as Bitmap);
        thumb = new Image(texture);
        thumb.alpha = 0.3;
        addChild(thumb);
        createHoverOverlay();
    }

    public function get active():Boolean {
        return _active;
    }

    public function set active(value:Boolean):void {
        _active = value;
        display();
    }
}
}
