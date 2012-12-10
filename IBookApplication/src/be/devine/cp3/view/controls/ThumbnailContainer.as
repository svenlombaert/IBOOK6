/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 3/12/12
 * Time: 14:34
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.controls {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.style.Style;
import be.devine.cp3.utils.mask.PixelMaskDisplayObject;
import be.devine.cp3.view.Page;
import be.devine.cp3.view.Thumbnail;
import be.devine.cp3.vo.PageVO;

import flash.events.Event;

import starling.animation.Transitions;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Quad;
import starling.display.Sprite;

public class ThumbnailContainer extends Sprite {
    private var background:Quad;
    private var appModel:AppModel;
    private var arrThumbnails:Vector.<Thumbnail> = new Vector.<Thumbnail>();
    private var thumbnailsHolder:Sprite;
    private var maskedThumbnails:PixelMaskDisplayObject;
    private var maskObject:Quad;

    //TODO: gridview met scrollbars.

    public function ThumbnailContainer() {
        appModel = AppModel.getInstance();
        background = new Quad(AppModel.instance.appwidth, AppModel.instance.appheight, Style.TIMELINECOLOR);
        background.alpha = 0.90;
        addChild(background);
        this.appModel.addEventListener(AppModel.PAGES_CHANGED, pagesChangedHandler);
        this.appModel.addEventListener(AppModel.THUMBSCROLLBARPOSITION_CHANGED, scrollHandler);
        initalizeThumbnails();
    }

    private function initalizeThumbnails():void {
        //thumbnails aanmaken adhv pagina's.
        thumbnailsHolder = new Sprite();
        for each(var pageVO:PageVO in appModel.pages){
            var thumbnail:Thumbnail = new Thumbnail(new Page(pageVO));
            arrThumbnails.push(thumbnail);
        }
        var xPos = 0;
        for each(var thumbnail:Thumbnail in arrThumbnails){
            trace("XPOS: ", xPos);
            thumbnail.x = xPos;
            thumbnailsHolder.addChild(thumbnail);
            xPos += thumbnail.width + 25;
        }
        //addChild(thumbnailsHolder);

        maskObject = new Quad(appModel.appwidth-60, 258, 0x000000);

        maskedThumbnails= new PixelMaskDisplayObject();
        maskedThumbnails.addChild(thumbnailsHolder);

        maskedThumbnails.mask = maskObject;
        addChild(maskedThumbnails);
        maskedThumbnails.x = appModel.appwidth/2 - maskObject.width/2;
        maskedThumbnails.y = 258/2 - maskedThumbnails.height/2;
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
}
}
