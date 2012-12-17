/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 11/12/12
 * Time: 12:35
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.viewmodes {
import be.devine.cp3.view.*;
import be.devine.cp3.model.AppModel;
import be.devine.cp3.config.Config;
import be.devine.cp3.utils.mask.PixelMaskDisplayObject;
import be.devine.cp3.view.Page;
import be.devine.cp3.vo.PageVO;

import flash.events.Event;

import starling.animation.Transitions;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

import starling.display.Quad;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

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
        initalizeThumbnails();
    }

    private function initalizeThumbnails():void {
        //thumbnails aanmaken adhv pagina's.
        thumbnailsHolder = new Sprite();
        var xPos:uint = 0;
        for(var i:int = 0; i<arrThumbnails.length; i++){
            arrThumbnails[i].x = xPos;
            thumbnailsHolder.addChild(arrThumbnails[i]);
            xPos += arrThumbnails[i].width + 25;
        }

        maskObject = new Quad(appModel.appwidth-60, 258, 0x000000);

        maskedThumbnails= new PixelMaskDisplayObject();
        maskedThumbnails.addChild(thumbnailsHolder);

        maskedThumbnails.mask = maskObject;
        addChild(maskedThumbnails);
    }

    private function pagesChangedHandler(event:Event):void {
        initalizeThumbnails();
    }

    private function scrollHandler(event:Event):void {
        if(thumbnailsHolder != null){
            var tween:Tween = new Tween(thumbnailsHolder, 0.3, Transitions.EASE_OUT);
            tween.animate("x",  -(appModel.thumbScrollbarPosition * (thumbnailsHolder.width - maskObject.width)));
            Starling.juggler.add(tween);
        }
    }

    private function resizeHandler(event:Event):void {
        maskObject = new Quad(appModel.appwidth-60, 258, 0x000000);
        maskedThumbnails.mask = maskObject;
    }
}
}
