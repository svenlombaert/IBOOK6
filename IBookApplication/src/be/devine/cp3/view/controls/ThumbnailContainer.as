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

import starling.display.Quad;
import starling.display.Sprite;

public class ThumbnailContainer extends Sprite {
    private var background:Quad;
    private var appModel:AppModel;
    private var arrThumbnails:Vector.<Thumbnail> = new Vector.<Thumbnail>();
    private var thumbnailsHolder:Sprite;

    public function ThumbnailContainer() {
        appModel = AppModel.getInstance();
        background = new Quad(AppModel.instance.appwidth, AppModel.instance.appheight, Style.TIMELINECOLOR);
        background.alpha = 0.90;
        addChild(background);
        this.appModel.addEventListener(AppModel.PAGES_CHANGED, pagesChangedHandler);
        initalizeThumbnails();
    }

    private function initalizeThumbnails():void {
        //thumbnails aanmaken adhv pagina's.
        thumbnailsHolder = new Sprite();
        for each(var pageVO:PageVO in appModel.pages){
            var thumbnail:Thumbnail = new Thumbnail(new Page(pageVO));
            arrThumbnails.push(thumbnail);
        }
        var xPos = 20;
        for each(var thumbnail:Thumbnail in arrThumbnails){
            trace("XPOS: ", xPos);
            thumbnail.x = xPos;
            thumbnail.y = 258/2 - thumbnail.height/2;
            thumbnailsHolder.addChild(thumbnail);
            xPos += thumbnail.width + 20;
        }
        //addChild(thumbnailsHolder);

        var myCustomMaskDisplayObject:Quad = new Quad(960, 960, 0x000000);

        var maskedDisplayObject:PixelMaskDisplayObject = new PixelMaskDisplayObject();
        maskedDisplayObject.addChild(thumbnailsHolder);

        maskedDisplayObject.mask = myCustomMaskDisplayObject;
        addChild(maskedDisplayObject);
        maskedDisplayObject.x = appModel.appwidth/2 - myCustomMaskDisplayObject.width/2;
    }

    private function pagesChangedHandler(event:Event):void {
        initalizeThumbnails();
    }
}
}
