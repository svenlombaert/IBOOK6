/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 11/12/12
 * Time: 12:35
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.viewmodes {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.utils.mask.PixelMaskDisplayObject;

import flash.events.Event;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;

public class TimelineThumbnails extends Sprite{
    private var appModel:AppModel;
    private var arrThumbnails:Vector.<Thumbnail> = new Vector.<Thumbnail>();
    private var thumbnailsHolder:Sprite;
    private var maskedThumbnails:PixelMaskDisplayObject;
    private var maskObject:Quad;

    //TODO: gridview met scrollbars.

    public function TimelineThumbnails(arrThumbnails: Vector.<Thumbnail>) {
        this.arrThumbnails = arrThumbnails;
        appModel = AppModel.getInstance();
        this.appModel.addEventListener(AppModel.PAGES_CHANGED, pagesChangedHandler);
        this.appModel.addEventListener(AppModel.THUMBSCROLLBARPOSITION_CHANGED, scrollHandler);
        this.appModel.addEventListener(AppModel.APPSIZE_CHANGED, resizeHandler);
        this.appModel.addEventListener(AppModel.SELECTEDPAGEINDEX_CHANGED, pageIndexChangedHandler);
        initalizeThumbnails();
        scrollHandler(null);
    }

    private function initalizeThumbnails():void {
        thumbnailsHolder = new Sprite();
        var xPos:uint = 0;

        for(var i:int = 0; i<arrThumbnails.length; i++){
            arrThumbnails[i].x = xPos;
            arrThumbnails[i].y = 0;
            arrThumbnails[i].addEventListener(Thumbnail.THUMBNAIL_CLICKED, thumbnailClickedHandler);
            thumbnailsHolder.addChild(arrThumbnails[i]);
            xPos += Thumbnail.MAXWIDTH + 25;
            trace(arrThumbnails[i].y);
        }

        maskObject = new Quad(appModel.appwidth-60, 258, 0x000000);

        maskedThumbnails= new PixelMaskDisplayObject();
        maskedThumbnails.addChild(thumbnailsHolder);

        maskedThumbnails.mask = maskObject;
        addChild(maskedThumbnails);
        display(appModel.selectedPageIndex);
    }

    private function pagesChangedHandler(event:flash.events.Event):void {
        initalizeThumbnails();
    }

    private function scrollHandler(event:flash.events.Event):void {
        //resetPositions();
            if(thumbnailsHolder != null){
                var tween:Tween = new Tween(thumbnailsHolder, 0.3, Transitions.EASE_OUT);
                tween.animate("x",  -(appModel.thumbScrollbarPosition * (thumbnailsHolder.width - maskObject.width)));
                Starling.juggler.add(tween);
            }
    }

    private function resizeHandler(event:flash.events.Event):void {
        maskObject = new Quad(appModel.appwidth-60, 258, 0x000000);
        maskedThumbnails.mask = maskObject;
    }

    private function thumbnailClickedHandler(event:starling.events.Event):void {
        var clickedThumb = event.target as Thumbnail;
        appModel.selectedPageIndex = arrThumbnails.indexOf(clickedThumb);
    }

    private function pageIndexChangedHandler(event:flash.events.Event):void {
        display(appModel.selectedPageIndex);

//        for(var i:int = 0; i<arrThumbnails.length; i++){
//            var image:DisplayObject = arrThumbnails[i];
//            var xPos:Number = 0;
//
//            xPos = ((i - appModel.selectedPageIndex) * (Thumbnail.MAXWIDTH + 25)) + (maskObject.width/2 - Thumbnail.MAXWIDTH/2);
//
//            if(i == appModel.selectedPageIndex){
//                trace(xPos);
//            }
//            image.x = xPos;
//        }

        appModel.thumbScrollbarPosition = appModel.selectedPageIndex / (appModel.pages.length-1);
    }

    public function display(indexToSetActive:int):void {

        for (var i:int = 0; i<arrThumbnails.length; i++){
            if(i != indexToSetActive){
                arrThumbnails[i].active=false;
            }else{
                arrThumbnails[i].active = true;
            }
        }
    }
}
}
