/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 19/12/12
 * Time: 18:04
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.viewmodes {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.utils.mask.PixelMaskDisplayObject;
import be.devine.cp3.view.viewmodes.Thumbnail;

import flash.events.Event;

import starling.animation.Transitions;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Quad;

import starling.display.Sprite;
import starling.events.Event;

public class GridviewThumbnails extends Sprite{
    private var appModel:AppModel;
    private var arrThumbnails:Vector.<Thumbnail> = new Vector.<Thumbnail>();
    private var thumbnailsHolder:Sprite;
    private var maskedThumbnails:PixelMaskDisplayObject;
    private var maskObject:Quad;

    public function GridviewThumbnails(arrThumbnails:Vector.<Thumbnail>) {
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
        var yPos:uint = 0;
        var teller:uint = 0;
        for(var i:int = 0; i<arrThumbnails.length; i++){

            arrThumbnails[i].x = xPos;
            arrThumbnails[i].y = yPos;
            arrThumbnails[i].addEventListener(Thumbnail.THUMBNAIL_CLICKED, thumbnailClickedHandler);
            thumbnailsHolder.addChild(arrThumbnails[i]);
            xPos += Thumbnail.MAXWIDTH + 25;

            teller ++;


            if(teller % 4 == 0 && teller != 0){
                yPos += Thumbnail.MAXHEIGHT + 20;
                xPos = 0;
            }

            if(teller == 16){
                teller = 0;
                //xPos += 4*(Thumbnail.MAXWIDTH + 25);
                //yPos = 0;
            }


        }

        maskObject = new Quad(appModel.appwidth-60, appModel.appheight-160, 0x000000);

        maskedThumbnails= new PixelMaskDisplayObject();
        maskedThumbnails.addChild(thumbnailsHolder);

        maskedThumbnails.mask = maskObject;
        maskedThumbnails.x = appModel.appwidth/2 - maskedThumbnails.width/2;
        addChild(maskedThumbnails);
        display(appModel.selectedPageIndex);
    }

    private function pagesChangedHandler(event:flash.events.Event):void {
        initalizeThumbnails();
    }

    private function scrollHandler(event:flash.events.Event):void {
        if(thumbnailsHolder != null){
            var tween:Tween = new Tween(thumbnailsHolder, 0.3, Transitions.EASE_OUT);
            tween.animate("y",  -(appModel.thumbScrollbarPosition * (thumbnailsHolder.height - maskObject.height)));
            Starling.juggler.add(tween);
        }
    }

    private function resizeHandler(event:flash.events.Event):void {
        maskObject = new Quad(appModel.appwidth-60, appModel.appheight - 160, 0x000000);
        maskedThumbnails.mask = maskObject;
        maskedThumbnails.x = appModel.appwidth/2 - maskedThumbnails.width/2;
    }

    private function pageIndexChangedHandler(event:flash.events.Event):void {
        display(appModel.selectedPageIndex);

        appModel.thumbScrollbarPosition = appModel.selectedPageIndex / (appModel.pages.length-1);
    }

    private function thumbnailClickedHandler(event:starling.events.Event):void {
        var clickedThumb = event.target as Thumbnail;
        appModel.selectedPageIndex = arrThumbnails.indexOf(clickedThumb);

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
