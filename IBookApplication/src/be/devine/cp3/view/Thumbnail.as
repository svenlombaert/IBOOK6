/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 10/12/12
 * Time: 10:53
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.view.*;

import be.devine.cp3.style.Style;

import flash.events.Event;
import flash.filters.DisplacementMapFilter;
import flash.geom.Point;
import flash.text.TextDisplayMode;

import starling.core.Starling;

import starling.display.DisplayObject;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.RenderTexture;

public class Thumbnail extends Sprite{
    public static const MAXWIDTH:uint = 220;
    public static const MAXHEIGHT:uint = 140;

    private var pageNumber:int;
    private var appModel:AppModel;
    private var hoverOverlay:Sprite;
    private var thumb:Image;

    //TODO: hover met paginanummer
    public function Thumbnail(page:Page) {
        this.pageNumber = page.pagenumber;
        this.appModel = AppModel.getInstance();
        this.appModel.addEventListener(AppModel.SELECTEDPAGEINDEX_CHANGED, pageIndexChangedHandler);
        //resize page
        page.width = MAXWIDTH;
        page.scaleY = page.scaleX;

        if(page.height > MAXHEIGHT){
           page.height = MAXHEIGHT;
           page.scaleX = page.scaleY;
        }

        //flatten page
        var q:Quad = new Quad(220, 140, Style.THUMBNAILBACKGROUNDCOLOR);
        var texture:RenderTexture = new RenderTexture(q.width, q.height);
        texture.draw(q);
        texture.draw(page);

        thumb= new Image(texture);
        thumb.alpha = 0.3;
        addChild(thumb);
        createHoverOverlay();

        this.useHandCursor = true;
        this.addEventListener(TouchEvent.TOUCH, touchHandler);
    }

    private function touchHandler(event:TouchEvent):void {
        var touchObject:DisplayObject = event.currentTarget as DisplayObject;

        var touch:Touch = event.getTouch(touchObject);

        if (event.getTouch(touchObject, TouchPhase.BEGAN)) {
            appModel.selectedPageIndex = this.pageNumber - 1;
            hoverOverlay.visible = true;
            this.removeEventListener(TouchEvent.TOUCH, touchHandler);
        }

        if (event.getTouch(touchObject, TouchPhase.HOVER)){
                hoverOverlay.visible = true;
        }else{
            var touch:Touch = event.getTouch(touchObject);
            var location:Point = new Point();
            if(touch != null){
                location  = touch.getLocation(touchObject);
            } else {
                var globalPoint:Point = new Point(Starling.current.nativeStage.mouseX, Starling.current.nativeStage.mouseY);
                globalToLocal(globalPoint, location);
            }

            if(this.hitTest(location) == null) {
                hoverOverlay.visible = false;
            }

        }


    }

    private function createHoverOverlay():void{
        hoverOverlay = new Sprite();
        var text:TextField = new TextField(MAXWIDTH, MAXHEIGHT, "p" + this.pageNumber, Style.FONTBOLD, 42, Style.HOVERTHUMBNAILCOLOR);
        hoverOverlay.addChild(text);
        hoverOverlay.visible = false;
        addChild(hoverOverlay);
        display();
    }

    private function pageIndexChangedHandler(event:Event):void {
        display();
    }

    private function display():void{
        if((this.pageNumber-1) == appModel.selectedPageIndex){
            thumb.alpha = 1;
            hoverOverlay.visible = true;
            this.removeEventListener(TouchEvent.TOUCH, touchHandler);
        }else{
            thumb.alpha = 0.3;
            hoverOverlay.visible = false;
            this.addEventListener(TouchEvent.TOUCH, touchHandler);
        }
    }
}
}
